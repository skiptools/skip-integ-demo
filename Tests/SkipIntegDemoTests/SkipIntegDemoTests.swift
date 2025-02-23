import XCTest
import OSLog
import Foundation
import SkipBridge
import SkipIntegDemo

let logger: Logger = Logger(subsystem: "SkipIntegDemo", category: "Tests")

@available(macOS 13, *)
final class SkipIntegDemoTests: XCTestCase {
    override func setUp() {
        #if os(Android)
        loadPeerLibrary(packageName: "skip-integ-demo", moduleName: "SkipIntegDemo")
        #endif
    }

    func testFunctionCall() {
        XCTAssertEqual(stringFunction(), "Hello, World!")
    }

    func testAsyncFunctionCall() async throws {
        let hello = try await stringFunctionAsync()
        XCTAssertEqual(hello, "Hello, World!")
    }

    func testThrowingFunction() throws {
        do {
            try throwingFunction()
            XCTFail("expected error not thrown")
        } catch CustomError.err {
            // expected
        } catch {
            XCTFail("wrong type of error thrown: \(error)")
        }
    }

    func testStructCopyOnWrite() {
        var str = EquatableStruct(string: "ABC")
        var str2 = str
        XCTAssertEqual(str, str2)
        str2.string += "D"
        XCTAssertNotEqual(str, str2)
        str.string += "D"
        XCTAssertEqual(str, str2)
    }
}

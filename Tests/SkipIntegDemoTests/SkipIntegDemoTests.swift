import XCTest
import OSLog
import Foundation
import SkipBridgeKt
@testable import SkipIntegDemo

let logger: Logger = Logger(subsystem: "SkipIntegDemo", category: "Tests")

@available(macOS 13, *)
final class SkipIntegDemoTests: XCTestCase {
    override func setUp() {
        #if os(Android)
        loadPeerLibrary(packageName: "skip-integ-demo", moduleName: "SkipIntegDemo")
        #endif
    }

    @MainActor func testSkipIntegDemo() async throws {
        XCTAssertEqual(SkipIntegDemoModule().stringFunction(), "Hello, World!")
    }
}

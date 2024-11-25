import XCTest
import OSLog
import Foundation
@testable import SkipIntegDemo

let logger: Logger = Logger(subsystem: "SkipIntegDemo", category: "Tests")

@available(macOS 13, *)
final class SkipIntegDemoTests: XCTestCase {
    func testSkipIntegDemo() throws {
        XCTAssertEqual(SkipIntegDemoModule().stringFunction(), "Hello, World!")
    }
}


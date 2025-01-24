import Foundation

@MainActor
public class SkipIntegDemoModule {
    public init() {
    }

    public func stringFunction() -> String {
        "Hello, World!"
    }
}

//@MainActor
//public protocol WebSocketManagerDelegate: AnyObject, Sendable {

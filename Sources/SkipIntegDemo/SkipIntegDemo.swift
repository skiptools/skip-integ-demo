import Foundation

public class SkipIntegDemoModule {
    public init() {
    }
}

public func stringFunction() -> String {
    "Hello, World!"
}

public func stringFunctionAsync() async throws -> String {
    "Hello, World!"
}

public func throwingFunction() throws {
    throw CustomError.err
}

public enum CustomError : Error {
    case err
}

public struct EquatableStruct : Equatable {
    public var string: String

    public init(string: String) {
        self.string = string
    }
}

public enum CityType {
    case cool(Float)
    case warm(Int)
}

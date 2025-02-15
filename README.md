# Skip Native Integration Demo

This project demonstrates bridging between Swift and Kotlin 
using the [SkipFuse](https://skip.tools/docs/modules/skip-fuse/) framework,
as part of Skip's [native](https://skip.tools/docs/modes/) mode.

It is meant as a showcase of how bridging is generated and
used, both at build time and runtime.

## Examples

### Function

#### Swift

```swift
public func stringFunction() -> String {
    "Hello, World!"
}
```

#### Kotlin

```kotlin
fun stringFunction(): String = Swift_stringFunction_0()

private external fun Swift_stringFunction_0(): String
```


### Async Function

#### Swift

```swift
public func stringFunctionAsync() async throws -> String {
    "Hello, World!"
}
```

#### Kotlin

```kotlin
suspend fun stringFunctionAsync(): String = Async.run {
    kotlin.coroutines.suspendCoroutine { f_continuation ->
        Swift_callback_stringFunctionAsync_1() { f_return, f_error ->
            if (f_error != null) {
                f_continuation.resumeWith(kotlin.Result.failure(f_error))
            } else {
                f_continuation.resumeWith(kotlin.Result.success(f_return!!))
            }
        }
    }
}

private external fun Swift_callback_stringFunctionAsync_1(f_callback: (String?, Throwable?) -> Unit)
```


### Throwing Function with Custom Error

#### Swift

```swift
public func throwingFunction() throws {
    throw CustomError.err
}

public enum CustomError : Error {
    case err
}
```

#### Kotlin

```kotlin
fun throwingFunction(): Unit = Swift_throwingFunction_2()

private external fun Swift_throwingFunction_2()

sealed class CustomError: Exception(), Error, skip.lib.SwiftProjecting {

    class ErrCase: CustomError() {
        override fun equals(other: Any?): Boolean = other is ErrCase
        override fun hashCode(): Int = "ErrCase".hashCode()
    }

    override fun Swift_projection(options: Int): () -> Any = Swift_projectionImpl(options)
    private external fun Swift_projectionImpl(options: Int): () -> Any

    companion object {
        val err: CustomError
            get() = ErrCase()
    }
}
```

### Class

#### Swift

```swift
public class SkipIntegDemoModule {
    public init() {
    }
}
```

#### Kotlin

```kotlin
open class SkipIntegDemoModule: skip.bridge.kt.SwiftPeerBridged, skip.lib.SwiftProjecting {
    var Swift_peer: skip.bridge.kt.SwiftObjectPointer = skip.bridge.kt.SwiftObjectNil

    constructor(Swift_peer: skip.bridge.kt.SwiftObjectPointer, marker: skip.bridge.kt.SwiftPeerMarker?) {
        this.Swift_peer = Swift_peer
    }

    fun finalize() {
        Swift_release(Swift_peer)
        Swift_peer = skip.bridge.kt.SwiftObjectNil
    }
    private external fun Swift_release(Swift_peer: skip.bridge.kt.SwiftObjectPointer)

    override fun Swift_peer(): skip.bridge.kt.SwiftObjectPointer = Swift_peer

    override fun equals(other: Any?): Boolean {
        if (other !is skip.bridge.kt.SwiftPeerBridged) return false
        return Swift_peer == other.Swift_peer()
    }

    override fun hashCode(): Int = Swift_peer.hashCode()

    constructor() {
        Swift_peer = Swift_constructor_0()
    }
    private external fun Swift_constructor_0(): skip.bridge.kt.SwiftObjectPointer

    override fun Swift_projection(options: Int): () -> Any = Swift_projectionImpl(options)
    private external fun Swift_projectionImpl(options: Int): () -> Any

    companion object: CompanionClass() {
    }
    open class CompanionClass {
    }
}
```

### Equatable Struct

#### Swift

```swift
public struct EquatableStruct : Equatable {
    public var string: String

    public init(string: String) {
        self.string = string
    }
}
```

#### Kotlin

```kotlin
class EquatableStruct: MutableStruct, skip.bridge.kt.SwiftPeerBridged, skip.lib.SwiftProjecting {
    var Swift_peer: skip.bridge.kt.SwiftObjectPointer = skip.bridge.kt.SwiftObjectNil

    constructor(Swift_peer: skip.bridge.kt.SwiftObjectPointer, marker: skip.bridge.kt.SwiftPeerMarker?) {
        this.Swift_peer = Swift_peer
    }

    fun finalize() {
        Swift_release(Swift_peer)
        Swift_peer = skip.bridge.kt.SwiftObjectNil
    }
    private external fun Swift_release(Swift_peer: skip.bridge.kt.SwiftObjectPointer)

    override fun Swift_peer(): skip.bridge.kt.SwiftObjectPointer = Swift_peer

    override fun hashCode(): Int = Swift_peer.hashCode()

    var string: String
        get() = Swift_string(Swift_peer)
        set(newValue) {
            willmutate()
            try {
                Swift_string_set(Swift_peer, newValue)
            } finally {
                didmutate()
            }
        }
    private external fun Swift_string(Swift_peer: skip.bridge.kt.SwiftObjectPointer): String
    private external fun Swift_string_set(Swift_peer: skip.bridge.kt.SwiftObjectPointer, value: String)
    constructor(string: String) {
        Swift_peer = Swift_constructor_0(string)
    }
    private external fun Swift_constructor_0(string: String): skip.bridge.kt.SwiftObjectPointer
    private constructor(copy: skip.lib.MutableStruct) {
        Swift_peer = Swift_constructor_1(copy)
    }
    private external fun Swift_constructor_1(copy: skip.lib.MutableStruct): skip.bridge.kt.SwiftObjectPointer

    override var supdate: ((Any) -> Unit)? = null
    override var smutatingcount = 0
    override fun scopy(): MutableStruct = EquatableStruct(this as MutableStruct)
    override fun equals(other: Any?): Boolean {
        if (other === this) return true
        if (other !is EquatableStruct) return false
        return Swift_isequal(this, other)
    }
    private external fun Swift_isequal(lhs: EquatableStruct, rhs: EquatableStruct): Boolean

    override fun Swift_projection(options: Int): () -> Any = Swift_projectionImpl(options)
    private external fun Swift_projectionImpl(options: Int): () -> Any

    companion object {
    }
}
```


## Building

This project is a Swift Package Manager module that uses the
[Skip](https://skip.tools) plugin to transpile Swift into Kotlin.

Building the module requires that Skip be installed using 
[Homebrew](https://brew.sh) with `brew install skiptools/skip/skip`.
This will also install the necessary build prerequisites:
Kotlin, Gradle, and the Android build tools.

## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.
# skip-integ-demo

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

#### Bridged Swift

```swift
@_cdecl("Java_skip_integ_demo_SkipIntegDemoKt_Swift_1stringFunction_10")
func SkipIntegDemoKt_Swift_stringFunction_0(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer) -> JavaString {
    let f_return_swift = stringFunction()
    return f_return_swift.toJavaObject(options: [.kotlincompat])!
}
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

#### Bridged Swift

```swift
@_cdecl("Java_skip_integ_demo_SkipIntegDemoKt_Swift_1callback_1stringFunctionAsync_11")
func SkipIntegDemoKt_Swift_callback_stringFunctionAsync_1(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ f_callback: JavaObjectPointer) {
    let f_callback_swift = SwiftClosure2.closure(forJavaObject: f_callback, options: [.kotlincompat])! as (String?, JavaObjectPointer?) -> Void
    Task {
        do {
            let f_return_swift = try await stringFunctionAsync()
            f_callback_swift(f_return_swift, nil)
        } catch {
            jniContext {
                f_callback_swift(nil, JThrowable.toThrowable(error, options: [.kotlincompat])!)
            }
        }
    }
}
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

#### Bridged Swift

```swift
@_cdecl("Java_skip_integ_demo_SkipIntegDemoKt_Swift_1throwingFunction_12")
func SkipIntegDemoKt_Swift_throwingFunction_2(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer) {
    do {
        try throwingFunction()
    } catch {
        JThrowable.throw(error, options: [.kotlincompat], env: Java_env)
    }
}

@_cdecl("Java_skip_integ_demo_CustomError_Swift_1projectionImpl")
func CustomError_Swift_projectionImpl(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ options: Int32) -> JavaObjectPointer {
    let projection = CustomError.fromJavaObject(Java_target, options: JConvertibleOptions(rawValue: Int(options)))
    let factory: () -> Any = { projection }
    return SwiftClosure0.javaObject(for: factory, options: [.kotlincompat])!
}

extension CustomError: BridgedToKotlin {
    private static let Java_class = try! JClass(name: "skip/integ/demo/CustomError")
    private static let Java_Companion_class = try! JClass(name: "skip/integ/demo/CustomError$Companion")
    private static let Java_Companion = JObject(Java_class.getStatic(field: Java_class.getStaticFieldID(name: "Companion", sig: "Lskip/integ/demo/CustomError$Companion;")!, options: [.kotlincompat]))
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        let className = Java_className(of: obj!, options: options)
        return fromJavaClassName(className, obj!, options: options)
    }
    fileprivate static func fromJavaClassName(_ className: String, _ obj: JavaObjectPointer, options: JConvertibleOptions) -> Self {
        switch className {
        case "skip.integ.demo.CustomError$ErrCase":
            return .err
        default: fatalError()
        }
    }
    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        switch self {
        case .err:
            return try! Self.Java_Companion.call(method: Self.Java_Companion_err_methodID, options: options, args: [])
        }
    }
    private static let Java_Companion_err_methodID = Java_Companion_class.getMethodID(name: "getErr", sig: "()Lskip/integ/demo/CustomError;")!
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

#### Bridged Swift

```swift
@_cdecl("Java_skip_integ_demo_SkipIntegDemoModule_Swift_1release")
func SkipIntegDemoModule_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SkipIntegDemoModule.self)
}

@_cdecl("Java_skip_integ_demo_SkipIntegDemoModule_Swift_1constructor_10")
func SkipIntegDemoModule_Swift_constructor_0(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer) -> SwiftObjectPointer {
    let f_return_swift = SkipIntegDemoModule()
    return SwiftObjectPointer.pointer(to: f_return_swift, retain: true)
}

@_cdecl("Java_skip_integ_demo_SkipIntegDemoModule_Swift_1projectionImpl")
func SkipIntegDemoModule_Swift_projectionImpl(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ options: Int32) -> JavaObjectPointer {
    let projection = SkipIntegDemoModule.fromJavaObject(Java_target, options: JConvertibleOptions(rawValue: Int(options)))
    let factory: () -> Any = { projection }
    return SwiftClosure0.javaObject(for: factory, options: [.kotlincompat])!
}

extension SkipIntegDemoModule: BridgedToKotlin, BridgedToKotlinBaseClass {
    private static let Java_class = try! JClass(name: "skip/integ/demo/SkipIntegDemoModule")
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        let ptr = SwiftObjectPointer.peer(of: obj!, options: options)
        return ptr.pointee()!
    }
    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let Swift_peer = SwiftObjectPointer.pointer(to: self, retain: true)
        let constructor = Java_findConstructor(base: Self.Java_class, Self.Java_constructor_methodID)
        return try! constructor.cls.create(ctor: constructor.ctor, options: options, args: [Swift_peer.toJavaParameter(options: options), (nil as JavaObjectPointer?).toJavaParameter(options: options)])
    }
    private static let Java_constructor_methodID = Java_class.getMethodID(name: "<init>", sig: "(JLskip/bridge/kt/SwiftPeerMarker;)V")!
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

#### Bridged Swift

```swift
@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1release")
func EquatableStruct_Swift_release(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) {
    Swift_peer.release(as: SwiftValueTypeBox<EquatableStruct>.self)
}

@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1string")
func EquatableStruct_Swift_string(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer) -> JavaString {
    let peer_swift: SwiftValueTypeBox<EquatableStruct> = Swift_peer.pointee()!
    return peer_swift.value.string.toJavaObject(options: [.kotlincompat])!
}

@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1string_1set")
func EquatableStruct_Swift_string_set(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ Swift_peer: SwiftObjectPointer, _ value: JavaString) {
    let peer_swift: SwiftValueTypeBox<EquatableStruct> = Swift_peer.pointee()!
    peer_swift.value.string = String.fromJavaObject(value, options: [.kotlincompat])
}

@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1constructor_10")
func EquatableStruct_Swift_constructor_0(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ p_0: JavaString) -> SwiftObjectPointer {
    let p_0_swift = String.fromJavaObject(p_0, options: [.kotlincompat])
    let f_return_swift = SwiftValueTypeBox(EquatableStruct(string: p_0_swift))
    return SwiftObjectPointer.pointer(to: f_return_swift, retain: true)
}

@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1constructor_11")
func EquatableStruct_Swift_constructor_1(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ p_0: JavaObjectPointer) -> SwiftObjectPointer {
    let p_0_swift = EquatableStruct.fromJavaObject(p_0, options: [.kotlincompat])
    let f_return_swift = SwiftValueTypeBox(p_0_swift)
    return SwiftObjectPointer.pointer(to: f_return_swift, retain: true)
}

@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1isequal")
func EquatableStruct_Swift_isequal(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ lhs: JavaObjectPointer, _ rhs: JavaObjectPointer) -> Bool {
    let lhs_swift = EquatableStruct.fromJavaObject(lhs, options: [.kotlincompat])
    let rhs_swift = EquatableStruct.fromJavaObject(rhs, options: [.kotlincompat])
    return lhs_swift == rhs_swift
}

@_cdecl("Java_skip_integ_demo_EquatableStruct_Swift_1projectionImpl")
func EquatableStruct_Swift_projectionImpl(_ Java_env: JNIEnvPointer, _ Java_target: JavaObjectPointer, _ options: Int32) -> JavaObjectPointer {
    let projection = EquatableStruct.fromJavaObject(Java_target, options: JConvertibleOptions(rawValue: Int(options)))
    let factory: () -> Any = { projection }
    return SwiftClosure0.javaObject(for: factory, options: [.kotlincompat])!
}

extension EquatableStruct: BridgedToKotlin {
    private static let Java_class = try! JClass(name: "skip/integ/demo/EquatableStruct")
    public static func fromJavaObject(_ obj: JavaObjectPointer?, options: JConvertibleOptions) -> Self {
        let ptr = SwiftObjectPointer.peer(of: obj!, options: options)
        let box: SwiftValueTypeBox<Self> = ptr.pointee()!
        return box.value
    }
    public func toJavaObject(options: JConvertibleOptions) -> JavaObjectPointer? {
        let box = SwiftValueTypeBox(self)
        let Swift_peer = SwiftObjectPointer.pointer(to: box, retain: true)
        return try! Self.Java_class.create(ctor: Self.Java_constructor_methodID, options: options, args: [Swift_peer.toJavaParameter(options: options), (nil as JavaObjectPointer?).toJavaParameter(options: options)])
    }
    private static let Java_constructor_methodID = Java_class.getMethodID(name: "<init>", sig: "(JLskip/bridge/kt/SwiftPeerMarker;)V")!
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

# Creating mocks

All mock objects must conform to the Mock protocol and have an instance of Moxie.

```swift
import Moxie

class MockClass: Mock {
    var moxie = Moxie()
}
```

Additionally, all mock objects must be of the same type as the object being mocked. This can be accomplished via inheritence or adoption of the mocked object's protocol. If the object being mocked is not a protocol type (such as a struct), then it cannot be extended and so it must be mocked via protocol adoption.

## Inheritance
```swift
import Moxie

class ExampleClass {
    func foo() -> String {
       return "this is an example"
    }
}

class MockClass: ExampleClass, Mock {
    var moxie = Moxie()

    override func foo() -> String {
        return "this is a different example"
    }
}
```

## Protocol adoption
```swift
import Moxie

protocol ExampleProtocol {
    func foo() -> String
}

struct ExampleStruct: ExampleProtocol {
    func foo() -> String {
        return "this is an example"
    }
}

struct MockExampleStruct: ExampleProtocol, Mock {
    var moxie = Moxie()

    func foo() -> String {
        return "this is a different example"
    }
}
```

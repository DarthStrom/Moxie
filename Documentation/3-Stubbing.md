# Stubbing

First, make a mock object that adopts the Mock protocol and satisfies the type requirements for the mock.

Then in the function you want to stub you can use `value` to get the value to return.

In your test, you can use `stub` to set the stubbed value.

```swift
import Moxie
import XCTest

protocol ExampleProtocol {
    func foo() -> String
}

class ExampleClass: ExampleProtocol {
    func foo() -> String {
        return "this is an example"
    }
}

class MockExampleClass: ExampleProtocol, Mock {
    var moxie = Moxie()

    func foo() -> String {
        return value(forFunction: "foo") ?? ""
    }
}

class ExampleClassTests: XCTestCase {

    let mock = MockExampleClass()

    func testItWorks() {
        mock.stub(function: "foo", return: "this is a different example")

        XCTAssertEqual("this is a different example", mock.foo())
    }
}
```

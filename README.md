# Moxie
[![Build Status](https://travis-ci.org/DarthStrom/Moxie.svg?branch=master)](https://travis-ci.org/DarthStrom/Moxie)
A tasty mocking library for Swift

![Moxie](moxie.jpeg)

## Creating mocks
All mock objects must conform to the Mock protocol and have an instance of Moxie.

```swift
import Moxie

class MockClass: Mock {
    var moxie = Moxie()
}
```

Additionally, all mock objects must be of the same type as the object being mocked. This can be accomplished via inheritence or adoption of the mocked object's protocol. If the object being mocked is not a protocol type (such as a struct), then it cannot be extended and so it must be mocked via protocol adoption.

### Inheritance
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

### Protocol adoption
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

## Stubbing

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

You can also stub for a specific set of arguments:

```swift
import Moxie
import XCTest

protocol ExampleProtocol {
    func foo(id: Int, name: String) -> Bool
}

class ExampleClass {
    func foo(id: Int, name: String) -> Bool {
        return false
    }
}

class MockExampleClass: ExampleProtocol, Mock {
    var moxie = Moxie()

    func foo(id: Int, name: String) -> Bool {
        return value(forFunction: "foo", whenCalledWith: [id, name]) ?? false
    }
}

class ExampleClassTests: XCTestCase {

    let mock = MockExampleClass()

    func testItWorks() {
        mock.stub(function: "foo", whenCalledWith: [27, "George"], return: true)

        XCTAssertTrue(mock.foo(id: 27, name: "George"))
    }
}
```

## Verifying a function was invoked

First, make a mock object that conforms to the Mock protocol with an instance of Moxie, and which also conforms to the same protocol as the object which is being mocked.

Then in the function you want to verify, call `record` to store the invocation any time that function is called.

In the test, you can use `invocations` to get the number of times the function was called or `invoked` to get whether it was called at least once.

```swift
import Moxie
import XCTest

protocol ExampleProtocol {
    func foo(description: String)
}

class ExampleClass: ExampleProtocol {
    func foo(description: String) {
        // functionality
    }
}

class MockExampleClass: ExampleProtocol, Mock {
    var moxie = Moxie()

    func foo(description: String) {
        record(function: "foo", wasCalledWith: [description])
    }
}

class ExampleClassTests: XCTestCase {

    let mock = MockExampleClass()

    func testFooWasNotCalled() {
        XCTAssertFalse(mock.invoked(function: "foo"))
    }

    func testFooCalledWithBlankByDefault() {
        mock.foo(description: "updated")
        mock.foo(description: "updated")

        XCTAssertTrue(mock.invoked(function: "foo", with: ["updated"]))
    }

    func testFooCalledThreeTimes() {
        mock.foo(description: "thrice")
        mock.foo(description: "thrice")
        mock.foo(description: "thrice")

        XCTAssertEqual(3, mock.invocations(forFunction: "foo", with: ["thrice"]))
    }
}
```

# Verifying Invocations

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

    func testFooWasCalled() {
        mock.foo(description: "updated")
        mock.foo(description: "updated")

        XCTAssertTrue(mock.invoked(function: "foo", with: ["updated"]))
    }

    func testFooWasCalledThreeTimes() {
        mock.foo(description: "thrice")
        mock.foo(description: "thrice")
        mock.foo(description: "thrice")

        XCTAssertEqual(3, mock.invocations(forFunction: "foo", with: ["thrice"]))
    }
}
```

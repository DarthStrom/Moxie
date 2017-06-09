# Moxie
[![Build Status](https://travis-ci.org/DarthStrom/Moxie.svg?branch=master)](https://travis-ci.org/DarthStrom/Moxie)

A tasty mocking library for Swift

![Moxie](moxie.jpeg)

## Stubbing

First, make a mock object that conforms to the Mock protocol with an instance of Moxie.

Then in the function you want to stub you can use `value` to get the value to return.

In your test, you can use `stub` to set the stubbed value.

```swift
import Moxie
import XCTest

struct MockStruct: Mock {
    var moxie = Moxie()

    func foo() -> String {
        return value(forFunction: "foo") ?? ""
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testItWorks() {
        mock.stub(function: "foo", return: "bar")

        XCTAssertEqual("bar", mock.foo())
    }
}

```
You can also stub for a specific set of arguments:

```swift
import Moxie
import XCTest

struct MockStruct: Mockable {
    var moxie = Moxie()

    func validate(id: Int, name: String) -> Bool {
        return value(forFunction: "validate", whenCalledWith: id, name) ?? false
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testItWorks() {
        mock.stub(function: "validate", whenCalledWith: 27, "George", return: true)

        XCTAssertTrue(mock.validate(id: 27, name: "George"))
    }
}
```

## Verifying a function was invoked

First, make a mock object that conforms to the Mock protocol with an instance of Moxie.

Then in the function you want to verify, call `record` to store the invocation any time that function is called.

In the test, you can use `invocations` to get the number of times the function was called or `invoked` to get whether it was called at least once.

```swift
import Moxie
import XCTest

struct MockStruct: Mock {
    var moxie = Moxie()

    func update(description: String) {
        record(function: "update", wasCalledWith: description)
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testUpdateWasNotCalled() {
        XCTAssertFalse(mock.invoked(function: "update"))
    }

    func testUpdateCalledWithBlankByDefault() {
        mock.update(description: "updated")
        mock.update(description: "updated")

        XCTAssertTrue(mock.invoked(function: "update", with: "updated"))
    }

    func testUpdateCalledThreeTimes() {
        mock.update(description: "thrice")
        mock.update(description: "thrice")
        mock.update(description: "thrice")

        XCTAssertEqual(3, mock.invocations(forFunction: "update", with: "thrice"))
    }
}
```

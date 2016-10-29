# MockingBird
[![Build Status](https://travis-ci.org/DarthStrom/MockingBird.svg?branch=master)](https://travis-ci.org/DarthStrom/MockingBird)

A mocking library for Swift

Stay tuned... this is a work in progress.

## Stubbing

First, make a mock object with an instance of MockingBird.

Then in the function you want to stub you can use `valueFor` to get the value to return.

In your test, you can use `when` to set the stubbed value.

```swift
import MockingBird

struct MockStruct {
    let mb = MockingBird()

    func foo() -> String {
        return mb.valueFor(function: "foo") ?? ""
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testItWorks() {
        mock.mb.stub(function: "foo", return: "bar")

        XCTAssertEqual("bar", mock.foo())
    }
}

```
You can also stub for specific set of arguments:

```swift
import MockingBird

struct MockStruct {
    let mb = MockingBird()

    func validate(id: Int, name: String) -> Bool {
        return mb.valueFor(function: "validate", withParameters: [id, name]) ?? false
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testItWorks() {
        mock.mb.stub(function: "validate", withParameters: [27, "George"], return: true)

        XCTAssertTrue(mock.validate(id: 27, name: "George"))
    }
}
```

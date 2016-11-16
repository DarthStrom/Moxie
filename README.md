# MockingBird
[![Build Status](https://travis-ci.org/DarthStrom/MockingBird.svg?branch=master)](https://travis-ci.org/DarthStrom/MockingBird)

A mocking library for Swift

Stay tuned... this is a work in progress.

## Stubbing

First, make a mock object that conforms to the Mockable protocol with an instance of MockingBird.

Then in the function you want to stub you can use `returnValue` to get the value to return.

In your test, you can use `stub` to set the stubbed value.

```swift
import MockingBird

struct MockStruct: Mockable {
    var mb = MockingBird()

    func foo() -> String {
        return returnValue(for: "foo") ?? ""
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
import MockingBird

struct MockStruct: Mockable {
    var mb = MockingBird()

    func validate(id: Int, name: String) -> Bool {
        return returnValue(for: "validate", whenCalledWith: id, name) ?? false
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

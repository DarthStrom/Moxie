# MockingBird

A mocking library for Swift

Stay tuned... this is a work in progress.

## Stubbing

First, make a mock object with a mutable instance of MockingBird.

Then in the function you want to stub you can use `valueFor` to get the value to return.

In your test, you can use `when` to set the stubbed value.

```swift
import MockingBird

struct MockStruct {
    var mb = MockingBird()

    func foo() -> String {
        return mb.valueFor("foo") ?? ""
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testItWorks() {
        mock.mb.when("foo", thenReturn: "bar")

        XCTAssertEqual("bar", mock.foo())
    }
}

```
You can also stub for specific set of arguments:

```swift
import MockingBird

struct MockStruct {
    var mb = MockingBird()

    func validate(id: Int, name: String) -> Bool {
        return mb.valueFor("validate", [id, name]) ?? false
    }
}

class StructTests: XCTestCase {

    let mock = MockStruct()

    func testItWorks() {
        mock.mb.when("validate", [27, "George"], thenReturn: true)

        XCTAssertTrue(mock.validate(27, "George"))
    }
}
```

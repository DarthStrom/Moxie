# Moxie
[![Build Status](https://travis-ci.org/DarthStrom/Moxie.svg?branch=master)](https://travis-ci.org/DarthStrom/Moxie)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/DarthStrom/Moxie/blob/master/LICENSE)
[![Pod](https://img.shields.io/cocoapods/v/Moxie.svg)](https://cocoapods.org/pods/Moxie)

A spunky mocking library for Swift

![Moxie](moxie.jpeg)

# Using Moxie

Let's say you have a protocol you want to mock.

```swift
protocol List {
    mutating func add(_ item: String)
    mutating func clear()

    func get(_ index: Int) -> String?
}
```

You can use Moxie to create a mock.

```swift
import Moxie

struct MockList: Mock, List {
    var moxie = Moxie()

    mutating func add(_ item: String) {
        record(function: "add", wasCalledWith: [item])
    }

    mutating func clear() {
        record(function: "clear")
    }

    func get(_ index: Int) -> String? {
        return value(forFunction: "get")
    }
}
```

Then you can use it in your tests.

```swift
func testList() {

    var mockList = MockList()

    // verifying invocations
    mockList.add("one")
    mockList.clear()

    XCTAssertTrue(mockList.invoked(function: "add"))
    XCTAssertEqual("one", mockList.parameters(forFunction: "add")[0] as? String)
    XCTAssertTrue(mockList.invoked(function: "clear"))

    // stubbing
    mockList.stub(function: "get", return: "first")

    XCTAssertEqual("first", mockList.get(0))
}
```

# Documentation
1. [Installation](https://github.com/DarthStrom/Moxie/blob/master/Documentation/1-Installation.md)
2. [Creating Mocks](https://github.com/DarthStrom/Moxie/blob/master/Documentation/2-CreatingMocks.md)
3. [Stubbing](https://github.com/DarthStrom/Moxie/blob/master/Documentation/3-Stubbing.md)
4. [Verifying Invocations](https://github.com/DarthStrom/Moxie/blob/master/Documentation/4-VerifyingInvocations.md)

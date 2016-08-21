import XCTest

import MockingBird

class MockingBirdTests: XCTestCase {

    let mock = MockGreeter()

    func testWhenCanStubAFunction() {
        mock.mb.when("greet", thenReturn: "What's up")

        XCTAssertEqual("What's up", mock.greet())
    }

    func testWhenCanStubConditionally() {
        mock.mb.when("say", [1], thenReturn: "One")
        mock.mb.when("say", [2], thenReturn: "Two")

        XCTAssertEqual("One", mock.say(1))
        XCTAssertEqual("Two", mock.say(2))
    }

    func testConditionalStubbingWithStructParams() {
        mock.mb.when("getNumber", [TestStruct(num: 1, name: "Hi")], thenReturn: 5)
        mock.mb.when("getNumber", [TestStruct(num: 3, name: "Yo")], thenReturn: 2)
        let thirdStruct = TestStruct(num: 7, name: "Third")
        mock.mb.when("getNumber", [thirdStruct], thenReturn: 9)

        XCTAssertEqual(5, mock.getNumber(TestStruct(num: 1, name: "Hi")))
        XCTAssertEqual(2, mock.getNumber(TestStruct(num: 3, name: "Yo")))
        XCTAssertEqual(9, mock.getNumber(thirdStruct))
    }
}

struct TestStruct {
    let num: Int
    let name: String
}

protocol CanBeMocked {
    func greet() -> String
    func say(_ number: Int) -> String
    func getNumber(_ s: TestStruct) -> Int
}

struct MockGreeter: CanBeMocked {
    var mb = MockingBird()

    func greet() -> String {
        return mb.valueFor("greet") ?? ""
    }

    func say(_ number: Int) -> String {
        return mb.valueFor("say", [number]) ?? ""
    }

    func getNumber(_ s: TestStruct) -> Int {
        return mb.valueFor("getNumber", [s]) ?? 0
    }
}

import XCTest

import MockingBird

class StubbingTests: XCTestCase {

    let mock = MockHub()

    func testCanStubAFunction() {
        mock.mb.stub(function: "greet", return: ["What's up"])

        XCTAssertEqual("What's up", mock.greet())
    }

    func testCanStubConditionally() {
        mock.mb.stub(function: "say", whenCalledWith: [1], return: ["One"])
        mock.mb.stub(function: "say", whenCalledWith: [2], return: ["Two"])

        XCTAssertEqual("One", mock.say(1))
        XCTAssertEqual("Two", mock.say(2))
    }

    func testConditionalStubbingWithStructParams() {
        mock.mb.stub(function: "getNumber", whenCalledWith: [TestStruct(num: 1, name: "Hi")], return: [5])
        mock.mb.stub(function: "getNumber", whenCalledWith: [TestStruct(num: 3, name: "Yo")], return: [2])
        let thirdStruct = TestStruct(num: 7, name: "Third")
        mock.mb.stub(function: "getNumber", whenCalledWith: [thirdStruct], return: [9])

        XCTAssertEqual(5, mock.getNumber(from: TestStruct(num: 1, name: "Hi")))
        XCTAssertEqual(2, mock.getNumber(from: TestStruct(num: 3, name: "Yo")))
        XCTAssertEqual(9, mock.getNumber(from: thirdStruct))
    }

    func testLastInWins() {
        mock.mb.stub(function: "say", whenCalledWith: [2], return: ["One"])
        mock.mb.stub(function: "say", whenCalledWith: [2], return: ["Two"])

        XCTAssertEqual("Two", mock.say(2))
    }

    func testSequentialStubbing() {
        mock.mb.stub(function: "say", whenCalledWith: [2], return: ["One", "Two"])

        XCTAssertEqual("One", mock.say(2))
        XCTAssertEqual("Two", mock.say(2))
        XCTAssertEqual("Two", mock.say(2))
    }
}

struct TestStruct {
    let num: Int
    let name: String
}

protocol InfoHub {
    func greet() -> String
    func say(_: Int) -> String
    func getNumber(from: TestStruct) -> Int
}

struct MockHub: InfoHub {
    var mb = MockingBird()

    func greet() -> String {
        return mb.value(forFunction: "greet") ?? ""
    }

    func say(_ number: Int) -> String {
        return mb.value(forFunction: "say", whenCalledWith: [number]) ?? ""
    }

    func getNumber(from s: TestStruct) -> Int {
        return mb.value(forFunction: "getNumber", whenCalledWith: [s]) ?? 0
    }
}

import XCTest
import Moxie

class StubbingTests: XCTestCase {

    let mock = MockHub()

    func testCanStubAFunction() {
        mock.moxie.stub(function: "greet", return: ["What's up"])

        XCTAssertEqual("What's up", mock.greet())
    }

    func testLastInWins() {
        mock.moxie.stub(function: "say", return: ["One"])
        mock.moxie.stub(function: "say", return: ["Two"])

        XCTAssertEqual("Two", mock.say(2))
    }

    func testSequentialStubbing() {
        mock.moxie.stub(function: "say", return: ["One", "Two"])

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
    func say(_: Int) -> String?
}

struct MockHub: InfoHub {
    var moxie = Moxie()

    func greet() -> String {
        return moxie.value(forFunction: "greet") ?? "nope"
    }

    func say(_ number: Int) -> String? {
        return moxie.value(forFunction: "say")
    }
}

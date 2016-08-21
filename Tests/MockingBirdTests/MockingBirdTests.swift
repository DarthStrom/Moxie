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
}

protocol CanBeMocked {
    func greet() -> String
    func say(_ number: Int) -> String
}

struct MockGreeter: CanBeMocked {
    var mb = MockingBird()

    func greet() -> String {
        return mb.valueFor("greet") ?? ""
    }

    func say(_ number: Int) -> String {
        return mb.valueFor("say", [number]) ?? ""
    }
}

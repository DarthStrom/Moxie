import XCTest

import MockingBird

class MockingBirdTests: XCTestCase {

    let mock = MockGreeter()

    func testWhenCanStubAFunction() {
        mock.mb.when("greet", thenReturn: "What's up")

        XCTAssertEqual("What's up", mock.greet())
    }

    func testWhenCanStubAnotherFunction() {
        mock.mb.when("greet", thenReturn: "Yo")

        XCTAssertEqual("Yo", mock.greet())
    }
}

protocol GreetsYou {
    func greet() -> String
}

struct MockGreeter: GreetsYou {
    var mb = MockingBird()

    func greet() -> String {
        print(mb.valueFor("greet"))
        return mb.valueFor("greet") ?? ""
    }
}

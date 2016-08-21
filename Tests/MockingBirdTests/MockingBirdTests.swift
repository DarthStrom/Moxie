import XCTest

import MockingBird

class MockingBirdTests: XCTestCase {

    var mb = MockingBird()

    func testWhenCanStubAFunction() {
        let testDouble = mb.create()
        mb.when(testDouble(), thenReturn: "What's up")

        let result = testDouble()

        XCTAssertEqual("What's up", result)
    }

}

import XCTest

import MockingBird

class VerificationTests: XCTestCase {

    var subject: Tested!

    override func setUp() {
        subject = Tested()
    }

    func testCallCountForZeroCalls() {
        XCTAssertEqual(0, subject.mb.callCount("submit", ["nope"]))
    }

    func testCallCountForOneCall() {
        subject.submit("yep")

        XCTAssertEqual(1, subject.mb.callCount("submit", ["yep"]))
    }

    func testCallCountForMultipleCalls() {
        subject.submit("three")
        subject.submit("three")
        subject.submit("three")

        XCTAssertEqual(3, subject.mb.callCount("submit", ["three"]))
    }

    func testVerifyIsTrueIfCallCountWasOne() {
        subject.submit("one")

        XCTAssert(subject.mb.verify("submit", ["one"]))
    }

    func testVerifyIsFalseIfCallCountWasZero() {
        XCTAssertFalse(subject.mb.verify("submit", ["zero"]))
    }

    func testVerifyIsTrueIfCallCountWasMoreThanOne() {
        subject.submit("two")
        subject.submit("two")

        XCTAssert(subject.mb.verify("submit", ["two"]))
    }
}

protocol Testable {
    func submit(_ description: String)
}

struct Tested: Testable {
    let mb = MockingBird()

    func submit(_ description: String) {
        mb.record("submit", [description])
    }
}

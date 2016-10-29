import XCTest

import MockingBird

class VerificationTests: XCTestCase {

    var subject: Tested!

    override func setUp() {
        subject = Tested()
    }

    func testCallCountForZeroCalls() {
        XCTAssertEqual(0, subject.mb.callCount(forFunction: "submit", withParameters: ["nope"]))
    }

    func testCallCountForOneCall() {
        subject.submit(description: "yep")

        XCTAssertEqual(1, subject.mb.callCount(forFunction: "submit", withParameters: ["yep"]))
    }

    func testCallCountForMultipleCalls() {
        subject.submit(description: "three")
        subject.submit(description: "three")
        subject.submit(description: "three")

        XCTAssertEqual(3, subject.mb.callCount(forFunction: "submit", withParameters: ["three"]))
    }

    func testVerifyIsTrueIfCallCountWasOne() {
        subject.submit(description: "one")

        XCTAssert(subject.mb.verify(function: "submit", calledWithParameters: ["one"]))
    }

    func testVerifyIsFalseIfCallCountWasZero() {
        XCTAssertFalse(subject.mb.verify(function: "submit", calledWithParameters: ["zero"]))
    }

    func testVerifyIsTrueIfCallCountWasMoreThanOne() {
        subject.submit(description: "two")
        subject.submit(description: "two")

        XCTAssert(subject.mb.verify(function: "submit", calledWithParameters: ["two"]))
    }
}

protocol Testable {
    func submit(description: String)
}

struct Tested: Testable {
    let mb = MockingBird()

    func submit(description: String) {
        mb.record(function: "submit", withParameters: [description])
    }
}

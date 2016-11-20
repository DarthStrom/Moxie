import XCTest

import MockingBird

class VerificationTests: XCTestCase {

    var subject: Tested!

    override func setUp() {
        subject = Tested()
    }

    func testInvocationCountForZeroCalls() {
        XCTAssertEqual(0, subject.mb.invocations(forFunction: "submit", with: ["nope"]))
    }

    func testInvocationCountForOneCall() {
        subject.submit("yep")

        XCTAssertEqual(1, subject.mb.invocations(forFunction: "submit", with: ["yep"]))
    }

    func testInvocationCountForMultipleCalls() {
        subject.submit("three")
        subject.submit("three")
        subject.submit("three")

        XCTAssertEqual(3, subject.mb.invocations(forFunction: "submit", with: ["three"]))
    }

    func testVerifyIsTrueIfCallCountWasOne() {
        subject.submit("one")

        XCTAssert(subject.mb.invoked(function: "submit", with: ["one"]))
    }

    func testVerifyIsFalseIfCallCountWasZero() {
        XCTAssertFalse(subject.mb.invoked(function: "submit", with: ["zero"]))
    }

    func testVerifyIsTrueIfCallCountWasMoreThanOne() {
        subject.submit("two")
        subject.submit("two")

        XCTAssert(subject.mb.invoked(function: "submit", with: ["two"]))
    }
}

protocol Testable {
    func submit(_ description: String)
}

struct Tested: Testable {
    let mb = MockingBird()

    func submit(_ description: String) {
        mb.record(function: "submit", wasCalledWith: [description])
    }
}

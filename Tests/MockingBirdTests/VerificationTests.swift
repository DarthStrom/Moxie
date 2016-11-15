import XCTest

import MockingBird

class VerificationTests: XCTestCase {

    var subject: Tested!

    override func setUp() {
        subject = Tested()
    }

    func testInvocationCountForZeroCalls() {
        XCTAssertEqual(0, subject.mb.invocationCount(for: "submit", with: ["nope"]))
    }

    func testInvocationCountForOneCall() {
        subject.submit(description: "yep")

        XCTAssertEqual(1, subject.mb.invocationCount(for: "submit", with: ["yep"]))
    }

    func testInvocationCountForMultipleCalls() {
        subject.submit(description: "three")
        subject.submit(description: "three")
        subject.submit(description: "three")

        XCTAssertEqual(3, subject.mb.invocationCount(for: "submit", with: ["three"]))
    }

    func testVerifyIsTrueIfCallCountWasOne() {
        subject.submit(description: "one")

        XCTAssert(subject.mb.verify(function: "submit", wasCalledWith: ["one"]))
    }

    func testVerifyIsFalseIfCallCountWasZero() {
        XCTAssertFalse(subject.mb.verify(function: "submit", wasCalledWith: ["zero"]))
    }

    func testVerifyIsTrueIfCallCountWasMoreThanOne() {
        subject.submit(description: "two")
        subject.submit(description: "two")

        XCTAssert(subject.mb.verify(function: "submit", wasCalledWith: ["two"]))
    }
}

protocol Testable {
    func submit(description: String)
}

struct Tested: Testable {
    let mb = MockingBird()

    func submit(description: String) {
        mb.record(invocation: "submit", with: [description])
    }
}

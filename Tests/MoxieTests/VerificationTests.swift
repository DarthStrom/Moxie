import XCTest
import Moxie

class VerificationTests: XCTestCase {

    var subject: Tested!

    override func setUp() {
        subject = Tested()
    }

    func testInvocationCountForZeroCalls() {
        XCTAssertEqual(0, subject.moxie.invocations(forFunction: "submit", with: ["nope"]))
    }

    func testInvocationCountForOneCall() {
        subject.submit("yep")

        XCTAssertEqual(1, subject.moxie.invocations(forFunction: "submit", with: ["yep"]))
    }

    func testInvocationCountForMultipleCalls() {
        subject.submit("three")
        subject.submit("three")
        subject.submit("three")

        XCTAssertEqual(3, subject.moxie.invocations(forFunction: "submit", with: ["three"]))
    }

    func testVerifyIsTrueIfCallCountWasOne() {
        subject.submit("one")

        XCTAssert(subject.moxie.invoked(function: "submit", with: ["one"]))
    }

    func testVerifyIsFalseIfCallCountWasZero() {
        XCTAssertFalse(subject.moxie.invoked(function: "submit", with: ["zero"]))
    }

    func testVerifyIsTrueIfCallCountWasMoreThanOne() {
        subject.submit("two")
        subject.submit("two")

        XCTAssert(subject.moxie.invoked(function: "submit", with: ["two"]))
    }
}

protocol Testable {
    func submit(_ description: String)
}

struct Tested: Testable {
    let moxie = Moxie()

    func submit(_ description: String) {
        moxie.record(function: "submit", wasCalledWith: [description])
    }
}

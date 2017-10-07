import XCTest
import Moxie

class VerificationTests: XCTestCase {

    var subject: Tested!

    override func setUp() {
        subject = Tested()
    }

    func testInvocationCountForZeroCalls() {
        XCTAssertEqual(0, subject.moxie.invocations(forFunction: "submit"))
    }

    func testInvocationCountForOneCall() {
        subject.submit("yep")

        XCTAssertEqual(1, subject.moxie.invocations(forFunction: "submit"))
        XCTAssertEqual("yep", subject.moxie.parameters(forFunction: "submit")[0] as? String)
    }

    func testInvocationCountForMultipleCalls() {
        subject.submit("one")
        subject.submit("two")
        subject.submit("three")

        XCTAssertEqual(3, subject.moxie.invocations(forFunction: "submit"))
        XCTAssertEqual("one", subject.moxie.parameters(forFunction: "submit")[0] as? String)
        XCTAssertEqual("two", subject.moxie.parameters(forFunction: "submit", invocation: 2)[0] as? String)
        XCTAssertEqual("three", subject.moxie.parameters(forFunction: "submit", invocation: 3)[0] as? String)
    }

    func testVerifyIsTrueIfCallCountWasOne() {
        subject.submit("one")

        XCTAssert(subject.moxie.invoked(function: "submit"))
    }

    func testVerifyIsFalseIfCallCountWasZero() {
        XCTAssertFalse(subject.moxie.invoked(function: "submit"))
    }

    func testVerifyIsTrueIfCallCountWasMoreThanOne() {
        subject.submit("two")
        subject.submit("two")

        XCTAssert(subject.moxie.invoked(function: "submit"))
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

import XCTest
import MockingBird

class MockableTests: XCTestCase {
    
    var subject = Subject()

    func testRecordWithNoParameters() {
        subject.record(invocation: "something")

        XCTAssertEqual(1, subject.invocationCount(for: "something"))
    }

    func testRecordWithASpecificSetOfParameters() {
        subject.record(invocation: "something", with: 1, "5")
        subject.record(invocation: "something")

        XCTAssertEqual(1, subject.invocationCount(for: "something", with: 1, "5"))
    }

    func testInvocationCountForWrongParameters() {
        subject.record(invocation: "something", with: 1, 2)

        XCTAssertEqual(0, subject.invocationCount(for: "something", with: 1, 3))
    }

    func testVerifyReturnsTrueWhenFunctionWasCalled() {
        subject.record(invocation: "something")

        XCTAssertTrue(subject.verify(function: "something"))
    }

    func testVerifyReturnsFalseWhenFunctionWasNotCalled() {
        XCTAssertFalse(subject.verify(function: "something"))
    }

    func testVerifyReturnsTrueWhenCalledWithMatchingParameters() {
        subject.record(invocation: "something", with: 1, "two")

        XCTAssertTrue(subject.verify(function: "something", wasCalledWith: 1, "two"))
    }

    func testVerifyReturnsFalseWhenCalledWithTheWrongParameters() {
        subject.record(invocation: "something", with: "One", 2)

        XCTAssertFalse(subject.verify(function: "something", wasCalledWith: 1, 2))
    }

    func testStubbingWithNoReturnValue() {
        subject.stub(function: "noparams")

        XCTAssertNil(subject.noparams())
    }

    func testStubbingNil() {
        subject.stub(function: "noparams", return: nil)

        XCTAssertNil(subject.noparams())
    }

    func testStubbingSomething() {
        subject.stub(function: "noparams", return: "something")

        XCTAssertEqual("something", subject.noparams() as? String)
    }

    func testStubbingWithParametersWithNoReturnValue() {
        subject.stub(function: "twoparams", whenCalledWith: 2, return: 1)

        XCTAssertNil(subject.twoparams(x: 1, y: 2))
    }

    func testStubbingWithParametersWithNilReturnValue() {
        subject.stub(function: "twoparams", whenCalledWith: 1, 2, return: nil)

        XCTAssertNil(subject.twoparams(x: 1, y: 2))
    }

    func testStubbingWithParametersWithAReturnValue() {
        subject.stub(function: "twoparams", whenCalledWith: 2, 3, return: 5)

        XCTAssertEqual(5, subject.twoparams(x: 2, y: 3) as? Int)
    }
}

class Subject: Mockable {
    var mb = MockingBird()

    func noparams() -> Any? {
        return returnValue(for: "noparams")
    }

    func twoparams(x: Int, y: Int) -> Any? {
        return returnValue(for: "twoparams", whenCalledWith: x, y)
    }
}

import XCTest
import Moxie

class MockTests: XCTestCase {
    
    var subject = Subject()

    func testRecordWithNoParameters() {
        subject.record(function: "something")

        XCTAssertEqual(1, subject.invocations(forFunction: "something"))
    }

    func testRecordWithASpecificSetOfParameters() {
        subject.record(function: "something", wasCalledWith: [1, "5"])
        subject.record(function: "something")

        XCTAssertEqual(1, subject.invocations(forFunction: "something", with: [1, "5"]))
    }

    func testInvocationCountForWrongParameters() {
        subject.record(function: "something", wasCalledWith: [1, 2])

        XCTAssertEqual(0, subject.invocations(forFunction: "something", with: [1, 3]))
    }

    func testVerifyReturnsTrueWhenFunctionWasCalled() {
        subject.record(function: "something")

        XCTAssertTrue(subject.invoked(function: "something"))
    }

    func testVerifyReturnsFalseWhenFunctionWasNotCalled() {
        XCTAssertFalse(subject.invoked(function: "something"))
    }

    func testVerifyReturnsTrueWhenCalledWithMatchingParameters() {
        subject.record(function: "something", wasCalledWith: [1, "two"])

        XCTAssertTrue(subject.invoked(function: "something", with: [1, "two"]))
    }

    func testVerifyReturnsFalseWhenCalledWithTheWrongParameters() {
        subject.record(function: "something", wasCalledWith: ["One", 2])

        XCTAssertFalse(subject.invoked(function: "something", with: [1, 2]))
    }

    func testStubbingWithNoReturnValue() {
        subject.stub(function: "noparams")

        XCTAssertNil(subject.noparams())
    }

    func testStubbingNil() {
        subject.stub(function: "noparams")

        dump(subject.noparams())
        XCTAssertNil(subject.noparams())
    }

    func testStubbingSomething() {
        subject.stub(function: "noparams", return: "something")

        XCTAssertEqual("something", subject.noparams() as? String)
    }

    func testStubbingWithParametersWithNoReturnValue() {
        subject.stub(function: "twoparams", whenCalledWith: [2], return: 1)

        XCTAssertNil(subject.twoparams(x: 1, y: 2))
    }

    func testStubbingWithParametersWithNilReturnValue() {
        subject.stub(function: "twoparams", whenCalledWith: [1, 2])

        XCTAssertNil(subject.twoparams(x: 1, y: 2))
    }

    func testStubbingWithParametersWithAReturnValue() {
        subject.stub(function: "twoparams", whenCalledWith: [2, 3], return: 5)

        XCTAssertEqual(5, subject.twoparams(x: 2, y: 3) as? Int)
    }

    func testExplain() {
        XCTAssertEqual("This function has 0 stubbings and 0 invocations.",
                       subject.interactions(withFunction: "not there"))
    }
}

class Subject: Mock {
    var moxie = Moxie()

    func noparams() -> Any? {
        return value(forFunction: "noparams")
    }

    func twoparams(x: Int, y: Int) -> Any? {
        return value(forFunction: "twoparams", whenCalledWith: [x, y])
    }
}

import XCTest

extension ExplainTests {
    static let __allTests = [
        ("testExplainWithAnInvocation", testExplainWithAnInvocation),
        ("testExplainWithBothStubbingsAndInvocations", testExplainWithBothStubbingsAndInvocations),
        ("testExplainWithMultipleInvocations", testExplainWithMultipleInvocations),
        ("testExplainWithMultipleInvocationsWithTheSameParameters", testExplainWithMultipleInvocationsWithTheSameParameters),
        ("testExplainWithMultipleStubbings", testExplainWithMultipleStubbings),
        ("testExplainWithNoStubbingsOrInteractions", testExplainWithNoStubbingsOrInteractions),
        ("testExplainWithOneStubbing", testExplainWithOneStubbing),
    ]
}

extension MockTests {
    static let __allTests = [
        ("testExplain", testExplain),
        ("testRecordWithASpecificSetOfParameters", testRecordWithASpecificSetOfParameters),
        ("testRecordWithNoParameters", testRecordWithNoParameters),
        ("testStubbingSomething", testStubbingSomething),
        ("testStubbingWithNoReturnValue", testStubbingWithNoReturnValue),
        ("testStubbingWithParametersWithAReturnValue", testStubbingWithParametersWithAReturnValue),
        ("testStubbingWithParametersWithNilReturnValue", testStubbingWithParametersWithNilReturnValue),
        ("testVerifyReturnsFalseWhenFunctionWasNotCalled", testVerifyReturnsFalseWhenFunctionWasNotCalled),
        ("testVerifyReturnsTrueWhenCalledWithMatchingParameters", testVerifyReturnsTrueWhenCalledWithMatchingParameters),
        ("testVerifyReturnsTrueWhenFunctionWasCalled", testVerifyReturnsTrueWhenFunctionWasCalled),
    ]
}

extension StubbingTests {
    static let __allTests = [
        ("testCanStubAFunction", testCanStubAFunction),
        ("testLastInWins", testLastInWins),
        ("testSequentialStubbing", testSequentialStubbing),
    ]
}

extension VerificationTests {
    static let __allTests = [
        ("testInvocationCountForMultipleCalls", testInvocationCountForMultipleCalls),
        ("testInvocationCountForOneCall", testInvocationCountForOneCall),
        ("testInvocationCountForZeroCalls", testInvocationCountForZeroCalls),
        ("testVerifyIsFalseIfCallCountWasZero", testVerifyIsFalseIfCallCountWasZero),
        ("testVerifyIsTrueIfCallCountWasMoreThanOne", testVerifyIsTrueIfCallCountWasMoreThanOne),
        ("testVerifyIsTrueIfCallCountWasOne", testVerifyIsTrueIfCallCountWasOne),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ExplainTests.__allTests),
        testCase(MockTests.__allTests),
        testCase(StubbingTests.__allTests),
        testCase(VerificationTests.__allTests),
    ]
}
#endif

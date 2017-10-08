import XCTest
import Moxie

class ExplainTests: XCTestCase {

    var subject: Explainer!

    override func setUp() {
        subject = Explainer()
    }

    func testExplainWithNoStubbingsOrInteractions() {
        XCTAssertEqual("This function has 0 stubbings and 0 invocations.",
                       subject.moxie.interactions(withFunction: "doIt"))
    }

    func testExplainWithOneStubbing() {
        subject.moxie.stub(function: "returnIt", return: ["it"])

        XCTAssertEqual(
            "This function has 1 stubbing and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - Return `it`.",
            subject.moxie.interactions(withFunction: "returnIt"))
    }

    func testExplainWithMultipleStubbings() {
        subject.moxie.stub(function: "mirror", return: ["me", "you"])

        XCTAssertEqual(
            "This function has 2 stubbings and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - Return `me`.\n" +
            "  - Return `you`.",
            subject.moxie.interactions(withFunction: "mirror"))
    }

    func testExplainWithAnInvocation() {
        subject.doIt("now")

        XCTAssertEqual(
            "This function has 0 stubbings and 1 invocation.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"now\"]`.",
            subject.moxie.interactions(withFunction: "doIt"))
    }

    func testExplainWithMultipleInvocations() {
        subject.doIt("monday")
        subject.doIt("tuesday")

        XCTAssertEqual(
            "This function has 0 stubbings and 2 invocations.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"monday\"]`.\n" +
            "  - Called with `[\"tuesday\"]`.",
            subject.moxie.interactions(withFunction: "doIt"))
    }

    func testExplainWithMultipleInvocationsWithTheSameParameters() {
        subject.doIt("wednesday")
        subject.doIt("wednesday")

        XCTAssertEqual(
            "This function has 0 stubbings and 2 invocations.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"wednesday\"]`.\n" +
            "  - Called with `[\"wednesday\"]`.",
            subject.moxie.interactions(withFunction: "doIt"))
    }

    func testExplainWithBothStubbingsAndInvocations() {
        subject.moxie.stub(function: "mirror", return: ["man", "Michael Jackson"])

        subject.mirror("thursday")

        XCTAssertEqual(
            "This function has 2 stubbings and 1 invocation.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - Return `man`.\n" +
            "  - Return `Michael Jackson`.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"thursday\"]`.",
            subject.moxie.interactions(withFunction: "mirror"))
    }
}

protocol Explainable {
    func doIt(_: String)
    func mirror(_ whom: String)
}

struct Explainer: Explainable {
    let moxie = Moxie()

    func doIt(_ param: String) {
        moxie.record(function: "doIt", wasCalledWith: [param])
    }

    func mirror(_ whom: String) {
        moxie.record(function: "mirror", wasCalledWith: [whom])
    }
}

import XCTest

import MockingBird

class ExplainTests: XCTestCase {

    var subject: Explainer!

    override func setUp() {
        subject = Explainer()
    }

    func testExplainWithNoStubbingsOrInteractions() {
        XCTAssertEqual("This function has 0 stubbings and 0 invocations.", subject.mb.explain(function: "doIt"))
    }

    func testExplainWithOneStubbing() {
        subject.mb.stub(function: "returnIt", return: "it")

        XCTAssertEqual(
            "This function has 1 stubbing and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[]`, then return `it`.",
            subject.mb.explain(function: "returnIt"))
    }

    func testExplainWithMultipleStubbings() {
        subject.mb.stub(function: "mirror", withParameters: ["me"], return: "me")
        subject.mb.stub(function: "mirror", withParameters: ["you"], return: "you")

        XCTAssertEqual(
            "This function has 2 stubbings and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[\"me\"]`, then return `me`.\n" +
            "  - When called with `[\"you\"]`, then return `you`.",
            subject.mb.explain(function: "mirror"))
    }

    func testExplainWithAnInvocation() {
        subject.doIt(param: "now")

        XCTAssertEqual(
            "This function has 0 stubbings and 1 invocation.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"now\"]`.",
            subject.mb.explain(function: "doIt"))
    }

    func testExplainWithMultipleInvocations() {
        subject.doIt(param: "monday")
        subject.doIt(param: "tuesday")

        XCTAssertEqual(
            "This function has 0 stubbings and 2 invocations.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"monday\"]`.\n" +
            "  - Called with `[\"tuesday\"]`.",
            subject.mb.explain(function: "doIt"))
    }

    func testExplainWithMultipleInvocationsWithTheSameParameters() {
        subject.doIt(param: "wednesday")
        subject.doIt(param: "wednesday")

        XCTAssertEqual(
            "This function has 0 stubbings and 2 invocations.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"wednesday\"]` x2.",
            subject.mb.explain(function: "doIt"))
    }

    func testExplainWithBothStubbingsAndInvocations() {
        subject.mb.stub(function: "mirror", withParameters: ["Michael Jackson"], return: "man")
        subject.mb.stub(function: "mirror", withParameters: ["man"], return: "Michael Jackson")

        subject.mirror(who: "thursday")

        XCTAssertEqual(
            "This function has 2 stubbings and 1 invocation.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[\"Michael Jackson\"]`, then return `man`.\n" +
            "  - When called with `[\"man\"]`, then return `Michael Jackson`.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"thursday\"]`.",
            subject.mb.explain(function: "mirror"))
    }
}

protocol Explainable {
    func doIt(param: String)
    func mirror(who: String)
}

struct Explainer: Explainable {
    let mb = MockingBird()

    func doIt(param: String) {
        mb.record(function: "doIt", withParameters: [param])
    }

    func mirror(who: String) {
        mb.record(function: "mirror", withParameters: [who])
    }
}

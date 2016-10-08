import XCTest

import MockingBird

class ExplainTests: XCTestCase {

    var subject: Explainer!

    override func setUp() {
        subject = Explainer()
    }

    func testExplainCallCountWithNoStubbingsOrInteractions() {
        XCTAssertEqual(0, subject.mb.explain("doIt").callCount)
    }

    func testExplainCallCountWithOneInteraction() {
        subject.doIt("now")

        XCTAssertEqual(1, subject.mb.explain("doIt").callCount)
    }

    func testExplainCallCountWithMultipleInteractions() {
        subject.doIt("yesterday")
        subject.doIt("today")
        subject.doIt("tomorrow")

        XCTAssertEqual(3, subject.mb.explain("doIt").callCount)
    }

    func testExplainDescriptionWithNoStubbingsOrInteractions() {
        XCTAssertEqual("This function has 0 stubbings and 0 invocations.", subject.mb.explain("doIt").description)
    }

    func testExplainDescriptionWithOneStubbing() {
        subject.mb.when("returnIt", thenReturn: "it")

        XCTAssertEqual(
            "This function has 1 stubbing and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[]`, then return `it`.",
            subject.mb.explain("returnIt").description)
    }

    func testExplainDescriptionWithMultipleStubbings() {
        subject.mb.when("mirror", ["me"], thenReturn: "me")
        subject.mb.when("mirror", ["you"], thenReturn: "you")

        XCTAssertEqual(
            "This function has 2 stubbings and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[\"me\"]`, then return `me`.\n" +
            "  - When called with `[\"you\"]`, then return `you`.",
            subject.mb.explain("mirror").description)
    }

    func testExplainDescriptionWithAnInvocation() {
        subject.doIt("now")

        XCTAssertEqual(
            "This function has 0 stubbings and 1 invocation.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"now\"]`.",
            subject.mb.explain("doIt").description)
    }

    func testExplainDescriptionWithMultipleInvocations() {
        subject.doIt("monday")
        subject.doIt("tuesday")

        XCTAssertEqual(
            "This function has 0 stubbings and 2 invocations.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"monday\"]`.\n" +
            "  - Called with `[\"tuesday\"]`.",
            subject.mb.explain("doIt").description)
    }

    func testExplainDescriptionWithMultipleInvocationsWithTheSameParameters() {
        subject.doIt("wednesday")
        subject.doIt("wednesday")

        XCTAssertEqual(
            "This function has 0 stubbings and 2 invocations.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"wednesday\"]` x2.",
            subject.mb.explain("doIt").description)
    }

    func testExplainDescriptionWithBothStubbingsAndInvocations() {
        subject.mb.when("mirror", ["Michael Jackson"], thenReturn: "man")
        subject.mb.when("mirror", ["man"], thenReturn: "Michael Jackson")

        subject.mirror("thursday")

        XCTAssertEqual(
            "This function has 2 stubbings and 1 invocation.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[\"Michael Jackson\"]`, then return `man`.\n" +
            "  - When called with `[\"man\"]`, then return `Michael Jackson`.\n" +
            "\n" +
            "  Invocations:\n" +
            "  - Called with `[\"thursday\"]`.",
            subject.mb.explain("mirror").description)
    }
}

protocol Explainable {
    func doIt(_ param: String)
    func mirror(_ who: String)
}

struct Explainer: Explainable {
    let mb = MockingBird()

    func doIt(_ param: String) {
        mb.record("doIt", [param])
    }

    func mirror(_ who: String) {
        mb.record("mirror", [who])
    }
}

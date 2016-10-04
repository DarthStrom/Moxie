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
        XCTAssertEqual("This mock has 0 stubbings and 0 invocations.", subject.mb.explain("doIt").description)
    }

    func testExplainDescriptionWithOneStubbing() {
        subject.mb.when("returnIt", thenReturn: "it")

        XCTAssertEqual(
            "This mock has 1 stubbing and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[]`, then return `it`.",
            subject.mb.explain("returnIt").description)
    }

    func testExplainDescriptionWithMultipleStubbings() {
        subject.mb.when("mirror", ["me"], thenReturn: "me")
        subject.mb.when("mirror", ["you"], thenReturn: "you")

        XCTAssertEqual(
            "This mock has 2 stubbings and 0 invocations.\n" +
            "\n" +
            "  Stubbings:\n" +
            "  - When called with `[\"me\"]`, then return `me`." +
            "  - When called with `[\"you\"]`, then return `you`.",
            subject.mb.explain("mirror").description)
    }
}

protocol Explainable {
    func doIt(_ param: String)
}

struct Explainer: Explainable {
    let mb = MockingBird()

    func doIt(_ param: String) {
        mb.record("doIt", [param])
    }
}

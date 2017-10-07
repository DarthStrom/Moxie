//
//  ArgumentCaptureTests.swift
//  Moxie
//
//  Created by Jason Duffy on 10/1/17.
//

@testable import Moxie
import Nimble
import Quick

class Mocked: Mock {
    var moxie = Moxie()
}

class ArgumentCaptureTests: QuickSpec {
    override func spec() {

        describe("non-throwing function") {
            describe("returning a direct T value") {
                var subject: Mocked!

                beforeEach {
                    subject = Mocked()
                }

                it("captures the method name and arguments for the invocation") {
                    subject.record(function: "myFunc", wasCalledWith: ["aaa", 42, nil, 3.14])

                    expect(subject.moxie.invocations).to(haveCount(1))
                    let invocation = subject.moxie.invocations.first
                    expect(invocation?.name) == "myFunc"
                    expect(invocation?.parameters[0] as? String).to(equal("aaa"))
                    expect(invocation?.parameters[1] as? Int).to(equal(42))
                    expect(invocation?.parameters[2]).to(beNil())
                    expect(invocation?.parameters[3] as? Double).to(equal(3.14))
                }
            }
        }
    }
}

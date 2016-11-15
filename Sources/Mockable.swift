public protocol Mockable {
    var mb: MockingBird { get set }

    func record(invocation: String, with parameters: Any...)
    func invocationCount(for function: String, with parameters: Any...) -> Int
    func verify(function: String, wasCalledWith parameters: Any...) -> Bool
    func stub(function: String, whenCalledWith parameters: Any..., return value: Any?)
    func returnValue<T>(for function: String, whenCalledWith parameters: Any...) -> T?
}

public extension Mockable {

    func record(invocation: String, with parameters: Any...) {
        mb.record(invocation: invocation, with: parameters)
    }

    func invocationCount(for function: String, with parameters: Any...) -> Int {
        return mb.invocationCount(for: function, with: parameters)
    }

    func verify(function: String, wasCalledWith parameters: Any...) -> Bool {
        return mb.verify(function: function, wasCalledWith: parameters)
    }

    func stub(function: String, whenCalledWith parameters: Any..., return value: Any? = nil) {
        mb.stub(function: function, whenCalledWith: parameters, return: value)
    }

    func returnValue<T>(for function: String, whenCalledWith parameters: Any...) -> T? {
        return mb.returnValue(for: function, whenCalledWith: parameters)
    }
}

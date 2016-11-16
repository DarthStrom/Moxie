public protocol Mockable {
    var mb: MockingBird { get set }

    func stub(function: String, whenCalledWith parameters: Any..., return value: Any?)
    func returnValue<T>(for function: String, whenCalledWith parameters: Any...) -> T?
    func invocationCount(for function: String, with parameters: Any...) -> Int
    func verify(function: String, wasCalledWith parameters: Any...) -> Bool
    func record(invocation: String, with parameters: Any...)
    func explain(function: String) -> String
}

public extension Mockable {

    /// Set a return value for a stubbed function call.
    ///
    /// - parameter function:       The name of the stubbed function.
    /// - parameter whenCalledWith: Zero or more parameters of the stubbed function call.
    /// - parameter return:         The value to return when the stubbed function is called.  The default is `nil`.
    func stub(function: String, whenCalledWith parameters: Any..., return value: Any? = nil) {
        mb.stub(function: function, whenCalledWith: parameters, return: value)
    }

    /// Get the value that has been specified for the stubbed function.
    ///
    /// - parameter for:            The name of the stubbed function.
    /// - parameter whenCalledWith: Zero or more parameters of the stubbed function call.
    ///
    /// - returns: The previously specified value (via `stub`) for the function call or `nil` if none was specified.
    func returnValue<T>(for function: String, whenCalledWith parameters: Any...) -> T? {
        return mb.returnValue(for: function, whenCalledWith: parameters)
    }

    /// Get the number of invocations for the function with the parameters specified.
    ///
    /// - parameter for:  The name of the invoked function.
    /// - parameter with: Zero or more parameters of the invoked function.
    ///
    /// - returns: The number of invocations of the function with the parameters specified.
    func invocationCount(for function: String, with parameters: Any...) -> Int {
        return mb.invocationCount(for: function, with: parameters)
    }

    /// Determine whether a function was invoked with the given parameters.
    ///
    /// - parameter function:      The name of the invoked function.
    /// - parameter wasCalledWith: Zero or more parameters of the invoked function.
    ///
    /// - returns: `true` if the number of invocations is one or more.
    func verify(function: String, wasCalledWith parameters: Any...) -> Bool {
        return mb.verify(function: function, wasCalledWith: parameters)
    }

    /// Remember that a function was invoked with the given parameters.
    ///
    /// - parameter invocation: The name of the invoked function.
    /// - parameter with:       Zero or more parameters of the invoked function.
    func record(invocation: String, with parameters: Any...) {
        mb.record(invocation: invocation, with: parameters)
    }

    /// Get a description of interactions with the mocked function.
    ///
    /// - parameter function: The name of the mocked function.
    ///
    /// - returns: A description of interactions.
    func explain(function: String) -> String {
        return mb.explain(function: function)
    }
}

public protocol Mock {
    var moxie: Moxie { get set }

    /// Sets a return value for a stubbed function call.
    ///
    /// - Parameters:
    ///     - function:       The name of the stubbed function.
    ///     - return:         Zero or more values to return when the stubbed function is called.
    func stub(function: String, return values: Any...)

    /// The value that has been specified for the stubbed function.
    ///
    /// - Parameters:
    ///     - forFunction:    The name of the stubbed function.
    ///
    /// - Returns: The previously specified value (via `stub`) for the function call or `nil` if none was specified.
    func value<T>(forFunction function: String) -> T?

    /// The number of invocations for the function with the parameters specified.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///
    /// - Returns: The number of invocations of the function with the parameters specified.
    func invocations(forFunction function: String) -> Int

    /// Was the function was invoked with the given parameters?
    ///
    /// - Parameters:
    ///     - function: The name of the invoked function.
    ///
    /// - Returns: `true` if the number of invocations is one or more.
    func invoked(function: String) -> Bool

    /// The parameters for a function invocation.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///     - invocation: The ordinal number of the invocation (1-based, default 1)
    /// - Returns: The parameters for the invocaton in an array
    func parameters(forFunction function: String, invocation: Int) -> [Any?]

    /// Records that a function was invoked with the given parameters.
    ///
    /// - Parameters:
    ///     - function:      The name of the invoked function.
    ///     - wasCalledWith: An array containing parameters of the invoked function.
    func record(function: String, wasCalledWith parameters: [Any?])

    /// A description of interactions with the mocked function.
    ///
    /// - Parameter withFunction: The name of the mocked function.
    ///
    /// - Returns: A description of interactions.
    func interactions(withFunction function: String) -> String
}

public extension Mock {

    /// Sets a return value for a stubbed function call.
    ///
    /// - Parameters:
    ///     - function:       The name of the stubbed function.
    ///     - return:         Zero or more values to return when the stubbed function is called.
    func stub(function: String, return values: Any...) {
        moxie.stub(function: function, return: values)
    }

    /// The value that has been specified for the stubbed function.
    ///
    /// - Parameters:
    ///     - forFunction:    The name of the stubbed function.
    ///
    /// - Returns: The previously specified value (via `stub`) for the function call or `nil` if none was specified.
    func value<T>(forFunction function: String) -> T? {
        return moxie.value(forFunction: function)
    }

    /// The number of invocations for the function with the parameters specified.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///
    /// - Returns: The number of invocations of the function with the parameters specified.
    func invocations(forFunction function: String) -> Int {
        return moxie.invocations(forFunction: function)
    }

    /// Was the function was invoked with the given parameters?
    ///
    /// - Parameters:
    ///     - function: The name of the invoked function.
    ///
    /// - Returns: `true` if the number of invocations is one or more.
    func invoked(function: String) -> Bool {
        return moxie.invoked(function: function)
    }

    /// The parameters for a function invocation.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///     - invocation: The ordinal number of the invocation (1-based, default 1)
    /// - Returns: The parameters for the invocaton in an array
    func parameters(forFunction function: String, invocation: Int = 1) -> [Any?] {
        return moxie.parameters(forFunction: function, invocation: invocation)
    }

    /// Records that a function was invoked with the given parameters.
    ///
    /// - Parameters:
    ///     - function:      The name of the invoked function.
    ///     - wasCalledWith: An array containing parameters of the invoked function.
    func record(function: String, wasCalledWith parameters: [Any?] = []) {
        moxie.record(function: function, wasCalledWith: parameters)
    }

    /// A description of interactions with the mocked function.
    ///
    /// - Parameter withFunction: The name of the mocked function.
    ///
    /// - Returns: A description of interactions.
    func interactions(withFunction function: String) -> String {
        return moxie.interactions(withFunction: function)
    }
}

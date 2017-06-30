public protocol Mock {
    var moxie: Moxie { get set }

    /// Sets a return value for a stubbed function call.
    ///
    /// - Parameters:
    ///     - function:       The name of the stubbed function.
    ///     - whenCalledWith: An array containing parameters of the stubbed function call.
    ///     - return:         Zero or more values to return when the stubbed function is called.
    func stub(function: String, whenCalledWith parameters: [Any], return values: Any...)

    /// The value that has been specified for the stubbed function.
    ///
    /// - Parameters:
    ///     - forFunction:    The name of the stubbed function.
    ///     - whenCalledWith: An array containing parameters of the stubbed function call.
    ///
    /// - Returns: The previously specified value (via `stub`) for the function call or `nil` if none was specified.
    func value<T>(forFunction function: String, whenCalledWith parameters: [Any]) -> T?

    /// The number of invocations for the function with the parameters specified.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///     - with:        An array containing parameters of the invoked function.
    ///
    /// - Returns: The number of invocations of the function with the parameters specified.
    func invocations(forFunction function: String, with parameters: [Any]) -> Int

    /// Was the function was invoked with the given parameters?
    ///
    /// - Parameters:
    ///     - function: The name of the invoked function.
    ///     - with:     An array containing parameters of the invoked function.
    ///
    /// - Returns: `true` if the number of invocations is one or more.
    func invoked(function: String, with parameters: [Any]) -> Bool

    /// Records that a function was invoked with the given parameters.
    ///
    /// - Parameters:
    ///     - function:      The name of the invoked function.
    ///     - wasCalledWith: An array containing parameters of the invoked function.
    func record(function: String, wasCalledWith parameters: [Any])

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
    ///     - whenCalledWith: An array containing parameters of the stubbed function call.
    ///     - return:         Zero or more values to return when the stubbed function is called.
    func stub(function: String, whenCalledWith parameters: [Any] = [], return values: Any...) {
        moxie.stub(function: function, whenCalledWith: parameters, return: values)
    }

    /// The value that has been specified for the stubbed function.
    ///
    /// - Parameters:
    ///     - forFunction:    The name of the stubbed function.
    ///     - whenCalledWith: An array containing parameters of the stubbed function call.
    ///
    /// - Returns: The previously specified value (via `stub`) for the function call or `nil` if none was specified.
    func value<T>(forFunction function: String, whenCalledWith parameters: [Any] = []) -> T? {
        return moxie.value(forFunction: function, whenCalledWith: parameters)
    }

    /// The number of invocations for the function with the parameters specified.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///     - with:        An array containing parameters of the invoked function.
    ///
    /// - Returns: The number of invocations of the function with the parameters specified.
    func invocations(forFunction function: String, with parameters: [Any] = []) -> Int {
        return moxie.invocations(forFunction: function, with: parameters)
    }

    /// Was the function was invoked with the given parameters?
    ///
    /// - Parameters:
    ///     - function: The name of the invoked function.
    ///     - with:     An array containing parameters of the invoked function.
    ///
    /// - Returns: `true` if the number of invocations is one or more.
    func invoked(function: String, with parameters: [Any] = []) -> Bool {
        return moxie.invoked(function: function, with: parameters)
    }

    /// Records that a function was invoked with the given parameters.
    ///
    /// - Parameters:
    ///     - function:      The name of the invoked function.
    ///     - wasCalledWith: An array containing parameters of the invoked function.
    func record(function: String, wasCalledWith parameters: [Any] = []) {
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

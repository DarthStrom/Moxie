public class MockingBird {

    var stubbings = [String: Any]()
    var calls = [String: Int]()

    public init() {}

    /// Set a return value for a stubbed function call
    ///
    /// - parameter function:   The name of the stubbed function
    /// - parameter parameters: An array containing the parameters of the stubbed function call
    /// - parameter value:      The value to return when the stubbed function is called
    public func when<T>(_ function: String, _ parameters: [Any] = [], thenReturn value: T) {
        stubbings[getKey(function, parameters)] = value
    }

    /// Get the value that has been specified for the stubbed function
    ///
    /// - parameter function:   The name of the stubbed function
    /// - parameter parameters: An array containing the parameters of the stubbed function call
    ///
    /// - returns: The previously specified value (via when) for the function call or nil if none was specified
    public func valueFor<T>(_ function: String, _ parameters: [Any] = []) -> T? {
        return stubbings[getKey(function, parameters)] as? T
    }

    /// Get the number of invocations for the function with the parameters specified
    ///
    /// - parameter function:   The name of the invoked function
    /// - parameter parameters: An array containing the parameters of the invoked function
    ///
    /// - returns: The number of invocations of the function with the parameters specified
    public func callCount(_ function: String, _ parameters: [Any] = []) -> Int {
        return calls[getKey(function, parameters)] ?? 0
    }

    /// Determine whether a function was invoked with the given parameters
    ///
    /// - parameter function:   The name of the invoked function
    /// - parameter parameters: An array containing the parameters of the invoked function
    ///
    /// - returns: True if the number of invocations is one or more
    public func verify(_ function: String, _ parameters: [Any] = []) -> Bool {
        return callCount(function, parameters) > 0
    }

    /// Remember that a function was invoked with the given parameters
    ///
    /// - parameter function:   The name of the invoked function
    /// - parameter parameters: An array containgin the parameters of the invoked function
    public func record(_ function: String, _ parameters: [Any] = []) {
        let key = getKey(function, parameters)
        if calls[key] == nil {
            calls[key] = 1
        } else {
            calls[key]! += 1
        }
    }

    // MARK: - private

    func getKey(_ function: String, _ parameters: [Any]) -> String {
        return function + "\(parameters.description)"
    }
}

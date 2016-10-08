public class MockingBird {

    var calls = [String: [String: Int]]()
    var stubbings = [String: [String: Any]]()

    public init() {}

    /// Set a return value for a stubbed function call
    ///
    /// - parameter function:   The name of the stubbed function
    /// - parameter parameters: An array containing the parameters of the stubbed function call
    /// - parameter value:      The value to return when the stubbed function is called
    public func when<T>(_ function: String, _ parameters: [Any] = [], thenReturn value: T) {
        if stubbings[function] == nil {
            stubbings[function] = [getKey(parameters): value]
        } else {
            stubbings[function]![getKey(parameters)] = value
        }
    }

    /// Get the value that has been specified for the stubbed function
    ///
    /// - parameter function:   The name of the stubbed function
    /// - parameter parameters: An array containing the parameters of the stubbed function call
    ///
    /// - returns: The previously specified value (via when) for the function call or nil if none was specified
    public func valueFor<T>(_ function: String, _ parameters: [Any] = []) -> T? {
        return stubbings[function]?[getKey(parameters)] as? T
    }

    /// Get the number of invocations for the function with the parameters specified
    ///
    /// - parameter function:   The name of the invoked function
    /// - parameter parameters: An array containing the parameters of the invoked function
    ///
    /// - returns: The number of invocations of the function with the parameters specified
    public func callCount(_ function: String, _ parameters: [Any] = []) -> Int {
        return calls[function]?[getKey(parameters)] ?? 0
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
        let key = getKey(parameters)
        if calls[function] == nil {
            calls[function] = [key: 1]
        } else if calls[function]![key] == nil {
            calls[function]![key] = 1
        } else {
            calls[function]![key]! += 1
        }
    }

    /// Get a struct that can explain interactions with the mock
    ///
    /// - parameter function: The name of the invoked function
    ///
    /// - returns: The explain struct
    public func explain(_ function: String) -> Explain {
        let callCount = calls[function]?.count ?? 0
        return Explain(
            callCount: callCount,
            description: getDescription(function)
        )
    }

    // MARK: - private

    private func getKey(_ parameters: [Any]) -> String {
        return "\(parameters.description)"
    }

    private func getDescription(_ function: String) -> String {
        let stubbingCount = stubbings[function]?.count ?? 0
        let invocationCount = getInvocationCount(calls[function])
        var summary = "This function has \(stubbingCount) stubbing\(stubbingCount == 1 ? "" : "s") and \(invocationCount) invocation\(invocationCount == 1 ? "" : "s")."
        if stubbingCount > 0 {
            appendStubbingDescription(&summary, stubbings[function])
        }
        if invocationCount > 0 {
            appendInvocationDescription(&summary, calls[function])
        }
        return summary
    }

    private func appendStubbingDescription(_ appendTo: inout String, _ stubbing: Dictionary<String, Any>?) {
        let stubbingHeading = "\n\n  Stubbings:"
        let stubbingsList = stubbing?.reduce("") { initial, combine in
            return initial + "\n  - When called with `\(combine.key)`, then return `\(combine.value)`."
            } ?? ""
        appendTo = appendTo + stubbingHeading + stubbingsList
    }

    private func appendInvocationDescription(_ appendTo: inout String, _ invocation: Dictionary<String, Int>?) {
        let invocationHeading = "\n\n  Invocations:"
        let invocationsList = invocation?.reduce("") { initial, combine in
            return initial + "\n  - Called with `\(combine.key)`\(combine.value == 1 ? "" : " x" + "\(combine.value)")."
        } ?? ""
        appendTo = appendTo + invocationHeading + invocationsList
    }

    private func getInvocationCount(_ function: [String: Int]?) -> Int {
        return function?.reduce(0) { initial, combine in
            return initial + combine.value
        } ?? 0
    }
}

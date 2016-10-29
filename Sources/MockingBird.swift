public class MockingBird {

    var stubbings = [String: [String: Any]]()
    var invocations = [String: [String: Int]]()

    public init() {}

    /// Set a return value for a stubbed function call
    ///
    /// - parameter function:       The name of the stubbed function
    /// - parameter withParameters: An array containing the parameters of the stubbed function call
    /// - parameter return:         The value to return when the stubbed function is called
    public func stub<T>(function: String, withParameters parameters: [Any] = [], return value: T) {
        if stubbings[function] == nil {
            stubbings[function] = [getKey(forParameters: parameters): value]
        } else {
            stubbings[function]![getKey(forParameters: parameters)] = value
        }
    }

    /// Get the value that has been specified for the stubbed function
    ///
    /// - parameter function:       The name of the stubbed function
    /// - parameter withParameters: An array containing the parameters of the stubbed function call
    ///
    /// - returns: The previously specified value (via when) for the function call or nil if none was specified
    public func valueFor<T>(function: String, withParameters parameters: [Any] = []) -> T? {
        return stubbings[function]?[getKey(forParameters: parameters)] as? T
    }

    /// Get the number of invocations for the function with the parameters specified
    ///
    /// - parameter forFunction:    The name of the invoked function
    /// - parameter withParameters: An array containing the parameters of the invoked function
    ///
    /// - returns: The number of invocations of the function with the parameters specified
    public func callCount(forFunction function: String, withParameters parameters: [Any] = []) -> Int {
        return invocations[function]?[getKey(forParameters: parameters)] ?? 0
    }

    /// Determine whether a function was invoked with the given parameters
    ///
    /// - parameter function:             The name of the invoked function
    /// - parameter calledWithParameters: An array containing the parameters of the invoked function
    ///
    /// - returns: True if the number of invocations is one or more
    public func verify(function: String, calledWithParameters parameters: [Any] = []) -> Bool {
        return callCount(forFunction: function, withParameters: parameters) > 0
    }

    /// Remember that a function was invoked with the given parameters
    ///
    /// - parameter function:       The name of the invoked function
    /// - parameter withParameters: An array containgin the parameters of the invoked function
    public func record(function: String, withParameters parameters: [Any] = []) {
        let key = getKey(forParameters: parameters)
        if invocations[function] == nil {
            invocations[function] = [key: 1]
        } else if invocations[function]![key] == nil {
            invocations[function]![key] = 1
        } else {
            invocations[function]![key]! += 1
        }
    }

    /// Get a description of interactions with the mocked function
    ///
    /// - parameter function: The name of the mocked function
    ///
    /// - returns: A description of interactions
    public func explain(function: String) -> String {
        return getDescription(forFunction: function)
    }

    // MARK: - private

    private func getKey(forParameters parameters: [Any]) -> String {
        return "\(parameters.description)"
    }

    private func getDescription(forFunction function: String) -> String {
        let stubbingCount = stubbings[function]?.count ?? 0
        let invocationCount = getInvocationCount(forFunction: invocations[function])
        var summary = getDescriptionIntro(stubbings: stubbingCount, invocations: invocationCount)
        appendStubbingDescription(appendTo: &summary, function: stubbings[function])
        appendInvocationDescription(appendTo: &summary, function: invocations[function])
        return summary
    }

    private func getDescriptionIntro(stubbings: Int, invocations: Int) -> String {
        return "This function has \(stubbings) stubbing\(stubbings == 1 ? "" : "s") and \(invocations) invocation\(invocations == 1 ? "" : "s")."
    }

    private func appendStubbingDescription(appendTo: inout String, function: Dictionary<String, Any>?) {
        if function?.count ?? 0 > 0 {
            let stubbingHeading = "\n\n  Stubbings:"
            let stubbingsList = function?.reduce("") { initial, combine in
                return initial + "\n  - When called with `\(combine.key)`, then return `\(combine.value)`."
                } ?? ""
            appendTo = appendTo + stubbingHeading + stubbingsList
        }
    }

    private func appendInvocationDescription(appendTo: inout String, function: Dictionary<String, Int>?) {
        if function?.count ?? 0 > 0 {
            let invocationHeading = "\n\n  Invocations:"
            let invocationsList = function?.reduce("") { initial, combine in
                return initial + "\n  - Called with `\(combine.key)`\(combine.value == 1 ? "" : " x" + "\(combine.value)")."
            } ?? ""
            appendTo = appendTo + invocationHeading + invocationsList
        }
    }

    private func getInvocationCount(forFunction function: [String: Int]?) -> Int {
        return function?.reduce(0) { initial, combine in
            return initial + combine.value
        } ?? 0
    }
}

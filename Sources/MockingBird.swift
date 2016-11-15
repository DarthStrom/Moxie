public class MockingBird {

    var stubbings = [String: [String: Any]]()
    var invocations = [String: [String: Int]]()

    public init() {}

    /// Set a return value for a stubbed function call
    ///
    /// - parameter function:       The name of the stubbed function
    /// - parameter whenCalledWith: An array containing the parameters of the stubbed function call
    /// - parameter return:         The value to return when the stubbed function is called
    public func stub<T>(function: String, whenCalledWith parameters: [Any] = [], return value: T? = nil) {
        if value != nil {
            if stubbings[function] == nil {
                stubbings[function] = [getKey(forParameters: parameters): value!]
            } else {
                stubbings[function]![getKey(forParameters: parameters)] = value
            }
        }
    }

    /// Get the value that has been specified for the stubbed function
    ///
    /// - parameter for:            The name of the stubbed function
    /// - parameter whenCalledWith: An array containing the parameters of the stubbed function call
    ///
    /// - returns: The previously specified value (via stub) for the function call or nil if none was specified
    public func returnValue<T>(for function: String, whenCalledWith parameters: [Any] = []) -> T? {
        return stubbings[function]?[getKey(forParameters: parameters)] as? T
    }

    /// Get the number of invocations for the function with the parameters specified
    ///
    /// - parameter for:  The name of the invoked function
    /// - parameter with: An array containing the parameters of the invoked function
    ///
    /// - returns: The number of invocations of the function with the parameters specified
    public func invocationCount(for function: String, with parameters: [Any] = []) -> Int {
        return invocations[function]?[getKey(forParameters: parameters)] ?? 0
    }

    /// Determine whether a function was invoked with the given parameters
    ///
    /// - parameter function:      The name of the invoked function
    /// - parameter wasCalledWith: An array containing the parameters of the invoked function
    ///
    /// - returns: True if the number of invocations is one or more
    public func verify(function: String, wasCalledWith parameters: [Any] = []) -> Bool {
        return invocationCount(for: function, with: parameters) > 0
    }

    /// Remember that a function was invoked with the given parameters
    ///
    /// - parameter invocation: The name of the invoked function
    /// - parameter with:       An array containing the parameters of the invoked function
    public func record(invocation: String, with parameters: [Any] = []) {
        let key = getKey(forParameters: parameters)
        if invocations[invocation] == nil {
            invocations[invocation] = [key: 1]
        } else if invocations[invocation]![key] == nil {
            invocations[invocation]![key] = 1
        } else {
            invocations[invocation]![key]! += 1
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

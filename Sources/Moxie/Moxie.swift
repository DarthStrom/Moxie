public class Moxie {

    var stubbings = [String: [String: [Any]]]()
    var invocations = [String: [String: Int]]()

    public init() {}

    /// Sets a return value for a stubbed function call.
    ///
    /// - Parameters:
    ///     - function:       The name of the stubbed function.
    ///     - whenCalledWith: An array containing the parameters of the stubbed function call.
    ///     - return:         An array containing the values to return when the stubbed function is called.
    ///                             The last value is returned repeatedly therafter.  The default is `[]`.
    public func stub(function: String, whenCalledWith parameters: [Any] = [], return values: [Any] = []) {
        if !values.isEmpty {
            if stubbings[function] == nil {
                stubbings[function] = [getKey(for: parameters): values]
            } else {
                stubbings[function]![getKey(for: parameters)] = values
            }
        }
    }

    /// The value that has been specified for the stubbed function.
    ///
    /// - Parameters:
    ///     - forFunction:    The name of the stubbed function.
    ///     - whenCalledWith: An array containing the parameters of the stubbed function call.
    ///
    /// - Returns: The previously specified value (via `stub`) for the function call or `nil` if none was specified.
    public func value<T>(forFunction function: String, whenCalledWith parameters: [Any] = []) -> T? {
        let values = stubbings[function]?[getKey(for: parameters)] as? [T]
        if let value = values?.first {
            removeSequentialStubbing(forFunction: function, whenCalledWith: parameters)
            return getUnwrappedReturnValue(value: value)
        } else {
            return nil
        }
    }

    /// The number of invocations for the function with the parameters specified.
    ///
    /// - Parameters:
    ///     - forFunction: The name of the invoked function.
    ///     - with:        An array containing the parameters of the invoked function.
    ///
    /// - Returns: The number of invocations of the function with the parameters specified.
    public func invocations(forFunction function: String, with parameters: [Any] = []) -> Int {
        return invocations[function]?[getKey(for: parameters)] ?? 0
    }

    /// Was the function was invoked with the given parameters.
    ///
    /// - Parameters:
    ///     - function: The name of the invoked function.
    ///     - with:     An array containing the parameters of the invoked function.
    ///
    /// - Returns: `true` if the number of invocations is one or more.
    public func invoked(function: String, with parameters: [Any] = []) -> Bool {
        return invocations(forFunction: function, with: parameters) > 0
    }

    /// Records that a function was invoked with the given parameters.
    ///
    /// - Parameters:
    ///     - function:      The name of the invoked function.
    ///     - wasCalledWith: An array containing the parameters of the invoked function.
    public func record(function: String, wasCalledWith parameters: [Any] = []) {
        let key = getKey(for: parameters)
        if invocations[function] == nil {
            invocations[function] = [key: 1]
        } else if invocations[function]![key] == nil {
            invocations[function]![key] = 1
        } else {
            invocations[function]![key]! += 1
        }
    }

    /// A description of interactions with the mocked function.
    ///
    /// - Parameter withFunction: The name of the mocked function.
    ///
    /// - Returns: A description of interactions.
    public func interactions(withFunction function: String) -> String {
        return getDescription(for: function)
    }

    // MARK: - private

    private func getKey(for parameters: [Any]) -> String {
        return "\(parameters.description)"
    }

    private func getDescription(for function: String) -> String {
        let stubbingCount = stubbings[function]?.count ?? 0
        let invocationCount = getInvocationCount(for: invocations[function])
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

    private func getInvocationCount(for function: [String: Int]?) -> Int {
        return function?.reduce(0) { initial, combine in
            return initial + combine.value
        } ?? 0
    }

    private func removeSequentialStubbing(forFunction function: String, whenCalledWith parameters: [Any]) {
        if let array = stubbings[function]?[getKey(for: parameters)], array.count > 1 {
            stubbings[function]![getKey(for: parameters)]!.removeFirst()
        }
    }

    private func getUnwrappedReturnValue<T>(value: T) -> T? {
        if unwrap(value) != nil {
            return value
        } else {
            return nil
        }
    }

    private func unwrap(_ any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        if mirror.displayStyle != .optional {
            return any
        }

        if mirror.children.count == 0 { return nil }
        let (_, some) = mirror.children.first!
        return some
    }
}

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

    func getKey(_ parameters: [Any]) -> String {
        return "\(parameters.description)"
    }

    func getDescription(_ function: String) -> String {
        let stubbingCount = stubbings[function]?.count ?? 0
        let summary = "This mock has \(stubbingCount) stubbing\(stubbingCount == 1 ? "" : "s") and 0 invocations."
        if stubbingCount > 0 {
            return appendStubbingDescription(summary, stubbings[function])
        } else {
            return summary
        }
    }

    func appendStubbingDescription(_ appendTo: String, _ stubbing: Dictionary<String, Any>?) -> String {
        let stubbingHeading = "\n\n  Stubbings:\n"
        let stubbingsList = stubbing?.reduce("") { initial, combine in
            return initial + "  - When called with `\(combine.key)`, then return `\(combine.value)`."
            } ?? ""
        return appendTo + stubbingHeading + stubbingsList
    }
}

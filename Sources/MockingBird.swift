public class MockingBird {

    var stubbings = [String: Any]()

    public init() {}

    /**
     Set a return value for a stubbed function call
     - Parameters:
        - function: The name of the stubbed function
        - arguments: An array containing the arguments of the stubbed function call
        - thenReturn: The value to return when the stubbed function is called
     */
    public func when<T>(_ function: String, _ arguments: [Any] = [], thenReturn value: T) {
        stubbings[getKey(function, arguments)] = value
    }

    /**
     Get the value that has been specified for the stubbed function
     - Parameters:
        - function: The name of the stubbed function
        - arguments: An array containing the arguments of the stubbed function call
     - Returns: The previously specified value (via when) for the function call or nil if none was specified
    */
    public func valueFor<T>(_ function: String, _ arguments: [Any] = []) -> T? {
        return stubbings[getKey(function, arguments)] as? T
    }

    // MARK: - private

    func getKey(_ function: String, _ parameters: [Any]) -> String {
        return function + "\(parameters.description)"
    }
}

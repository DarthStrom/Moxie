public class MockingBird {

    var returnValues = [String: Any]()

    public init() {}

    public func valueFor<T>(_ function: String, _ arguments: [Any] = []) -> T? {
        return returnValues[getKey(function, arguments)] as? T
    }

    public func when<T>(_ function: String, _ arguments: [Any] = [], thenReturn value: T) {
        returnValues[getKey(function, arguments)] = value
    }

    func getKey(_ function: String, _ parameters: [Any]) -> String {
        return function + "\(parameters.description)"
    }
}

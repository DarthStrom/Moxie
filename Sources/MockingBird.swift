public class MockingBird {

    var returnValues = [String: String]()

    public init() {}

    public func valueFor(_ function: String) -> String? {
        return returnValues[function]
    }

    public func when(_ function: String, thenReturn value: String) {
        returnValues[function] = value
    }
}

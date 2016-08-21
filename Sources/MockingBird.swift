public struct MockingBird {

    public init() {}

    public func create() -> () -> String {
        return { return "What's up" }
    }

    public func when<T>(_ call: T, thenReturn result: String) {

    }

}

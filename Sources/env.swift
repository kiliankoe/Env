#if os(Linux)
    import Glibc
#else
    import Foundation
#endif

/// Interact with environment variables.
public class Env {

    public init() {}

    // Unfortunately static subscripting isn't possible 😕
    public subscript(key: String) -> String? {
        get {
            return Env.get(key)
        }
        set(value) {
            if let value = value {
                Env.set(key, value: value)
            }
        }
    }

    /**
    Return a value for the given key

    - parameter key: key

    - returns: Optional value if env var with key is found
    */
    public static func get(key: String) -> String? {
        return String.fromCString(getenv(key))
    }

    /**
    Set a new value for a given environment variable.

    - parameter key: key
    - parameter value: value
    */
    public static func set(key: String, value: String) {
        setenv(key, value, 1)
    }

    /**
    Remove an environment variable

    - parameter key: key
    */
    public static func unset(key: String) {
        unsetenv(key)
    }

    /**
    Check if environment variable with given key is set.

    - parameter key: key

    - returns: true if env var is set, false otherwise
    */
    public static func isSet(key: String) -> Bool {
        return getenv(key) != nil
    }

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

    /// Return a list of all found environment variables
    public static var keys: [String] {
        let keyValues = run("/usr/bin/env").componentsSeparatedByString("\n")
        let keys = keyValues.map { $0.componentsSeparatedByString("=").first! }.filter { !$0.isEmpty }
        return keys
    }

    /// Return a list of all environment values
    public static var values: [String] {
        return self.keys.map { self.get($0)! }
    }

    /**
    Clear all environment variables
    */
    public static func clear() {
        self.keys
            .map { String($0) }
            .filter { $0 != nil }
            .forEach { self.unset($0) }
    }

    /**
    Check if a given environment variable value exists.

    - parameter value: value

    - returns: true if exists, false otherwise
    */
    public static func hasValue(value: String) -> Bool {
        return self.values.contains(value)
    }

    /**
    Get a list of all environment variables and values as tuples.

    - parameter callback: callback provided with each pair
    */
    public static func each(callback: (key: String, value: String) -> Void) {
        zip(self.keys, self.values).forEach(callback)
    }

#endif

}

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

/**
Run a specified command with optional arguments returning STDOUT.

- parameter command: command
- parameter args: list of arguments, defaults to none

- returns: STDOUT of the executed command
*/
public func run(command: String, args: [String] = []) -> String {
    let task = NSTask()

    task.launchPath = command
    task.arguments = args

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = NSString(data: data, encoding: NSUTF8StringEncoding) as! String

    return output
}

#endif

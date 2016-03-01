import Foundation

public class Env {
    /// Return a list of all found environment variables
    public static var keys: [String] {
        let keyValues = exec("/usr/bin/env").componentsSeparatedByString("\n")
        let keys = keyValues.map { $0.componentsSeparatedByString("=").first! }.filter { !$0.isEmpty }
        return keys
    }

    /// Return a list of all environment values
    public static var values: [String] {
        return self.keys.map { self.get($0)! }
    }

    /**
     Return a value for the given key

     - parameter key: key

     - returns: Optional value if env var with key is found
     */
    public static func get(key: String) -> String? {
        let value = getenv(key)
        return String.fromCString(value)
    }

    /**
     Set a new value for a given environment variable.

     - parameter key: key
     - parameter value: value
     */
    public static func set(key: String, value: String?) {
        if let value = value {
            setenv(key, value, 1)
        } else {
            unsetenv(key)
        }
    }

    /**
     Clear all environment variables
     */
    public static func clear() {
        self.keys
            .map { String($0) }
            .filter { $0 != nil }
            .forEach { self.set($0!, value: nil) }
    }

    /**
     Check if a given environment variable exists.

     - parameter key: key

     - returns: true if exists, otherwise false
     */
    public static func hasKey(key: String) -> Bool {
        return self.keys.contains(key)
    }

    /**
     Check if a given environment variable value exists.

     - parameter value: value

     - returns: true if exists, otherwise false
     */
    public static func hasValue(value: String) -> Bool {
        return self.values.contains(value)
    }

    /**
     Get a list of all environment variables and values as tuples.

     - parameter callback: callback provided with each pair
     */
    public static func eachPair(callback: (key: String, value: String) -> Void) {
        zip(self.keys, self.values).forEach(callback)
    }
}

/**
 Run a specified command with optional arguments returning STDOUT.

 - parameter command: command
 - parameter args: list of arguments, defaults to none

 - returns: STDOUT of the executed command
 */
public func exec(command: String, args: [String] = []) -> String {
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

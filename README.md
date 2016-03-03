## Env

A *teeny tiny* swift lib for accessing and setting environment variables.

**Note**: This more or less offers the same functionality as included with [Swiftline](https://github.com/Swiftline/Swiftline), just without needing all the rest. So kudos goes to the creators there instead of here 🙃

Install with Swift Package manager by adding the following to your `Package.swift`'s dependencies:
```swift
.Package(url: "https://github.com/kiliankoe/Env", majorVersion: 0),
```

### Caveat

Some of the functionality here uses `NSTask` and `NSPipe` internally, which (afaik) haven't been ported yet. Sadly no Linux support for that 🐧😔

### Usage

```swift
import Env
// Be sure to import this when using 😉
```

```swift
Env.get("PATH")
// returns value of env var, if set, e.g. Optional("/usr/local/sbin:...")
```

```swift
Env.set("FOO", value: "BAR")
// sets a new env var with the given value
```

```swift
Env.unset("FOO")
// Removes the env var with the given key
```

```swift
Env.isSet("PATH")
// returns true if var is set, false otherwise
```

#### The following are only available on OS X, iOS, watchOS and tvOS for the time being

```swift
Env.keys
// returns all keys, e.g. ["PATH", ...]
```

```swift
Env.values
// returns all values, e.g. ["/usr/local/sbin:...", ...]
```

```swift
Env.clear()
// Clears all set env vars.
```

```swift
Env.hasValue("FOOBAR")
// returns true if value is set for any env var, false otherwise
```

```swift
Env.each { print($0, $1) }
// Iterate over all env vars with a closure that's handed a tuple of each variable key and its value.
```

### Bonus
Use an instance of `Env` to enable subscripting. All other methods are declared static though, so this is just for convenience.

```swift
let env = Env()
env["FOO"] = "BAR"
print(env["FOO"]) // -> Optional("BAR")
```

This lib also exposes the `run()` function to run arbitrary commands with optional flags. The command's STDOUT is returned as a string.

```swift
run("/bin/ls", args: ["-l", "-a"])
```

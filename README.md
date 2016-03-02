## Env

A *teeny tiny* swift lib for accessing and setting environment variables.

Note: This is basically the same as included with [Swiftline](https://github.com/Swiftline/Swiftline), just without needing all the rest. So kudos goes there instead of here 🙃

Install with Swift Package manager by adding the following to your `Package.swift`'s dependencies:
```swift
.Package(url: "https://github.com/kiliankoe/Env", majorVersion: 0),
```

### Caveat

Unfortunately I'm using `NSTask`, `NSPipe` and `NSString` internally, which require Foundation. So this probably won't build on Linux for the time being 😕

### Usage

```swift
import Env
// Be sure to import this when using ;)
```

```swift
Env.keys
// returns all keys, e.g. ["PATH", ...]
```

```swift
Env.values
// returns all values, e.g. ["/usr/local/sbin:...", ...]
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
Env.clear()
// Clears all set env vars.
```

```swift
Env.hasKey("PATH")
// returns true if var is set, false otherwise
```

```swift
Env.hasValue("FOOBAR")
// returns true if value is set for any env var, false otherwise
```

```swift
Env.eachPair { print("\($0.key): \($0.value)") }
// Iterate over all env vars with a closure that's handed a tuple of each variable key and its value.
```

### Bonus

```swift
exec("/bin/ls", args: ["-l", "-a"])
// Executes a given command with optional arguments.
// Returns a string with STDOUT of command
```

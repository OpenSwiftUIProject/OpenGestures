# OpenGestures

[![codecov](https://codecov.io/gh/OpenSwiftUIProject/OpenGestures/graph/badge.svg)](https://codecov.io/gh/OpenSwiftUIProject/OpenGestures)

OpenGestures is an open source pure Swift gesture recognition engine.

It powers the underlying gesture handling of [OpenSwiftUI](https://github.com/OpenSwiftUIProject/OpenSwiftUI).

| **CI Status** |
|---|
|[![Compatibility tests](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/compatibility_tests.yml/badge.svg)](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/compatibility_tests.yml)|
|[![macOS](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/macos.yml/badge.svg)](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/macos.yml)|
|[![iOS](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/ios.yml/badge.svg)](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/ios.yml)|
|[![Ubuntu](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/OpenSwiftUIProject/OpenGestures/actions/workflows/ubuntu.yml)|

The project is for the following purposes:
- Add gesture support for non-Apple platforms
- Diagnose and debug Gestures Framework (introduced on AppleOS 26) issues on Apple platforms

Currently, this project is in early development.

## Usage

### Via Swift Package Manager

Add OpenGestures as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/OpenSwiftUIProject/OpenGestures.git", from: "0.1.0")
]
```

> [!NOTE]
>
> By default, OpenGesturesShims will use OpenGestures as its implementation on all platforms.

## Project Structure

| Target | Description |
|--------|-------------|
| **OpenGestures** | Main Swift module exposing the public API |
| **COpenGestures** | C/ObjC bridge layer with OGF-prefixed headers |
| **OpenGesturesShims** | Compatibility shims for the gesture API |

## Build

The current suggested toolchain to build the project is Swift 6.2 / Xcode 26.3.

### Swift Package Manager

```shell
swift build
swift test
```

## License

See LICENSE file - MIT

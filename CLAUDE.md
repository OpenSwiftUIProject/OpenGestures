# OpenGestures Development Guide

## Development Workflow

1. Implement feature
2. Test
3. Commit

## Build

```bash
swift build
```

## Test

Three runs cover the full matrix:

```bash
# 1. Unit tests (OpenGesturesTests)
swift test --filter OpenGesturesTests

# 2. Compatibility tests against OpenGestures itself (OPENGESTURES_COMPATIBILITY_TEST=0)
OPENGESTURES_COMPATIBILITY_TEST=0 swift test --filter OpenGesturesCompatibilityTests

# 3. Compatibility tests against Apple's Gestures.framework (OPENGESTURES_COMPATIBILITY_TEST=1)
#    For local development, also set OPENGESTURES_USE_LOCAL_DEPS=1 so Package.swift resolves
#    DarwinPrivateFrameworks from ../DarwinPrivateFrameworks instead of the remote git URL.
OPENGESTURES_COMPATIBILITY_TEST=1 OPENGESTURES_USE_LOCAL_DEPS=1 swift test --filter OpenGesturesCompatibilityTests
```

## Key Environment Variables

- `OPENGESTURES_TARGET_RELEASE` — Target OS release version (default: 2025)
- `OPENGESTURES_COMPATIBILITY_TEST` — Enable compatibility testing with DarwinPrivateFrameworks
- `OPENGESTURES_USE_LOCAL_DEPS` — Use local DarwinPrivateFrameworks dependency

## Architecture

Gestures.framework is a pure Swift gesture recognition engine with ObjC bridging.
It provides:
- GesturePhase<Value> state machine (idle/possible/active/ended/failed/blocked)
- GestureNode hierarchy with coordinator-based dispatching
- GestureComponent protocol for Tap/Pan/LongPress
- GestureRelation system for conflict resolution
- Event system (TouchEvent, MouseEvent, ScrollEvent)

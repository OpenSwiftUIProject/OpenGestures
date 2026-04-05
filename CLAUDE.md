# OpenGestures Development Guide

## Overview

OpenGestures is an open-source reimplementation of Apple's Gestures.framework (iOS 26+).

## Development Workflow

1. Implement feature
2. Format: `Scripts/format-swift.sh` (when available)
3. Test: `swift test`
4. Commit

## Build

```bash
swift build
```

## Test

```bash
swift test
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

// MARK: - Logging

@_transparent
package func preconditionFailure(_ message: @autoclosure () -> String, file: StaticString, line: UInt) -> Never {
    #if DEBUG && OPENGESTURES_DEVELOPMENT
    if message() == "TODO" {
        print("💣 Hit unimplemented part of OpenGestures at \(file):\(line).\nConsider adding a plain implementation to avoid crash.")
    }
    #endif
    Swift.fatalError(message(), file: file, line: line)
}

@_transparent
package func preconditionFailure(_ message: @autoclosure () -> String) -> Never {
    preconditionFailure(message(), file: #fileID, line: #line)
}

// MARK: - Platform Unimplemented

@_transparent
package func _openGesturesPlatformUnimplementedFailure(
    _ function: String = #function,
    file: StaticString = #fileID,
    line: UInt = #line
) -> Never {
    preconditionFailure("Unimplemented for this platform yet", file: file, line: line)
}

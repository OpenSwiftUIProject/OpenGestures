// MARK: - GestureOutput

/// The output of a gesture component update.
public enum GestureOutput<Value: Sendable>: Sendable {
    case empty(GestureOutputEmptyReason, metadata: GestureOutputMetadata?)
    case value(Value, metadata: GestureOutputMetadata?)
    case `final`(Value, metadata: GestureOutputMetadata?)
}

extension GestureOutput {
    public var value: Value? {
        switch self {
        case .value(let v, _): v
        case .final(let v, _): v
        case .empty: nil
        }
    }

    public var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }

    /// True only for the `final` case.
    public var isFinal: Bool {
        if case .final = self { return true }
        return false
    }
}

// MARK: - GestureOutputMetadata

public struct GestureOutputMetadata: Sendable {
    public var updatesToSchedule: [UpdateRequest]
    public var updatesToCancel: [UpdateRequest]
    // TODO: traceAnnotation

    public init(updatesToSchedule: [UpdateRequest] = [], updatesToCancel: [UpdateRequest] = []) {
        self.updatesToSchedule = updatesToSchedule
        self.updatesToCancel = updatesToCancel
    }
}

// MARK: - UpdateRequest

public struct UpdateRequest: Hashable, Sendable, Identifiable {
    public let id: UInt32
    public let creationTime: Timestamp
    public let targetTime: Timestamp
    public let tag: String?
}

// MARK: - GestureOutputEmptyReason

public enum GestureOutputEmptyReason: Hashable, Sendable {
    case noData
    case filtered
    case timeUpdate
}

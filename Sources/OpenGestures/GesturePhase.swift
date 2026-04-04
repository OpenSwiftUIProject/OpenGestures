// MARK: - GesturePhase

/// The phase of a gesture recognition.
public enum GesturePhase<Value: Sendable>: Sendable {
    case blocked(value: Value, blockedBy: GestureNodeID)
    case active(Value)
    case ended(Value)
    case failed(GestureFailureReason)
    case idle
    case possible
}

extension GesturePhase {
    /// True for `ended` and `failed`.
    public var isTerminal: Bool {
        switch self {
        case .ended, .failed: true
        default: false
        }
    }

    /// True only for `blocked`.
    public var isBlocked: Bool {
        if case .blocked = self { return true }
        return false
    }

    /// True only for `active`.
    public var isActive: Bool {
        if case .active = self { return true }
        return false
    }

    /// True for `blocked` and `active`.
    public var isRecognized: Bool {
        switch self {
        case .blocked, .active: true
        default: false
        }
    }

    /// True only for `possible`.
    public var isPossible: Bool {
        if case .possible = self { return true }
        return false
    }

    /// True only for `idle`.
    public var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    /// True only for `failed`.
    public var isFailed: Bool {
        if case .failed = self { return true }
        return false
    }

    /// True only for `ended`.
    public var isEnded: Bool {
        if case .ended = self { return true }
        return false
    }

    /// Extracts value from `blocked`, `active`, or `ended`.
    public var value: Value? {
        switch self {
        case .blocked(let v, _): v
        case .active(let v): v
        case .ended(let v): v
        default: nil
        }
    }

    /// Extracts failure reason from `failed`.
    public var failureReason: GestureFailureReason? {
        if case .failed(let reason) = self { return reason }
        return nil
    }

    public func mapValue<T: Sendable>(_ transform: (Value) -> T) -> GesturePhase<T> {
        switch self {
        case .blocked(let v, let id): .blocked(value: transform(v), blockedBy: id)
        case .active(let v): .active(transform(v))
        case .ended(let v): .ended(transform(v))
        case .failed(let r): .failed(r)
        case .idle: .idle
        case .possible: .possible
        }
    }
}

// MARK: - GestureFailureReason

/// The reason a gesture recognition failed.
public enum GestureFailureReason: Sendable {
    case excluded(by: GestureNodeID)
    case failureDependency(on: GestureNodeID)
    case custom(any Error)
    case disabled
    case removedFromContainer
    case activationDenied
    case aborted
    case coordinatorChanged
}

extension GestureFailureReason: Equatable {
    public static func == (lhs: GestureFailureReason, rhs: GestureFailureReason) -> Bool {
        switch (lhs, rhs) {
        case (.excluded(let a), .excluded(let b)): a == b
        case (.failureDependency(let a), .failureDependency(let b)): a == b
        case (.custom, .custom): false
        case (.disabled, .disabled): true
        case (.removedFromContainer, .removedFromContainer): true
        case (.activationDenied, .activationDenied): true
        case (.aborted, .aborted): true
        case (.coordinatorChanged, .coordinatorChanged): true
        default: false
        }
    }
}

extension GestureFailureReason: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .excluded(let id):
            hasher.combine(0)
            hasher.combine(id)
        case .failureDependency(let id):
            hasher.combine(1)
            hasher.combine(id)
        case .custom:
            hasher.combine(2)
        case .disabled: hasher.combine(3)
        case .removedFromContainer: hasher.combine(4)
        case .activationDenied: hasher.combine(5)
        case .aborted: hasher.combine(6)
        case .coordinatorChanged: hasher.combine(7)
        }
    }
}

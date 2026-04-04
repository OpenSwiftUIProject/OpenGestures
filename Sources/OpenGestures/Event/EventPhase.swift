// MARK: - EventPhase

/// The phase of an input event.
public enum EventPhase: Hashable, Sendable {
    case began
    case active
    case ended
    case failed
}

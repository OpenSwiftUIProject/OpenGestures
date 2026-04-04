// MARK: - GesturePhaseQueue

/// Manages the queue of gesture phase transitions.
///
/// Ensures phase changes are processed in the correct order
/// during the coordinator's update cycle.
public struct GesturePhaseQueue: Sendable {

    private var entries: [(nodeID: GestureNodeID, phaseTag: Int)] = []

    public init() {}

    mutating func enqueue(nodeID: GestureNodeID, phaseTag: Int) {
        entries.append((nodeID, phaseTag))
    }

    mutating func dequeueAll() -> [(nodeID: GestureNodeID, phaseTag: Int)] {
        let result = entries
        entries.removeAll()
        return result
    }

    var isEmpty: Bool { entries.isEmpty }
}

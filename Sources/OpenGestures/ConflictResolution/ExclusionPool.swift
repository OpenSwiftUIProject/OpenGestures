// MARK: - ExclusionPool

/// Manages mutual exclusion between gesture nodes.
public final class ExclusionPool: @unchecked Sendable {

    // MARK: - Stored Properties

    /// The set of exclusion entries.
    private var exclusionValues: [GestureNodeID: Set<GestureNodeID>] = [:]

    /// Currently active exclusions.
    private var activeExclusionValues: [GestureNodeID: Set<GestureNodeID>] = [:]

    /// Tracked nodes.
    private var nodes: Set<GestureNodeID> = []

    // MARK: - Init

    public init() {}

    // MARK: - Exclusion Logic

    /// Records that `excluder` has excluded `excluded`.
    func recordExclusion(excluder: GestureNodeID, excluded: GestureNodeID) {
        exclusionValues[excluded, default: []].insert(excluder)
        activeExclusionValues[excluded, default: []].insert(excluder)
    }

    /// Checks if a node has been excluded.
    func isExcluded(_ nodeID: GestureNodeID) -> Bool {
        guard let excluders = activeExclusionValues[nodeID] else { return false }
        return !excluders.isEmpty
    }

    /// Gets the node ID that excluded a given node (first excluder).
    func excluder(of nodeID: GestureNodeID) -> GestureNodeID? {
        activeExclusionValues[nodeID]?.first
    }

    /// Clears all exclusion state.
    func reset() {
        exclusionValues.removeAll()
        activeExclusionValues.removeAll()
        nodes.removeAll()
    }
}

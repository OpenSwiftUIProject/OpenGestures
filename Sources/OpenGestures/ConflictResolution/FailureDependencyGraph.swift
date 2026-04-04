// MARK: - FailureDependencyGraph

/// Tracks failure dependency relationships between gesture nodes.
///
/// When gesture A has a `requiresFailure` relation with gesture B,
/// A cannot activate until B has failed. If B succeeds (activates),
/// A transitions to `.failed(.failureDependency(on: B.id))`.
public final class FailureDependencyGraph: @unchecked Sendable {

    // MARK: - Internal State

    /// Maps a node ID to the set of nodes it depends on for failure.
    private var dependencies: [GestureNodeID: Set<GestureNodeID>] = [:]

    /// Maps a node ID to the set of nodes that depend on its failure.
    private var dependents: [GestureNodeID: Set<GestureNodeID>] = [:]

    // MARK: - Init

    public init() {}

    // MARK: - Dependency Management

    /// Adds a failure dependency: `dependent` requires `dependency` to fail.
    func addDependency(dependent: GestureNodeID, dependency: GestureNodeID) {
        dependencies[dependent, default: []].insert(dependency)
        dependents[dependency, default: []].insert(dependent)
    }

    /// Removes a failure dependency.
    func removeDependency(dependent: GestureNodeID, dependency: GestureNodeID) {
        dependencies[dependent]?.remove(dependency)
        dependents[dependency]?.remove(dependent)
    }

    /// Returns nodes that depend on the failure of the given node.
    func failureDependents(for nodeID: GestureNodeID) -> Set<GestureNodeID> {
        dependents[nodeID] ?? []
    }

    /// Checks if a node has unresolved failure dependencies.
    func hasUnresolvedFailureDependencies(for nodeID: GestureNodeID) -> Bool {
        guard let deps = dependencies[nodeID] else { return false }
        return !deps.isEmpty
    }

    /// Clears all dependency state.
    func reset() {
        dependencies.removeAll()
        dependents.removeAll()
    }
}

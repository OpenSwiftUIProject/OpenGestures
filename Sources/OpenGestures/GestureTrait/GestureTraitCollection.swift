// MARK: - GestureTraitCollection

/// A collection of gesture traits keyed by their trait ID.
public struct GestureTraitCollection: Hashable, Sendable {
    public var traits: [GestureTraitID: GestureTrait]

    public init(traits: [GestureTraitID: GestureTrait] = [:]) {
        self.traits = traits
    }

    public init(trait: GestureTrait) {
        self.traits = [trait.id: trait]
    }
}

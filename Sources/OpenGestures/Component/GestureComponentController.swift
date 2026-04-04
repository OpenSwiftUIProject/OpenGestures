// MARK: - AnyGestureComponentController

/// Type-erased base for gesture component controllers.
open class AnyGestureComponentController: @unchecked Sendable {

    /// Weak reference to the bound node.
    public weak var node: AnyGestureNode?

    public init() {}

    /// Handles incoming events and drives the component's update cycle.
    open func handleEvents(_ events: [any Event]) {
        fatalError("Subclass must override")
    }

    /// Checks if this controller can handle events of a given type and count.
    open func canHandleEvents<E: Event>(ofType: E.Type, count: Int) -> Bool {
        false
    }

    /// Resets the controller and its component.
    open func reset() {
        fatalError("Subclass must override")
    }

    /// Returns the component's traits.
    open var traits: GestureTraitCollection? { nil }
}

// MARK: - GestureComponentController

/// Concrete controller wrapping a specific GestureComponent.
public final class GestureComponentController<C: GestureComponent>: AnyGestureComponentController {

    public var component: C
    private let timeSource: any TimeSource
    private var cachedStartTime: Timestamp?

    public init(component: C, timeSource: any TimeSource) {
        self.component = component
        self.timeSource = timeSource
    }

    public override func handleEvents(_ events: [any Event]) {
        let currentTime = timeSource.timestamp
        let startTime = cachedStartTime ?? currentTime
        if cachedStartTime == nil {
            cachedStartTime = currentTime
        }

        let context = GestureComponentContext(startTime: startTime, currentTime: currentTime)

        do {
            let output = try component.update(context: context)

            guard let node else { return }
            switch output {
            case .empty(_, _):
                break
            case .value(let value, _):
                try node.update(someValue: value, isFinalUpdate: false)
            case .final(let value, _):
                try node.update(someValue: value, isFinalUpdate: true)
            }
        } catch {
            // Handle error
        }
    }

    public override func reset() {
        component.reset()
        cachedStartTime = nil
    }

    public override var traits: GestureTraitCollection? {
        component.traits()
    }

    public override func canHandleEvents<E: Event>(ofType: E.Type, count: Int) -> Bool {
        component.capacity(for: ofType) >= count
    }
}

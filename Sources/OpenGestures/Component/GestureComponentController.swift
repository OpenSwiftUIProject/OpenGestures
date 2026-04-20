//
//  GestureComponentController.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

// MARK: - GestureComponentController [WIP]

/// Concrete controller wrapping a specific `GestureComponent`.
public final class GestureComponentController<C: GestureComponent>: AnyGestureComponentController, @unchecked Sendable {

    public var component: C
    let timeScheduler: any TimeScheduler
    // TODO: var eventStores: [ObjectIdentifier: AnyEventStore] = [:]
    var _traits: GestureTraitCollection?
    var startTime: Timestamp?
    var updateListener: ((Result<GestureOutput<C.Value>, any Error>) -> Void)?
    // TODO: lazy var updateTracer: UpdateTracer?
    lazy var updateScheduler: UpdateScheduler? = nil

    public init(component: C, timeScheduler: any TimeScheduler) {
        self.component = component
        self.timeScheduler = timeScheduler
        super.init()
    }

    public override var traits: GestureTraitCollection? {
        component.traits()
    }

    public override var timeSource: any TimeSource {
        timeScheduler
    }

    public override func canHandleEvents<E: Event>(ofType: E.Type, count: Int) -> Bool {
        component.capacity(for: ofType) >= count
    }

    public override func handleEvents<E: Event>(_ events: [E]) throws {
        let currentTime = timeScheduler.timestamp
        let startTime = self.startTime ?? currentTime
        if self.startTime == nil {
            self.startTime = currentTime
        }

        let context = GestureComponentContext(startTime: startTime, currentTime: currentTime)
        let output = try component.update(context: context)

        guard let node else { return }
        switch output {
        case .empty:
            break
        case .value(let value, _):
            try node.update(someValue: value, isFinalUpdate: false)
        case .finalValue(let value, _):
            try node.update(someValue: value, isFinalUpdate: true)
        }
    }

    public override func reset() {
        component.reset()
        startTime = nil
    }
}

// MARK: - AnyGestureComponentController

/// Type-erased base for gesture component controllers.
open class AnyGestureComponentController: @unchecked Sendable {

    /// Weak back-reference to the owning gesture node.
    open weak var node: AnyGestureNode?

    /// Traits exposed by the wrapped component.
    open var traits: GestureTraitCollection? {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Time source used by `handleEvents` to build `GestureComponentContext`.
    open var timeSource: any TimeSource {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Whether this controller can consume `count` events of the given type.
    open func canHandleEvents<E: Event>(ofType: E.Type, count: Int) -> Bool {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Whether this controller can consume a single event.
    open func canHandleEvent<E: Event>(_ event: E) -> Bool {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Drives the wrapped component with the given events.
    open func handleEvents<E: Event>(_ events: [E]) throws {
        _openGesturesBaseClassAbstractMethod()
    }

    /// Resets the controller and its wrapped component.
    open func reset() {
        _openGesturesBaseClassAbstractMethod()
    }

    package init() {}
}

//
//  GestureNode.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

import Foundation
import Synchronization

// MARK: - AnyGestureNode

/// Type-erased base class for gesture nodes.
open class AnyGestureNode: Identifiable, @unchecked Sendable {

    // MARK: - Static ID counter

    private static let counter = Atomic<UInt32>(0)

    @inline(__always)
    private static func makeUniqueID() -> UInt32 {
        let (_, id) = counter.add(1, ordering: .relaxed)
        return id
    }

    // MARK: - Stored Properties

    public let id: GestureNodeID = GestureNodeID(rawValue: makeUniqueID())
    public var tag: GestureTag?
    public var traits: GestureTraitCollection?
    open var options: GestureNodeOptions = []
    open weak var container: (any GestureNodeContainer)?
    package var timeSource: (any TimeSource)?
    package unowned var context: AnyObject?
    package var debugLabelProvider: ((AnyGestureNode) -> String)?
    package unowned var listener: (any GestureNodeListener)?
    package var relationMap: RelationMap = RelationMap()
    package var trackedEvents: Set<EventID> = []

    // MARK: - Init

    package init(
        traits: GestureTraitCollection? = nil,
        tag: GestureTag? = nil,
        relations: [GestureRelation] = []
    ) {
        self.tag = tag
        self.traits = traits
        for relation in relations {
            addRelation(relation)
        }
    }

    // MARK: - Relations

    open var relations: [GestureRelation] {
        relationMap.toRelations()
    }

    open func addRelation(_ relation: GestureRelation) {
        relationMap.addRelation(relation)
    }

    open func removeRelation(_ relation: GestureRelation) {
        relationMap.removeRelation(relation)
    }

    open func addRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            addRelation(relation)
        }
    }

    open func removeRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            removeRelation(relation)
        }
    }

    // MARK: - Event Tracking

    public func startTrackingEvents(with eventIDs: [EventID]) {
        for id in eventIDs {
            trackedEvents.insert(id)
        }
    }

    public func stopTrackingEvents(with eventIDs: [EventID]) {
        for id in eventIDs {
            trackedEvents.remove(id)
        }
    }

    // MARK: - Update / Abort / Fail [WIP]

    open func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        _openGesturesBaseClassAbstractMethod()
    }

    public final func abort() throws {
        try _abort()
    }

    package func _abort() throws {
        _openGesturesBaseClassAbstractMethod()
    }

    open func fail(with error: Error) throws {
        _openGesturesBaseClassAbstractMethod()
    }

    // MARK: - Debug

    public final var debugLabel: String {
        var parts: [String] = []
        let label: String
        if let debugLabelProvider {
            label = debugLabelProvider(self)
        } else {
            let address = String(UInt(bitPattern: ObjectIdentifier(self)), radix: 16, uppercase: false)
            label = "\(type(of: self)): 0x\(address)"
        }
        parts.append(label)
        if let tag {
            parts.append(tag.description)
        }
        var pairs: [(String, String)] = []
        pairs.append(("id", id.description))
        pairs.append(("phase", describePhaseQueue()))
        let header = parts.joined(separator: " ")
        let pairResult = pairs.map { $0 + " = " + $1 }.joined(separator: "; ")
        return "<" + header + "; " + pairResult + ">"
    }

    // FIXME
    package func describePhaseQueue() -> String {
        ""
    }
}

// MARK: - Hashable / Comparable

extension AnyGestureNode: Hashable {
    public static func == (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension AnyGestureNode: Comparable {
    public static func < (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        guard let lhsContainer = lhs.container,
              let rhsContainer = rhs.container else {
            return rhs.container != nil
        }
        guard lhsContainer === rhsContainer else {
            return rhsContainer.isDeeper(than: lhsContainer, referenceNode: lhs)
        }
        guard let lhsIndex = lhsContainer.index(of: lhs),
              let rhsIndex = rhsContainer.index(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

// MARK: - GestureNode [WIP]

public class GestureNode<Value: Sendable>: AnyGestureNode, @unchecked Sendable {

    // MARK: - Stored Properties

    public weak var delegate: (any GestureNodeDelegate<Value>)?

    package var phaseQueue: GesturePhaseQueue<Value>

    // MARK: - Init

    public override init(
        traits: GestureTraitCollection?,
        tag: GestureTag?,
        relations: [GestureRelation]
    ) {
        delegate = nil
        phaseQueue = .init()
        super.init(traits: traits, tag: tag, relations: relations)
    }

    public convenience init() {
        self.init(traits: nil, tag: nil, relations: .default)
    }

    // MARK: - Phase

    public var phase: GesturePhase<Value> {
        phaseQueue.currentPhase
    }

    public var latestPhase: GesturePhase<Value> {
        phaseQueue.currentPhase
    }

    // MARK: - Update

    public func update(value: Value, isFinalUpdate: Bool) throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = isFinalUpdate ? .ended(value: value) : .active(value: value)
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }

    public override func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        guard let typedValue = someValue as? Value else {
            fatalError("Type mismatch: expected \(Value.self), got \(type(of: someValue))")
        }
        try update(value: typedValue, isFinalUpdate: isFinalUpdate)
    }

    // MARK: - Abort / Fail

    package override func _abort() throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = .failed(reason: .aborted)
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }

    public override func fail(with error: Error) throws {
        let oldPhase = phaseQueue.currentPhase
        let newPhase: GesturePhase<Value> = .failed(reason: .custom(error))
        phaseQueue.currentPhase = newPhase
        delegate?.gestureNode(self, didUpdatePhase: newPhase, oldPhase: oldPhase)
    }

    // MARK: - Debug

    // FIXME
    package override func describePhaseQueue() -> String {
        "\(phaseQueue.currentPhase)"
    }
}

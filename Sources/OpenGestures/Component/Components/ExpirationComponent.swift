//
//  ExpirationComponent.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

import Synchronization

// MARK: - Expirable

package protocol Expirable: Sendable {
    associatedtype Value: Sendable

    var payload: ExpirablePayload<Value> { get }

    var expiration: Expiration? { get }
}

// MARK: - ExpirationComponent

package struct ExpirationComponent<Upstream>: Sendable where Upstream: GestureComponent, Upstream.Value: Expirable {

    package var upstream: Upstream

    package struct State: NestedCustomStringConvertible, Sendable {
        package var request: UpdateRequest?

        package init() {
            request = nil
        }

        package init(request: UpdateRequest?) {
            self.request = request
        }
    }

    package var state: State

    package init(
        upstream: Upstream,
        state: State = .init()
    ) {
        self.upstream = upstream
        self.state = state
    }

    package enum Failure: Error, Sendable {
        case timeout(reason: ExpirationReason)
    }
}

// MARK: - ExpirationComponent + CompositeGestureComponent

extension ExpirationComponent: CompositeGestureComponent {}

// MARK: - ExpirationComponent + StatefulGestureComponent

extension ExpirationComponent: StatefulGestureComponent {}

// MARK: - ExpirationComponent.State + GestureComponentState

extension ExpirationComponent.State: GestureComponentState {}

// MARK: - ExpirationComponent + ValueTransformingComponent

extension ExpirationComponent: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let metadata = try metadata(
            for: value.expiration,
            context: context
        )

        switch value.payload {
        case let .empty(reason):
            return .empty(reason, metadata: metadata)
        case let .value(payload):
            if isFinal {
                return .finalValue(payload, metadata: metadata)
            } else {
                return .value(payload, metadata: metadata)
            }
        }
    }

    private mutating func metadata(
        for expiration: Expiration?,
        context: GestureComponentContext
    ) throws -> GestureOutputMetadata? {
        var updatesToSchedule: [UpdateRequest] = []
        var updatesToCancel: [UpdateRequest] = []

        if let expiration {
            guard context.currentTime < expiration.deadline else {
                throw Failure.timeout(reason: expiration.reason)
            }

            if let request = state.request {
                guard request.targetTime != expiration.deadline else {
                    return nil
                }
                updatesToCancel.append(request)
            }

            let request = UpdateRequest(
                id: ExpirationComponentRequestID.next(),
                creationTime: context.currentTime,
                targetTime: expiration.deadline,
                tag: expiration.reason.rawValue
            )
            state.request = request
            updatesToSchedule.append(request)
        } else if let request = state.request {
            state.request = nil
            updatesToCancel.append(request)
        }

        guard !updatesToSchedule.isEmpty || !updatesToCancel.isEmpty else {
            return nil
        }
        return GestureOutputMetadata(
            updatesToSchedule: updatesToSchedule,
            updatesToCancel: updatesToCancel
        )
    }
}

// MARK: - ExpirationComponent + GestureComponent

extension ExpirationComponent: GestureComponent {
    package typealias Value = Upstream.Value.Value
}

// MARK: - ExpirationRecord

package struct ExpirationRecord<Value: Sendable>: Expirable, NestedCustomStringConvertible, Sendable {
    package var payload: ExpirablePayload<Value>
    package var expiration: Expiration?

    package init(
        payload: ExpirablePayload<Value>,
        expiration: Expiration?
    ) {
        self.payload = payload
        self.expiration = expiration
    }
}

// MARK: - ExpirablePayload

package enum ExpirablePayload<Value: Sendable>: NestedCustomStringConvertible, Sendable {
    case empty(GestureOutputEmptyReason)
    case value(Value)

    package func populateNestedDescription(_ nested: inout NestedDescription) {
        switch self {
        case let .empty(reason):
            nested.append(reason, label: "reason")
        case let .value(value):
            nested.append(value, label: "value")
        }
    }
}

// MARK: - GestureOutput + ExpirationRecord  [TBA]

extension GestureOutput {
    package func mapToExpirationRecord(
        expiration: Expiration?
    ) -> GestureOutput<ExpirationRecord<Value>> {
        switch self {
        case let .empty(reason, metadata):
            .value(
                ExpirationRecord(
                    payload: .empty(reason),
                    expiration: expiration
                ),
                metadata: metadata
            )
        case let .value(value, metadata):
            .value(
                ExpirationRecord(
                    payload: .value(value),
                    expiration: expiration
                ),
                metadata: metadata
            )
        case let .finalValue(value, metadata):
            .finalValue(
                ExpirationRecord(
                    payload: .value(value),
                    expiration: expiration
                ),
                metadata: metadata
            )
        }
    }
}

// MARK: - ExpirationComponentRequestID [TBA]

private enum ExpirationComponentRequestID {
    private static let nextID = Atomic(UInt32.zero)

    static func next() -> UInt32 {
        let (_, id) = nextID.add(1, ordering: .relaxed)
        return id
    }
}

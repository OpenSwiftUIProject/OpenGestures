//
//  UpdateTracer.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - UpdateTracer

package class UpdateTracer: @unchecked Sendable {
    package var seed: Int16
    package var traceHead: Trace?
    package var activeTraces: [Trace]
    package var pendingBranches: [Int16: [Trace]]
    package var dataSnapshots: [Int16: TraceDataSnapshot]

    package init(
        seed: Int16 = 0,
        traceHead: Trace? = nil,
        activeTraces: [Trace] = [],
        pendingBranches: [Int16: [Trace]] = [:],
        dataSnapshots: [Int16: TraceDataSnapshot] = [:]
    ) {
        self.seed = seed
        self.traceHead = traceHead
        self.activeTraces = activeTraces
        self.pendingBranches = pendingBranches
        self.dataSnapshots = dataSnapshots
    }

    package func beginTrace() {
        seed = seed &+ 1
        if let traceHead, let activeTrace = activeTraces.last {
            pendingBranches[activeTrace.id, default: []].append(traceHead)
            self.traceHead = nil
        }
        activeTraces.append(Trace(id: seed))
    }

    package func endTrace(snapshot: TraceDataSnapshot) {
        var trace = activeTraces.popLast()!
        dataSnapshots[trace.id] = snapshot
        if let traceHead {
            trace.upstreamTraces.append(traceHead)
        }
        if let pending = pendingBranches.removeValue(forKey: trace.id) {
            trace.upstreamTraces.append(contentsOf: pending)
        }
        traceHead = trace
    }
}

// MARK: - TraceDataSnapshot

package struct TraceDataSnapshot: Sendable {
    package var component: @Sendable () -> String
    package var result: @Sendable () -> String
    package var state: @Sendable () -> String
    package var isSuccess: Bool

    package init(
        component: @escaping @Sendable () -> String,
        result: @escaping @Sendable () -> String,
        state: @escaping @Sendable () -> String,
        isSuccess: Bool
    ) {
        self.component = component
        self.result = result
        self.state = state
        self.isSuccess = isSuccess
    }
}

// MARK: - Trace

package struct Trace: Hashable, Identifiable, Sendable {
    package var id: Int16
    package var upstreamTraces: [Trace]

    package init(id: Int16, upstreamTraces: [Trace] = []) {
        self.id = id
        self.upstreamTraces = upstreamTraces
    }
}

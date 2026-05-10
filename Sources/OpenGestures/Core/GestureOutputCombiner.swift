//
//  GestureOutputCombiner.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureOutputStatusCombiner

package struct GestureOutputStatusCombiner: Sendable {
    package var combine: @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus

    package init(combine: @escaping @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus) {
        self.combine = combine
    }
}

// MARK: - GestureOutputStatus

package enum GestureOutputStatus: Hashable, Sendable {
    case empty
    case value
    case finalValue
}

extension GestureOutput {
    package var status: GestureOutputStatus {
        switch self {
        case .empty:
            return .empty
        case .value:
            return .value
        case .finalValue:
            return .finalValue
        }
    }
}

// MARK: - GestureOutputArrayCombiner [WIP: DynamicCombinerComponent]

package struct GestureOutputArrayCombiner<Value: Sendable>: Sendable {
    package let statusCombiner: GestureOutputStatusCombiner

    package init(statusCombiner: GestureOutputStatusCombiner) {
        self.statusCombiner = statusCombiner
    }

//    package func combine(_ outputs: [GestureOutput<Value>]) throws -> GestureOutput<[A]> {
//        let status = try statusCombiner.combine(outputs.map(\.status))
//        let metadata = combinedMetadata(for: outputs)
//        switch status {
//        case .empty:
//            return .empty(emptyReason(for: outputs), metadata: metadata)
//        case .value:
//            return .value(outputs.compactMap(\.value), metadata: metadata)
//        case .finalValue:
//            return .finalValue(outputs.compactMap(\.value), metadata: metadata)
//        }
//    }
//
//    private func emptyReason(for outputs: [GestureOutput<Value>]) -> GestureOutputEmptyReason {
//        for output in outputs {
//            if let reason = output.emptyReason {
//                return reason
//            }
//        }
//        return .noData
//    }
//
//    private func combinedMetadata(for outputs: [GestureOutput<Value>]) -> GestureOutputMetadata? {
//        let metadata = outputs.compactMap(\.metadata)
//        let updatesToSchedule = metadata.flatMap { $0.updatesToSchedule }
//        let updatesToCancel = metadata.flatMap { $0.updatesToCancel }
//        let traceAnnotation = metadata.compactMap { $0.traceAnnotation }.last
//        guard !updatesToSchedule.isEmpty || !updatesToCancel.isEmpty || traceAnnotation != nil else {
//            return nil
//        }
//        return GestureOutputMetadata(
//            updatesToSchedule: updatesToSchedule,
//            updatesToCancel: updatesToCancel,
//            traceAnnotation: traceAnnotation
//        )
//    }
}

// MARK: - GestureOutputCombiner

package struct GestureOutputCombiner<each Value: Sendable, Output: Sendable>: Sendable {
    package let combineValues: (@Sendable (repeat each Value) throws -> Output)?
    package let combineOptionals: (@Sendable (repeat (each Value)?) throws -> Output)?
    package let statusCombiner: GestureOutputStatusCombiner

    package init(
        combineValues: (@Sendable (repeat each Value) throws -> Output)?,
        combineOptionals: (@Sendable (repeat (each Value)?) throws -> Output)?,
        statusCombiner: GestureOutputStatusCombiner
    ) {
        self.combineValues = combineValues
        self.combineOptionals = combineOptionals
        self.statusCombiner = statusCombiner
    }

    package func combine(_ outputs: repeat GestureOutput<each Value>) throws -> GestureOutput<Output> {
        var statuses: [GestureOutputStatus] = []
        var metadata: GestureOutputMetadata?
        var emptyReason: GestureOutputEmptyReason?
        var lastOutputEmptyReason: GestureOutputEmptyReason?
        var hasProcessedOutput = false

        for output in repeat each outputs {
            statuses.append(output.status)
            switch (metadata, output.metadata) {
            case let (current?, outputMetadata?):
                metadata = GestureOutputMetadata(
                    updatesToSchedule: current.updatesToSchedule + outputMetadata.updatesToSchedule,
                    updatesToCancel: current.updatesToCancel + outputMetadata.updatesToCancel
                )
            case let (nil, outputMetadata?):
                metadata = GestureOutputMetadata(
                    updatesToSchedule: outputMetadata.updatesToSchedule,
                    updatesToCancel: outputMetadata.updatesToCancel
                )
            case (_, nil):
                break
            }
            lastOutputEmptyReason = output.emptyReason
            hasProcessedOutput = true
        }
        if hasProcessedOutput {
            emptyReason = lastOutputEmptyReason != nil ? .filtered : .noData
        }
        let status = try statusCombiner.combine(statuses)
        switch status {
        case .empty:
            return .empty(emptyReason!, metadata: metadata)
        case .value, .finalValue:
            let value: Output
            if let combineOptionals {
                value = try combineOptionals(repeat (each outputs).value)
            } else if let combineValues {
                value = try combineValues(repeat (each outputs).value!)
            } else {
                preconditionFailure("Invalid combiner configuration")
            }
            if status == .value {
                return .value(value, metadata: metadata)
            } else {
                return .finalValue(value, metadata: metadata)
            }
        }
    }
}

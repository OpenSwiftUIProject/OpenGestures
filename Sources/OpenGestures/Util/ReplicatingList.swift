//
//  ReplicatingList.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: WIP

// MARK: - ReplicatingValue

package protocol ReplicatingValue: Sendable {
    func replicated() -> Self
}

// TODO: ReplicatingList

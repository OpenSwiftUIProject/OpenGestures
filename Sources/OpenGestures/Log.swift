//
//  Log.swift
//  OpenGestures

import Foundation
import Synchronization
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif
#if canImport(os)
package import os
#endif

@_silgen_name("ogf_variant_has_internal_diagnostics")
private func ogf_variant_has_internal_diagnostics(_ subsystem: UnsafePointer<CChar>) -> Bool

#if canImport(Darwin)
private func logPreferencesChangedCallback(
    _ center: CFNotificationCenter?,
    _ observer: UnsafeMutableRawPointer?,
    _ name: CFNotificationName?,
    _ object: UnsafeRawPointer?,
    _ userInfo: CFDictionary?
) {
    Log.invalidateLoggingPreferencesCache()
}
#endif

// MARK: - Log

package enum Log {
    private enum DefaultsCacheState: UInt {
        case unknown = 0
        case enabled = 1
        case disabled = 2
    }

    private static let defaultsCacheState = Atomic(DefaultsCacheState.unknown.rawValue)
    private static let observerRegistered = Atomic<UInt8>(0)

    package static let subsystem = "org.OpenSwiftUIProject.OpenGestures"

    package static let hasInternalContent: Bool = {
        subsystem.withCString { ogf_variant_has_internal_diagnostics($0) }
    }()

    package static let isEnvironmentLoggingEnabled: Bool = {
        guard let value = getenv("GESTURES_LOGGING_ENABLED") else {
            return false
        }
        return atoi(value) != 0
    }()

    package static var isGesturesLoggingEnabled: Bool {
        guard hasInternalContent else {
            return false
        }
        if isEnvironmentLoggingEnabled {
            return true
        }
        switch DefaultsCacheState(rawValue: defaultsCacheState.load(ordering: .acquiring)) {
        case .unknown:
            break
        case .enabled:
            return true
        case .disabled:
            return false
        case nil:
            preconditionFailure("Invalid logging defaults cache state")
        }
        guard let defaults = UserDefaults(suiteName: subsystem) else {
            return false
        }
        let isEnabled = defaults.bool(forKey: "LoggingEnabled")
        defaultsCacheState.store(
            (isEnabled ? DefaultsCacheState.enabled : DefaultsCacheState.disabled).rawValue,
            ordering: .releasing
        )
        registerLoggingPreferencesObserver()
        return isEnabled
    }

    fileprivate static func invalidateLoggingPreferencesCache() {
        defaultsCacheState.store(DefaultsCacheState.unknown.rawValue, ordering: .releasing)
    }

    private static func registerLoggingPreferencesObserver() {
        #if canImport(Darwin)
        let result = observerRegistered.compareExchange(
            expected: 0,
            desired: 1,
            ordering: .acquiringAndReleasing
        )
        guard result.exchanged else {
            return
        }
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = "\(subsystem).LoggingPreferences" as CFString
        CFNotificationCenterAddObserver(
            center,
            nil,
            logPreferencesChangedCallback,
            notificationName,
            nil,
            .deliverImmediately
        )
        #endif
    }

    #if canImport(os)
    private static let _nodes = Logger(subsystem: subsystem, category: "Nodes")

    package static var nodes: Logger {
        isGesturesLoggingEnabled ? _nodes : disabled
    }

    private static let _components = Logger(subsystem: subsystem, category: "Components")

    package static var components: Logger {
        isGesturesLoggingEnabled ? _components : disabled
    }

    package static let componentUpdates = Logger(subsystem: subsystem, category: "ComponentUpdates")

    private static let disabled = Logger(OSLog.disabled)

    @inline(__always)
    package static func logEnqueuedPhase(_ node: AnyGestureNode) {
        nodes.log("\(node.debugLabel) enqueued phase")
    }

    @inline(__always)
    package static func logFailedScheduledUpdate() {
        components.log("Failed to peform a scheduled update")
    }
    #else
    // TODO: Add swift-log support
    @inline(__always)
    package static func logEnqueuedPhase(_ node: AnyGestureNode) {}

    @inline(__always)
    package static func logFailedScheduledUpdate() {}
    #endif
}

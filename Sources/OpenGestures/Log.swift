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
    private static let unknownDefaultsCacheState: UInt = 0
    private static let enabledDefaultsCacheState: UInt = 1
    private static let disabledDefaultsCacheState: UInt = 2
    private static let defaultsCacheState = Atomic(unknownDefaultsCacheState)
    private static let observerRegistered = Atomic<UInt8>(0)

    package static let subsystem = "org.OpenSwiftUIProject.OpenGestures"

    package enum Category: String {
        case nodes = "Nodes"
        case components = "Components"
    }

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
        switch defaultsCacheState.load(ordering: .acquiring) {
        case unknownDefaultsCacheState:
            break
        case enabledDefaultsCacheState:
            return true
        case disabledDefaultsCacheState:
            return false
        default:
            preconditionFailure("Invalid logging defaults cache state")
        }
        guard let defaults = UserDefaults(suiteName: subsystem) else {
            return false
        }
        let isEnabled = defaults.bool(forKey: "LoggingEnabled")
        defaultsCacheState.store(
            isEnabled ? enabledDefaultsCacheState : disabledDefaultsCacheState,
            ordering: .releasing
        )
        registerLoggingPreferencesObserver()
        return isEnabled
    }

    fileprivate static func invalidateLoggingPreferencesCache() {
        defaultsCacheState.store(unknownDefaultsCacheState, ordering: .releasing)
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
    package static let nodes = Logger(subsystem: subsystem, category: Category.nodes.rawValue)
    package static let components = Logger(subsystem: subsystem, category: Category.components.rawValue)
    package static let disabled = Logger(OSLog.disabled)

    package static func enabledLogger(for category: Category) -> Logger {
        guard isGesturesLoggingEnabled else {
            return disabled
        }
        switch category {
        case .nodes:
            return nodes
        case .components:
            return components
        }
    }

    package static func logEnqueuedPhase(_ node: AnyGestureNode) {
        enabledLogger(for: .nodes).log("\(node.debugLabel, privacy: .public) enqueued phase")
    }
    #else
    package static func logEnqueuedPhase(_ node: AnyGestureNode) {}
    #endif
}

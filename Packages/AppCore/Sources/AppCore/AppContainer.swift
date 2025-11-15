//
//  AppContainer.swift
//  AppCore
//
//  Created by Fuchs on 1/11/25.
//

import Foundation
import os.log

// MARK: - AppContainer

public final class AppContainer: @unchecked Sendable {
    public let logger: Loggering
    public let analytics: Analyticsing
    public var featureFlags: FeatureFlags

    public init(
        logger: Loggering,
        analytics: Analyticsing,
        featureFlags: FeatureFlags
    ) {
        self.logger = logger
        self.analytics = analytics
        self.featureFlags = featureFlags
    }
}

public extension AppContainer {
    static let `default` = AppContainer(
        logger: ConsoleLogger(),
        analytics: ConsoleAnalytics(),
        featureFlags: .init()
    )
}

// MARK: Logger

public protocol Loggering: Sendable {
    func log(_ message: String, category: String)
}

public struct ConsoleLogger: Loggering {
    private let logger = os.Logger(subsystem: "ExampleApp", category: "app")

    public init() {}

    public func log(_ message: String, category: String = "app") {
        logger.log("[\(category)] \(message)")
    }
}

// MARK: Analytics

public protocol Analyticsing: Sendable {
    func track(_ event: String, params: [String: String]?)
}

public struct ConsoleAnalytics: Analyticsing {
    public init() {}

    public func track(_ event: String, params: [String: String]?) {
        // In demo just print
        print("ANALYTICS:", event, params ?? [:])
    }
}

// MARK: Feature Flags

public struct FeatureFlags: Sendable {
    public var enableExperimental: Bool = false

    public init(enableExperimental: Bool = false) {
        self.enableExperimental = enableExperimental
    }
}


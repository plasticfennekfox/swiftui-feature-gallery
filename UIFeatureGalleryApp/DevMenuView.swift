//
//  DevMenuView.swift
//  ExampleApp
//
//  Created by Fuchs on 1/11/25.
//

import SwiftUI
import UIKit
import AppCore

struct DevMenuView: View {
    let container: AppContainer

    @Environment(\.dismiss) private var dismiss

    @State private var enableExperimental: Bool

    init(container: AppContainer) {
        self.container = container
        _enableExperimental = State(initialValue: container.featureFlags.enableExperimental)
    }

    var body: some View {
        NavigationStack {
            List {
                featureFlagsSection
                environmentSection
                actionsSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Developer menu")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: Sections

    private var featureFlagsSection: some View {
        Section("Feature flags") {
            Toggle("Enable experimental features", isOn: $enableExperimental)
                .onChange(of: enableExperimental, initial: false) { _, newValue in
                    container.featureFlags.enableExperimental = newValue
                    container.logger.log("DevMenu: enableExperimental = \(newValue)", category: "devmenu")
                }

            Text("Use this flag to conditionally show experimental UI in features.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }


    private var environmentSection: some View {
        Section("Environment") {
            infoRow("App version", value: appVersionString)
            infoRow("iOS", value: UIDevice.current.systemVersion)
            infoRow("Device", value: UIDevice.current.model)
            infoRow("Locale", value: Locale.current.identifier)
        }
    }

    private var actionsSection: some View {
        Section("Actions") {
            Button("Log test analytics event") {
                container.analytics.track("devmenu.test_event", params: ["source": "DevMenu"])
            }

            Button("Print feature flags to console") {
                container.logger.log(
                    "DevMenu: flags = enableExperimental=\(container.featureFlags.enableExperimental)",
                    category: "devmenu"
                )
            }
        }
    }

    // MARK: Helpers

    private var appVersionString: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "-"
        let build = info?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }

    private func infoRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

//
//  RootView.swift
//  ExampleApp
//
//  Created by Fuchs on 1/11/25.
//

import SwiftUI
import AppCore
import FeatureCatalog

struct RootView: View {
    let container: AppContainer

    @State private var path: [AppRoute] = []
    @State private var showDevMenu = false

    var body: some View {
        NavigationStack(path: $path) {
            FeatureCatalogView(container: container) { route in
                path.append(route)
            }
            .navigationTitle(L10n.tr("root.title"))
            .navigationDestination(for: AppRoute.self) { route in
                DestinationView(route: route, container: container)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDevMenu = true
                        container.analytics.track("devmenu.open", params: nil)
                    } label: {
                        Image(systemName: "wrench.and.screwdriver")
                    }
                    .accessibilityLabel("Open developer menu")
                }
            }
        }
        .sheet(isPresented: $showDevMenu) {
            DevMenuView(container: container)
        }
    }
}

//
//  FeatureCatalogView.swift
//  Features
//
//  Created by Fuchs on 4/11/25.
//
import SwiftUI
import AppCore
import DesignSystem

public struct FeatureCatalogView: View {
    let container: AppContainer
    let onOpen: (AppRoute) -> Void

    public init(container: AppContainer, onOpen: @escaping (AppRoute) -> Void) {
        self.container = container
        self.onOpen = onOpen
    }

    public var body: some View {
        List {
            // Верхний информер
            Section {
                Card {
                    VStack(alignment: .leading, spacing: DS.Spacing.s) {
                        Text(L10n.tr("catalog.subtitle"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            // Каталог фич
            Section(L10n.tr("catalog.section.features")) {
                ForEach(AppRoute.showcaseCases, id: \.self) { route in
                    Button {
                        onOpen(route)
                    } label: {
                        Label(route.title, systemImage: route.systemImage)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.dsBackground)
    }
}

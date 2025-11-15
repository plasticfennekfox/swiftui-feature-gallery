//
//  FeatureNavigationScreen.swift
//  Features
//
//  Created by Fuchs on 8/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureNavigationScreen: View {
    let container: AppContainer

    // MARK: - State

    @State private var showSheet: Bool = false
    @State private var showFullScreen: Bool = false
    @State private var showConfirmDialog: Bool = false

    @State private var lastActionKey: String = "navigation.status.none"
    @State private var selectedTab: NavPreviewTab = .home

    public init(container: AppContainer) {
        self.container = container
    }

    // MARK: - Body

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "navigation.title",
                comment: "Navigation feature screen title"
            )
        ) {
            navigationLinksCard
            sheetsCard
            dialogsAndMenusCard
            tabViewPreviewCard
        }
        .sheet(isPresented: $showSheet) {
            NavigationSheetView()
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenDemoView()
        }
        .confirmationDialog(
            "navigation.confirm.title",
            isPresented: $showConfirmDialog,
            titleVisibility: .visible
        ) {
            Button("navigation.confirm.primary") {
                lastActionKey = "navigation.status.primary"
            }
            Button("navigation.confirm.destructive", role: .destructive) {
                lastActionKey = "navigation.status.destructive"
            }
            Button("navigation.confirm.cancel", role: .cancel) {
                lastActionKey = "navigation.status.cancelled"
            }
        } message: {
            Text("navigation.confirm.message")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        container.analytics.track("nav.toolbar.log", params: nil)
                        lastActionKey = "navigation.status.toolbar.logged"
                    } label: {
                        Label(
                            "navigation.toolbar.menu.logEvent",
                            systemImage: "waveform.path.ecg"
                        )
                    }

                    Button {
                        lastActionKey = "navigation.status.toolbar.refreshed"
                    } label: {
                        Label(
                            "navigation.toolbar.menu.refresh",
                            systemImage: "arrow.clockwise"
                        )
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }

            ToolbarItem(placement: .bottomBar) {
                Button {
                    showSheet = true
                } label: {
                    Label("navigation.openSheet", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }

    // MARK: - Cards

    private var navigationLinksCard: some View {
        Card {
            Text("navigation.links.title")
                .font(.headline)

            Text("navigation.links.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            NavigationLink {
                NavigationExampleDetailView(
                    title: NSLocalizedString(
                        "navigation.link.detailA.title",
                        comment: "Title for detail screen A"
                    ),
                    color: .blue
                )
            } label: {
                Label(
                    "navigation.link.detailA",
                    systemImage: "chevron.right.circle"
                )
            }

            NavigationLink {
                NavigationExampleDetailView(
                    title: NSLocalizedString(
                        "navigation.link.detailB.title",
                        comment: "Title for detail screen B"
                    ),
                    color: .green
                )
            } label: {
                Label(
                    "navigation.link.detailB",
                    systemImage: "chevron.right.circle.fill"
                )
            }
        }
    }

    private var sheetsCard: some View {
        Card {
            Text("navigation.sheetsCard.title")
                .font(.headline)

            Text("navigation.sheetsCard.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                AppButton("navigation.openSheet") {
                    showSheet = true
                }
                AppButton("navigation.buttons.fullScreen") {
                    showFullScreen = true
                }
            }
        }
    }

    private var dialogsAndMenusCard: some View {
        Card {
            Text("navigation.dialogsCard.title")
                .font(.headline)

            Text("navigation.dialogsCard.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            AppButton("navigation.buttons.showConfirmDialog") {
                showConfirmDialog = true
            }

            Menu {
                Button {
                    lastActionKey = "navigation.status.menu.settings"
                } label: {
                    Label("navigation.menu.settings", systemImage: "gearshape")
                }

                Button {
                    lastActionKey = "navigation.status.menu.markRead"
                } label: {
                    Label("navigation.menu.markAllRead", systemImage: "envelope.open")
                }

                Button(role: .destructive) {
                    lastActionKey = "navigation.status.menu.clearHistory"
                } label: {
                    Label("navigation.menu.clearHistory", systemImage: "trash")
                }
            } label: {
                Label("navigation.inlineMenu.label", systemImage: "ellipsis")
            }

            Text(lastActionDescriptionText)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, DS.Spacing.s)
        }
    }

    private var tabViewPreviewCard: some View {
        Card {
            Text("navigation.tabsCard.title")
                .font(.headline)

            Text("navigation.tabsCard.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            TabView(selection: $selectedTab) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("navigation.tab.home.contentTitle")
                }
                .tag(NavPreviewTab.home)
                .tabItem {
                    Label("navigation.tab.home.tabItem", systemImage: "house")
                }

                VStack {
                    Image(systemName: "star.fill")
                    Text("navigation.tab.favorites.contentTitle")
                }
                .tag(NavPreviewTab.favorites)
                .tabItem {
                    Label("navigation.tab.favorites.tabItem", systemImage: "star")
                }

                VStack {
                    Image(systemName: "person.crop.circle")
                    Text("navigation.tab.profile.contentTitle")
                }
                .tag(NavPreviewTab.profile)
                .tabItem {
                    Label("navigation.tab.profile.tabItem", systemImage: "person")
                }
            }
            .frame(height: 180.0)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.m))

            Text(selectedTabDescription)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, DS.Spacing.s)
        }
    }

    // MARK: - Helpers

    private var lastActionDescriptionText: String {
        let statusText: String = NSLocalizedString(
            lastActionKey,
            comment: "Last navigation action description"
        )
        let template: String = NSLocalizedString(
            "navigation.status.prefix",
            comment: "Prefix for last action label with placeholder"
        )
        return String(format: template, statusText)
    }

    private var selectedTabDescription: String {
        let template: String = NSLocalizedString(
            "navigation.tab.selectedTemplate",
            comment: "Label with currently selected tab name"
        )
        return String(format: template, selectedTab.title)
    }
}

// MARK: - Helper types

private enum NavPreviewTab: String, CaseIterable, Identifiable {
    case home
    case favorites
    case profile

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .home:
            return NSLocalizedString(
                "navigation.tab.home.tabItem",
                comment: "Home tab title"
            )
        case .favorites:
            return NSLocalizedString(
                "navigation.tab.favorites.tabItem",
                comment: "Favorites tab title"
            )
        case .profile:
            return NSLocalizedString(
                "navigation.tab.profile.tabItem",
                comment: "Profile tab title"
            )
        }
    }
}

// Детальный экран для NavigationLink
private struct NavigationExampleDetailView: View {
    let title: String
    let color: Color

    var body: some View {
        VStack(spacing: DS.Spacing.l) {
            Spacer()
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 48.0))
            Text(title)
                .font(.title.bold())
            Text("This is a pushed detail screen.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.opacity(0.08))
        .navigationTitle(title)
    }
}

// Контент для sheet
private struct NavigationSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: DS.Spacing.m) {
                Text("navigation.sheet.content")
                    .font(.title3.bold())
                Text("navigation.sheet.description")
                    .foregroundColor(.secondary)

                Button("navigation.button.close") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("navigation.sheet.title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Контент для fullScreenCover
private struct FullScreenDemoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: DS.Spacing.l) {
                    Text("navigation.fullscreen.title")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("navigation.fullscreen.description")
                        .foregroundStyle(.white.opacity(0.8))

                    Button("navigation.button.close") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

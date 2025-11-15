//
//  FeatureListsScreen.swift
//  Features
//
//  Created by Fuchs on 2/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureListsScreen: View {
    let container: AppContainer

    @State private var items: [DemoItem] = DemoItem.sample
    @State private var showFavoritesOnly: Bool = false
    @State private var searchText: String = ""

    public init(container: AppContainer) {
        self.container = container
    }

    // Отфильтрованный список
    private var filteredItems: [DemoItem] {
        items.filter { item in
            let matchesFavorite: Bool = !showFavoritesOnly || item.isFavorite
            let matchesSearch: Bool = searchText.isEmpty
                || item.title.localizedCaseInsensitiveContains(searchText)
            return matchesFavorite && matchesSearch
        }
    }

    public var body: some View {
        // List — корневой, без FeatureScreen (чтобы не было List внутри ScrollView)
        List {
            staticSection
            dynamicSection
        }
        .navigationTitle("route.lists.title")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Toggle(isOn: $showFavoritesOnly) {
                    Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                }
                .toggleStyle(.button)
                .help("lists.toolbar.filterFavorites.help")
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    EditButton()
                    Button {
                        addItem()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("lists.toolbar.add.accessibilityLabel")
                }
            }
        }
        .searchable(
            text: $searchText,
            prompt: "lists.search.prompt"
        )
    }

    // MARK: - Sections

    private var staticSection: some View {
        Section("lists.section.static") {
            Label("lists.static.row.plain", systemImage: "list.bullet")

            Label("lists.static.row.detail", systemImage: "info.circle")
                .foregroundColor(.secondary)

            HStack {
                Text("lists.static.row.badgeTitle")
                Spacer()
                Text("lists.static.row.badgeLabel")
                    .font(.caption2)
                    .padding(.horizontal, 6.0)
                    .padding(.vertical, 2.0)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.15))
                    )
            }
        }
    }

    private var dynamicSection: some View {
        Section("lists.section.dynamic") {
            if filteredItems.isEmpty {
                Text("lists.emptyState")
                    .foregroundColor(.secondary)
            } else {
                ForEach(filteredItems) { item in
                    row(for: item)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
        }
    }

    // MARK: - Row

    private func row(for item: DemoItem) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if item.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            container.logger.log("Tapped \(item.title)", category: "lists")
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                toggleFavorite(item)
            } label: {
                Label(
                    item.isFavorite ? "lists.action.unfavorite" : "lists.action.favorite",
                    systemImage: item.isFavorite ? "star.slash" : "star"
                )
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteSingle(item)
            } label: {
                Label("lists.action.delete", systemImage: "trash")
            }
        }
    }

    // MARK: - Actions

    private func addItem() {
        let index: Int = items.count + 1
        let titleTemplate: String = NSLocalizedString(
            "lists.item.titlePattern",
            comment: "Pattern for new item title in lists screen"
        )
        let subtitle: String = NSLocalizedString(
            "lists.item.subtitleCreatedNow",
            comment: "Subtitle for a newly created item"
        )

        let newItem: DemoItem = DemoItem(
            title: String(format: titleTemplate, index),
            subtitle: subtitle,
            isFavorite: false
        )

        items.append(newItem)
        container.analytics.track(
            "lists.add",
            params: ["title": newItem.title]
        )
    }

    private func toggleFavorite(_ item: DemoItem) {
        guard let index: Int = items.firstIndex(of: item) else {
            return
        }
        items[index].isFavorite.toggle()
    }

    private func deleteSingle(_ item: DemoItem) {
        guard let index: Int = items.firstIndex(of: item) else {
            return
        }
        items.remove(at: index)
    }

    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func moveItems(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - Model

public struct DemoItem: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var subtitle: String
    public var isFavorite: Bool

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        isFavorite: Bool
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isFavorite = isFavorite
    }
}

public extension DemoItem {
    static var sample: [DemoItem] {
        let titleTemplate: String = NSLocalizedString(
            "lists.item.titlePattern",
            comment: "Pattern for sample item title in lists screen"
        )
        let subtitleTemplate: String = NSLocalizedString(
            "lists.sample.subtitlePattern",
            comment: "Pattern for sample item subtitle in lists screen"
        )

        return (1...12).map { index in
            DemoItem(
                title: String(format: titleTemplate, index),
                subtitle: String(format: subtitleTemplate, index),
                isFavorite: index % 3 == 0
            )
        }
    }
}

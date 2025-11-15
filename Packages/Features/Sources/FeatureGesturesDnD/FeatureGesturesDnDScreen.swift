
//
//  FeatureGesturesDnDScreen.swift
//  Features
//
//  Created by Fuchs on 5/11/25.
//

import SwiftUI
import AppCore
import DesignSystem
import UniformTypeIdentifiers

public struct FeatureGesturesDnDScreen: View {
    let container: AppContainer

    @State private var tapCount: Int = 0
    @State private var longPressed: Bool = false

    @State private var dragOffset: CGSize = .zero

    @State private var leftItems: [DnDItem] = DnDItem.sampleLeft
    @State private var rightItems: [DnDItem] = DnDItem.sampleRight

    @State private var isLeftTargeted: Bool = false
    @State private var isRightTargeted: Bool = false

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "route.gesturesDnD.title",
                comment: "Gestures and drag and drop screen title"
            )
        ) {
            basicGesturesCard
            dragCard
            dragAndDropCard
        }
    }

    // MARK: - 1. Tap / Long press

    private var basicGesturesCard: some View {
        Card {
            Text("gestures.basic.title")
                .font(.headline)

            Text("gestures.basic.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            RoundedRectangle(cornerRadius: 16.0)
                .fill(
                    longPressed
                    ? Color.orange.opacity(0.9)
                    : Color.blue.opacity(0.8)
                )
                .overlay(
                    VStack(spacing: 6.0) {
                        Text("gestures.basic.tapArea.title")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(tapCountLabel)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        Text(
                            longPressed
                            ? "gestures.basic.longPressed"
                            : "gestures.basic.longPressHint"
                        )
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                )
                .frame(height: 110.0)
                .onTapGesture {
                    tapCount += 1
                }
                .onTapGesture(count: 2) {
                    tapCount += 5
                }
                .onLongPressGesture(minimumDuration: 0.6) {
                    longPressed.toggle()
                    container.logger.log(
                        "Long press toggled: \(longPressed)",
                        category: "gestures"
                    )
                }
        }
    }

    // MARK: - 2. Drag с возвратом

    private var dragCard: some View {
        Card {
            Text("gestures.drag.title")
                .font(.headline)

            Text("gestures.drag.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18.0)
                    .strokeBorder(
                        Color.secondary.opacity(0.3),
                        style: StrokeStyle(lineWidth: 1.0, dash: [6.0, 4.0])
                    )
                    .frame(height: 140.0)

                Text("gestures.drag.label")
                    .font(.headline)
                    .padding()
                    .frame(width: 130.0, height: 70.0)
                    .background(
                        RoundedRectangle(cornerRadius: 18.0)
                            .fill(Color.dsCard)
                            .shadow(radius: 4.0)
                    )
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { _ in
                                withAnimation(
                                    .spring(
                                        response: 0.4,
                                        dampingFraction: 0.7
                                    )
                                ) {
                                    dragOffset = .zero
                                }
                            }
                    )
            }
        }
    }

    // MARK: - 3. Drag & Drop между колонками

    private var dragAndDropCard: some View {
        Card {
            Text("gestures.dnd.title")
                .font(.headline)

            Text("gestures.dnd.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: DS.Spacing.m) {
                dndColumn(
                    title: NSLocalizedString(
                        "gestures.dnd.columnA",
                        comment: "Title for left DnD column"
                    ),
                    items: leftItems,
                    isTargeted: $isLeftTargeted,
                    column: .left
                )
                dndColumn(
                    title: NSLocalizedString(
                        "gestures.dnd.columnB",
                        comment: "Title for right DnD column"
                    ),
                    items: rightItems,
                    isTargeted: $isRightTargeted,
                    column: .right
                )
            }
        }
    }

    private func dndColumn(
        title: String,
        items: [DnDItem],
        isTargeted: Binding<Bool>,
        column: DnDColumn
    ) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.s) {
            HStack {
                Text(title)
                    .font(.subheadline.bold())
                Spacer()
                Text("\(items.count)")
                    .font(.caption2)
                    .padding(.horizontal, 6.0)
                    .padding(.vertical, 2.0)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.12))
                    )
            }

            if items.isEmpty {
                Text("gestures.dnd.placeholder")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 60.0,
                        alignment: .center
                    )
            } else {
                ForEach(items) { item in
                    dndRow(item: item)
                }
            }
        }
        .padding(DS.Spacing.m)
        .frame(maxWidth: .infinity, minHeight: 120.0, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.m)
                .fill(Color.dsBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.Radius.m)
                .strokeBorder(
                    isTargeted.wrappedValue
                    ? Color.blue
                    : Color.secondary.opacity(0.3),
                    style: StrokeStyle(
                        lineWidth: isTargeted.wrappedValue ? 2.0 : 1.0,
                        dash: isTargeted.wrappedValue ? [] : [6.0, 4.0]
                    )
                )
        )
        .onDrop(of: [UTType.text], isTargeted: isTargeted) { providers in
            handleDrop(providers, to: column)
        }
    }

    private func dndRow(item: DnDItem) -> some View {
        HStack {
            Image(systemName: "square.fill")
                .foregroundColor(item.color)

            VStack(alignment: .leading) {
                Text(item.title)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(8.0)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.dsCard)
        )
        .onDrag {
            NSItemProvider(object: item.id.uuidString as NSString)
        }
    }

    // MARK: - Drop handling

    private enum DnDColumn {
        case left
        case right
    }

    private func handleDrop(
        _ providers: [NSItemProvider],
        to column: DnDColumn
    ) -> Bool {
        var accepted: Bool = false

        for provider in providers {
            if provider.canLoadObject(ofClass: NSString.self) {
                accepted = true
                provider.loadObject(ofClass: NSString.self) { object, _ in
                    guard let idString = object as? String,
                          let id = UUID(uuidString: idString) else {
                        return
                    }

                    DispatchQueue.main.async {
                        moveItem(with: id, to: column)
                    }
                }
            }
        }

        return accepted
    }

    private func moveItem(with id: UUID, to column: DnDColumn) {
        if let index = leftItems.firstIndex(where: { $0.id == id }) {
            let item: DnDItem = leftItems.remove(at: index)
            insert(item: item, to: column)
            return
        }
        if let index = rightItems.firstIndex(where: { $0.id == id }) {
            let item: DnDItem = rightItems.remove(at: index)
            insert(item: item, to: column)
            return
        }
    }

    private func insert(item: DnDItem, to column: DnDColumn) {
        switch column {
        case .left:
            if !leftItems.contains(item) {
                leftItems.append(item)
            }
        case .right:
            if !rightItems.contains(item) {
                rightItems.append(item)
            }
        }

        let columnName: String = (column == .left ? "left" : "right")
        container.logger.log(
            "Dropped \(item.title) to \(columnName)",
            category: "dnd"
        )
    }

    // MARK: - Helpers

    private var tapCountLabel: String {
        String(
            format: NSLocalizedString(
                "gestures.basic.tapCount",
                comment: "Tap count label with value"
            ),
            tapCount
        )
    }
}

// MARK: - DnD model

public struct DnDItem: Identifiable, Hashable {
    public let id: UUID
    public var title: String
    public var subtitle: String
    public var color: Color

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        color: Color
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.color = color
    }
}

public extension DnDItem {
    static var sampleLeft: [DnDItem] {
        [
            DnDItem(
                title: NSLocalizedString(
                    "gestures.dnd.item.alpha.title",
                    comment: "DnD item Alpha title"
                ),
                subtitle: NSLocalizedString(
                    "gestures.dnd.item.subtitle.columnA",
                    comment: "DnD item subtitle from column A"
                ),
                color: .blue
            ),
            DnDItem(
                title: NSLocalizedString(
                    "gestures.dnd.item.bravo.title",
                    comment: "DnD item Bravo title"
                ),
                subtitle: NSLocalizedString(
                    "gestures.dnd.item.subtitle.columnA",
                    comment: "DnD item subtitle from column A"
                ),
                color: .green
            ),
            DnDItem(
                title: NSLocalizedString(
                    "gestures.dnd.item.charlie.title",
                    comment: "DnD item Charlie title"
                ),
                subtitle: NSLocalizedString(
                    "gestures.dnd.item.subtitle.columnA",
                    comment: "DnD item subtitle from column A"
                ),
                color: .purple
            )
        ]
    }

    static var sampleRight: [DnDItem] {
        [
            DnDItem(
                title: NSLocalizedString(
                    "gestures.dnd.item.delta.title",
                    comment: "DnD item Delta title"
                ),
                subtitle: NSLocalizedString(
                    "gestures.dnd.item.subtitle.columnB",
                    comment: "DnD item subtitle from column B"
                ),
                color: .orange
            ),
            DnDItem(
                title: NSLocalizedString(
                    "gestures.dnd.item.echo.title",
                    comment: "DnD item Echo title"
                ),
                subtitle: NSLocalizedString(
                    "gestures.dnd.item.subtitle.columnB",
                    comment: "DnD item subtitle from column B"
                ),
                color: .pink
            )
        ]
    }
}

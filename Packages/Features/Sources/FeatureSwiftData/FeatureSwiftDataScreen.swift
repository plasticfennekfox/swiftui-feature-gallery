//
//  Untitled.swift
//  Features
//
//  Created by Fuchs on 9/11/25.
//

import SwiftUI
import SwiftData
import AppCore
import DesignSystem

public struct FeatureSwiftDataScreen: View {
    let container: AppContainer

    @Environment(\.modelContext) private var modelContext
    @Query(
        sort: \SwiftNote.createdAt,
        order: .reverse,
        animation: .default
    )
    private var notes: [SwiftNote]

    @State private var newTitle: String = ""
    @State private var newText: String = ""
    @State private var selectedPriority: NotePriority = .normal
    @State private var filter: NotesFilter = .all

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(title: "SwiftData") {
            newNoteCard
            listCard
        }
    }

    // MARK: - Card: создание записи

    private var newNoteCard: some View {
        Card {
            Text("Create note")
                .font(.headline)

            TextField("Title", text: $newTitle)
                .textFieldStyle(.roundedBorder)

            TextField("Text", text: $newText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)

            Picker("Priority", selection: $selectedPriority) {
                ForEach(NotePriority.allCases) { p in
                    Text(p.title).tag(p)
                }
            }
            .pickerStyle(.segmented)

            AppButton("Save") {
                addNote()
            }
            .disabled(!canSave)
            .opacity(canSave ? 1.0 : 0.5)
        }
    }

    private var canSave: Bool {
        !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Card: список записей

    private var listCard: some View {
        Card {
            HStack {
                Text("Notes")
                    .font(.headline)
                Spacer()
                filterControl
            }

            if filteredNotes.isEmpty {
                Text("No notes yet. Add one above.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, DS.Spacing.s)
            } else {
                VStack(spacing: DS.Spacing.s) {
                    ForEach(filteredNotes) { note in
                        noteRow(note)
                    }
                }
                .padding(.top, DS.Spacing.s)
            }
        }
    }

    private var filterControl: some View {
        Picker("", selection: $filter) {
            ForEach(NotesFilter.allCases) { f in
                Text(f.title).tag(f)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 220)
    }

    private var filteredNotes: [SwiftNote] {
        notes.filter { note in
            switch filter {
            case .all:
                true
            case .pinned:
                note.isPinned
            case .highPriority:
                note.priority == .high
            }
        }
    }

    private func noteRow(_ note: SwiftNote) -> some View {
        HStack(alignment: .top, spacing: DS.Spacing.m) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(note.title)
                        .font(.subheadline.bold())
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    if note.priority == .high {
                        Text("HIGH")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(Color.red.opacity(0.15))
                            )
                            .foregroundColor(.red)
                    }
                }

                if !note.text.isEmpty {
                    Text(note.text)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Text(note.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.8))
            }

            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.dsCard)
        )
        .contextMenu {
            Button(note.isPinned ? "Unpin" : "Pin") {
                togglePin(note)
            }
            Button("Delete", role: .destructive) {
                deleteNote(note)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                togglePin(note)
            } label: {
                Label(note.isPinned ? "Unpin" : "Pin",
                      systemImage: note.isPinned ? "pin.slash" : "pin.fill")
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteNote(note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    // MARK: - Actions

    private func addNote() {
        guard canSave else { return }
        let note = SwiftNote(
            title: newTitle,
            text: newText,
            isPinned: false,
            createdAt: .now,
            priority: selectedPriority
        )
        modelContext.insert(note)
        container.analytics.track("swiftdata.add_note", params: [
            "priority": selectedPriority.rawValue
        ])

        newTitle = ""
        newText = ""
        selectedPriority = .normal
    }

    private func deleteNote(_ note: SwiftNote) {
        modelContext.delete(note)
    }

    private func togglePin(_ note: SwiftNote) {
        note.isPinned.toggle()
    }
}

// MARK: - Filter enum

private enum NotesFilter: String, CaseIterable, Identifiable {
    case all, pinned, highPriority

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All"
        case .pinned: return "Pinned"
        case .highPriority: return "High"
        }
    }
}


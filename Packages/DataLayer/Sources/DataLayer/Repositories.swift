//
//  Repositories.swift
//  DataLayer
//
//  Created by Fuchs on 3/11/25.
//

import Foundation

public struct Note: Identifiable, Hashable, Sendable { public let id: UUID; public var title: String; public var text: String; public init(id: UUID = .init(), title: String, text: String) { self.id = id; self.title = title; self.text = text } }

public protocol NotesRepository: Sendable {
    func list() async -> [Note]
    func add(_ note: Note) async
}

public actor InMemoryNotesRepository: NotesRepository {
    private var items: [Note] = [Note(title: "Hello", text: "Demo note")]
    public init() {}
    public func list() async -> [Note] { items }
    public func add(_ note: Note) async { items.append(note) }
}

//
//  InMemoryNotesRepositoryTests.swift
//  ExampleApp
//
//  Created by Fuchs on 8/11/25.
//

import XCTest
@testable import DataLayer

final class InMemoryNotesRepositoryTests: XCTestCase {

    func testInitialListContainsDemoNote() async {
        let repo = InMemoryNotesRepository()
        let notes = await repo.list()
        XCTAssertFalse(notes.isEmpty, "В демо-репозитории должна быть хотя бы одна запись")
    }

    func testAddNoteAppendsToList() async {
        let repo = InMemoryNotesRepository()

        let before = await repo.list()
        let note = Note(title: "Test", text: "Note")
        await repo.add(note)
        let after = await repo.list()

        XCTAssertEqual(after.count, before.count + 1)
        XCTAssertTrue(after.contains(where: { $0.title == "Test" && $0.text == "Note" }))
    }
}

//
//  SimpleNotesTests.swift
//  SimpleNotesTests
//
//  Created by Kamil Biktineyev on 01.07.2024.
//

import XCTest
@testable import SimpleNotes

final class SimpleNotesTests: XCTestCase {
    
    var sut: NotesListPresenter! // System Under Test (SUT)
    var noteListViewController: NotesListViewControllerSpy!
    var dataManager: DataManagerSpy!
    
    override func setUp() {
        super.setUp()
        noteListViewController = NotesListViewControllerSpy()
        dataManager = DataManagerSpy()
        sut = NotesListPresenter(view: noteListViewController, userDefaults: dataManager, notes: [])
    }

    override func tearDown() {
        noteListViewController = nil
        dataManager = nil
        sut = nil
        super.tearDown()
    }
    
    // Тест на корректный поиск заметок и нечувствительность поиска к регистру
    func testFilterNotes() {
        sut.notes = [Note(name: "Homework", details: ""), Note(name: "Hometown", details: ""), Note(name: "Sport", details: ""), Note(name: "Hotels", details: ""),]
        let expectedResult = sut.notes.filter { $0.name.contains("Home") }
        
        sut.filterNotes(searchingText: "homE")
        XCTAssertEqual(sut.filteredNotes, expectedResult)
    }
}

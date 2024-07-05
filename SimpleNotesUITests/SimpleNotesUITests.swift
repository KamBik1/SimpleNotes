//
//  SimpleNotesUITests.swift
//  SimpleNotesUITests
//
//  Created by Kamil Biktineyev on 01.07.2024.
//

import XCTest

final class SimpleNotesUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }
    
    // Тест на создание новой заметки
    func testAddNote() throws {
        let noteName = "English words"
        let app = XCUIApplication()
        let addNoteButton = app.navigationBars.buttons["AddNote"]
        let alertTextField = app.alerts.textFields.element
        let alertSaveButton = app.alerts.buttons["Save"]
        let cells = app.cells
        
        app.launch()
        addNoteButton.tap()
        alertTextField.tap()
        alertTextField.typeText(noteName)
        alertSaveButton.tap()
        
        XCTAssert(cells.staticTexts[noteName].exists)
    }
    
    // Тест на переименование заметки
    func testRenameNote() throws {
        let firstNoteName = "Football"
        let secondNoteName = "Volleyball"
        let app = XCUIApplication()
        let addNoteButton = app.navigationBars.buttons["AddNote"]
        let alertTextField = app.alerts.textFields.element
        let alertSaveButton = app.alerts.buttons["Save"]
        let cellWithFirstNote = app.tables.cells.containing(.staticText, identifier: firstNoteName).element
        let alertRenameButton = app.alerts.buttons["Rename"]
        let cells = app.cells
        
        app.launch()
        addNoteButton.tap()
        alertTextField.tap()
        alertTextField.typeText(firstNoteName)
        alertSaveButton.tap()
        cellWithFirstNote.press(forDuration: 1.5)
        alertTextField.tap()
        alertTextField.typeText(secondNoteName)
        alertRenameButton.tap()
        
        XCTAssert(cells.staticTexts[secondNoteName].exists)
    }
    
    // Тест на удаление заметки
    func testDeleteNote() throws {
        let noteName = "Homework"
        let app = XCUIApplication()
        let addNoteButton = app.navigationBars.buttons["AddNote"]
        let alertTextField = app.alerts.textFields.element
        let alertSaveButton = app.alerts.buttons["Save"]
        let cellWithNote = app.tables.cells.containing(.staticText, identifier: noteName).element
        let tableDeleteButton = app.tables.buttons["Delete"]
        let cells = app.cells
        
        app.launch()
        addNoteButton.tap()
        alertTextField.tap()
        alertTextField.typeText(noteName)
        alertSaveButton.tap()
        cellWithNote.swipeLeft()
        tableDeleteButton.tap()
        
        XCTAssert(!cells.staticTexts[noteName].exists)
    }
    
    // Тест на сохранение заметки
    func testSaveNote() throws {
        let noteName = "Important thing"
        let noteDetails = "12345"
        let app = XCUIApplication()
        let addNoteButton = app.navigationBars.buttons["AddNote"]
        let alertTextField = app.alerts.textFields.element
        let alertSaveButton = app.alerts.buttons["Save"]
        let cellWithNote = app.tables.cells.containing(.staticText, identifier: noteName).element
        let textView = app.textViews["NoteTextView"]
        
        app.launch()
        addNoteButton.tap()
        alertTextField.tap()
        alertTextField.typeText(noteName)
        alertSaveButton.tap()
        cellWithNote.tap()
        textView.tap()
        textView.typeText(noteDetails)
        app.terminate()
        app.launch()
        cellWithNote.tap()
        
        XCTAssertEqual(textView.value as? String, noteDetails)
    }
    
    // Тест на корректный поиск по заметкам
    func testSearchForNote() throws {
        let firstNoteName = "Dota"
        let secondNoteName = "Doom"
        let app = XCUIApplication()
        let addNoteButton = app.navigationBars.buttons["AddNote"]
        let alertTextField = app.alerts.textFields.element
        let alertSaveButton = app.alerts.buttons["Save"]
        let searchField = app.searchFields["Search"]
        let cells = app.cells
        
        app.launch()
        addNoteButton.tap()
        alertTextField.tap()
        alertTextField.typeText(firstNoteName)
        alertSaveButton.tap()
        addNoteButton.tap()
        alertTextField.tap()
        alertTextField.typeText(secondNoteName)
        alertSaveButton.tap()
        searchField.tap()
        searchField.typeText(firstNoteName)
        
        XCTAssert(cells.staticTexts[firstNoteName].exists)
        XCTAssert(!cells.staticTexts[secondNoteName].exists)
    }
}

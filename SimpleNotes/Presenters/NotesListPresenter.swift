//
//  NotesListPresenter.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 01.07.2024.
//

import Foundation

protocol NotesListPresenterProtocol: AnyObject {
    var notes: [Note] { get set }
    var filteredNotes: [Note] { get set }
    init(view: NotesListProtocol, userDefaults: DataManagerProtocol, notes: [Note])
    func addNote(name: String)
    func deleteNote(index: Int)
    func renameNote(newName: String, index: Int)
    func filterNotes(searchingText: String)
}

protocol NotesListPresenterDelegate: AnyObject {
    func updateNoteDetails(details: String?, index: Int)
}

final class NotesListPresenter: NotesListPresenterProtocol {
    weak var view: NotesListProtocol?
    private var userDefaults: DataManagerProtocol!
    var notes: [Note]
    var filteredNotes: [Note] = []
    
    required init(view: NotesListProtocol, userDefaults: DataManagerProtocol, notes: [Note]) {
        self.view = view
        self.userDefaults = userDefaults
        self.notes = notes
    }
    
    // Определяем метод для сохранения изменений в User Defaults
    private func saveChanges() {
        userDefaults.saveNotes(notes: self.notes)
    }
    
    // Определяем метод для добавления заметок
    func addNote(name: String) {
        notes.append(Note(name: name, details: ""))
        saveChanges()
    }
    
    // Определяем метод для удаления заметок
    func deleteNote(index: Int) {
        notes.remove(at: index)
        saveChanges()
    }
    
    // Определяем метод для переименования заметок
    func renameNote(newName: String, index: Int) {
        notes[index].name = newName
        saveChanges()
    }
    
    // Определяем метод для поиска заметок в Search Bar
    func filterNotes(searchingText: String) {
        filteredNotes.removeAll()
        guard searchingText != "" || searchingText != " " else { return }
        
        for note in notes {
            let searchNote = searchingText.lowercased()
            let isNoteContains = note.name.lowercased().contains(searchNote)
            if isNoteContains == true {
                filteredNotes.append(note)
            }
        }
    }
}

extension NotesListPresenter: NotesListPresenterDelegate {
    // Определяем метод для сохранения данных внутри заметки
    func updateNoteDetails(details: String?, index: Int) {
        if let details = details {
            notes[index].details = details
        }
        else {
            notes[index].details = ""
        }
        saveChanges()
        view?.refreshTableView()
    }
}

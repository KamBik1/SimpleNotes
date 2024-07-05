//
//  DetailedNotePresenter.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 02.07.2024.
//

import Foundation

protocol DetailedNotePresenterProtocol: AnyObject {
    var delagate: NotesListPresenterDelegate? { get set }
    var note: Note { get set }
    var noteIndexPath: Int { get set }
    init(view: DetailedNoteProtocol, note: Note, noteIndexPath: Int, delegate: NotesListPresenterDelegate)
    
}

final class DetailedNotePresenter: DetailedNotePresenterProtocol {
    weak var view: DetailedNoteProtocol?
    weak var delagate: NotesListPresenterDelegate?
    var note: Note
    var noteIndexPath: Int
    
    required init(view: DetailedNoteProtocol, note: Note, noteIndexPath: Int, delegate: NotesListPresenterDelegate) {
        self.view = view
        self.note = note
        self.noteIndexPath = noteIndexPath
        self.delagate = delegate
    }
}

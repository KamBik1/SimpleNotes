//
//  VeiwBuilder.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 01.07.2024.
//

import Foundation
import UIKit

protocol ViewBuilderProtocol: AnyObject {
    static func createNotesListView() -> UIViewController
    static func createDetailedNoteView(note: Note, noteIndexPath: Int, delegate: NotesListPresenterDelegate) -> UIViewController
}

final class ViewBuilder: ViewBuilderProtocol {
    // Определяем метод для создания основной view со списком заметок
    static func createNotesListView() -> UIViewController {
        let view = NotesListViewController()
        let userDefaults = DataManager()
        let presenter = NotesListPresenter(view: view, userDefaults: userDefaults, notes: userDefaults.getNotes())
        view.presenter = presenter
        return view
    }
    
    // Определяем метод для создания второстепенной view
    static func createDetailedNoteView(note: Note, noteIndexPath: Int, delegate: NotesListPresenterDelegate) -> UIViewController {
        let view = DetailedNoteViewController()
        let presenter = DetailedNotePresenter(view: view, note: note, noteIndexPath: noteIndexPath, delegate: delegate)
        view.presenter = presenter
        return view
    }
}

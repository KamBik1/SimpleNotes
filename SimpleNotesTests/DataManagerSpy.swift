//
//  DataManagerSpy.swift
//  SimpleNotesTests
//
//  Created by Kamil Biktineyev on 05.07.2024.
//

@testable import SimpleNotes

final class DataManagerSpy: DataManagerProtocol {
    func saveNotes(notes: [SimpleNotes.Note]) {
    }
    
    func getNotes() -> [SimpleNotes.Note] {
        return[]
    }
}

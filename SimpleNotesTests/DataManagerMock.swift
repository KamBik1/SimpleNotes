//
//  DataManagerMock.swift
//  SimpleNotesTests
//
//  Created by Kamil Biktineyev on 05.07.2024.
//

@testable import SimpleNotes

final class DataManagerMock: DataManagerProtocol {
    func saveNotes(notes: [SimpleNotes.Note]) {
    }
    
    func getNotes() -> [SimpleNotes.Note] {
        return[]
    }
}

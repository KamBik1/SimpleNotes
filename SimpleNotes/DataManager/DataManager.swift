//
//  UserDefaults.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 03.07.2024.
//

import Foundation

protocol DataManagerProtocol: AnyObject {
    func saveNotes(notes: [Note])
    func getNotes() -> [Note]
}

final class DataManager: DataManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let key = "NotesKey"
    
    // Определяем метод для сохранения notes в User Defaults
    func saveNotes(notes: [Note]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notes)
            userDefaults.setValue(data, forKey: key)
        }
        catch {
            print("UserDefaultsSavingError: \(error)")
        }
    }
    
    // Определяем метод для получения notes из User Defaults
    func getNotes() -> [Note] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        
        do {
            let decoder = JSONDecoder()
            let notes = try decoder.decode([Note].self, from: data)
            return notes
        }
        catch {
            print("UserDefaultsGettingError: \(error)")
        }
        return []
    }
}

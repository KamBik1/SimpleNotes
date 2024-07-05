//
//  Note.swift
//  SimpleNotes
//
//  Created by Kamil Biktineyev on 01.07.2024.
//

import Foundation

struct Note: Codable, Equatable {
    var name: String
    var details: String
    var id = UUID()
}

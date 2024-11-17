//
//  UserProfile.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/16/24.
//

import Foundation

struct UserProfile: Codable {
    var id: UUID
    var name: String
    var email: String
    var favorites: [Product]
    var scannedHistory: [Product]
    
    init(id: UUID = UUID(), name: String, email: String, favorites: [Product] = [], scannedHistory: [Product] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.favorites = favorites
        self.scannedHistory = scannedHistory
    }
}

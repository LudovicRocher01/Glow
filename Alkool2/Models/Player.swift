//
//  Player.swift
//  Alkool2
//
//  Created by Ludovic Rocher on 17/06/2025.
//

import Foundation

struct Player: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var avatar: String

    static func loadFromUserDefaults() -> [Player] {
        if let data = UserDefaults.standard.data(forKey: "savedPlayers"),
           let decoded = try? JSONDecoder().decode([Player].self, from: data) {
            return decoded
        }
        return []
    }

    static func saveToUserDefaults(_ players: [Player]) {
        if let data = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(data, forKey: "savedPlayers")
        }
    }
}

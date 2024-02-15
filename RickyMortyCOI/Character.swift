//
//  Character.swift
//  RickyMortyCOI
//
//  Created by Sebastian Hajduk on 15/02/2024.
//

import Foundation

struct Character: Equatable, Identifiable, Codable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let origin: LastKnownLocation
    let location: Origin
    let image: String

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}

struct LastKnownLocation: Equatable, Codable {
    var name: String
}

struct Origin: Equatable, Codable {
    var name: String
}

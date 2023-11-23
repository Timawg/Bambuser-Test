//
//  Country.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-06.
//

import Foundation

// MARK: - Country
struct Country: Codable, Identifiable, Hashable {

    let name: Name
    let cca2, flag: String
    let population: Int
    let area: Double
    
    var id: String {
        UUID().uuidString
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Name
struct Name: Codable {
    let common, official: String
}

typealias Countries = [Country]


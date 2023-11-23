//
//  CountryDetails.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation

struct CountryDetails: Decodable {
    let name: Name
    let tld: [String]
    let cca2, ccn3, cca3: String?
    let cioc: String?
    let independent: Bool
    let status: String
    let unMember: Bool
    let capital, altSpellings: [String]?
    let region, subregion: String?
    let translations: [String: Translation]
    let latlng: [Double]?
    let landlocked: Bool
    let borders: [String]?
    let area: Int
    let demonyms: Demonyms?
    let flag: String
    let maps: Maps?
    let population: Int
    let fifa: String?
    let car: Car?
    let timezones, continents: [String]
    let flags: Flags
    let coatOfArms: CoatOfArms?
    let startOfWeek: String
    let capitalInfo: CapitalInfo?
}

// MARK: - CapitalInfo
struct CapitalInfo: Codable {
    let latlng: [Double]?
}

// MARK: - Car
struct Car: Codable {
    let signs: [String]
    let side: String
}

// MARK: - CoatOfArms
struct CoatOfArms: Codable {
    let png: String?
    let svg: String?
}

// MARK: - Demonyms
struct Demonyms: Codable {
    let eng, fra: Eng?
}

// MARK: - Eng
struct Eng: Codable {
    let f, m: String?
}

// MARK: - Flags
struct Flags: Codable {
    let png: String
    let svg: String
}

// MARK: - Maps
struct Maps: Codable {
    let googleMaps, openStreetMaps: String
}

// MARK: - Translation
struct Translation: Codable {
    let official, common: String
}

typealias CountryDetailsArray = [CountryDetails]

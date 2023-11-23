//
//  Hosts.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-21.
//

import Foundation

protocol Endpoint {
    typealias Host = String
    typealias Path = String
    var scheme: Scheme { get }
    var host: Host { get }
    var path: Path { get }
}

enum RestCountriesEndpoint: Endpoint {
    
    case restCountries(path: RestCountriesEndpoint.Paths)
    
    var scheme: Scheme {
        return .https
    }
    
    var host: Host {
        switch self {
        case .restCountries: "restcountries.com"
        }
    }
    
    var path: Path {
        switch self {
        case .restCountries(path: let path):
            return path.path
        }
    }
}

extension RestCountriesEndpoint {
    
    enum Paths {
        case all(fields: [Field] = Field.allCases)
        case country(alphaCode: String)
        
        var version: String {
            return "v3.1"
        }
        
        var path: String {
            switch self {
            case .all: return "/\(version)/all"
            case .country(let alphaCode): return "/\(version)/alpha/\(alphaCode)"
            }
        }

        enum Field: String, CaseIterable {
            case name
            case flag
            case cca2
            case population
            case area
        }
    }
}

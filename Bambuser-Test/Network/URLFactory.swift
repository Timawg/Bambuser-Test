//
//  URLFactory.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation

protocol URLFactory {
    static func createURL(from endpoint: Endpoint) -> URL?
}

struct DefaultURLFactory: URLFactory {
    
    static func createURL(from endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        switch endpoint as? RestCountriesEndpoint {
        case .restCountries(path: let path):
            switch path {
            case .all(fields: let fields):
                let fields = fields.map(\.rawValue).joined(separator: ",")
                urlComponents.queryItems = [.init(name: "fields", value: fields)]
            default: break
            }
        case .none:
            break
        }

        return urlComponents.url
    }
}

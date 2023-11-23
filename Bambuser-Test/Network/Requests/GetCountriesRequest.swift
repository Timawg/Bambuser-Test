//
//  PostsRequest.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-06.
//

import Foundation

struct GetCountriesRequest: RequestProtocol {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .GET
    let url: URL?
    
    init(path: RestCountriesEndpoint.Paths) {
        self.endpoint = RestCountriesEndpoint.restCountries(path: path)
        self.url = DefaultURLFactory.createURL(from: endpoint)
    }

    func request() throws -> URLRequest {
        guard let url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
}

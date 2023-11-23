//
//  GetCountriesRequestTests.swift
//  Bambuser-TestTests
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import XCTest
@testable import Bambuser_Test

final class GetCountriesRequestTests: XCTestCase {

    func testAllCountries() throws {
        let request = GetCountriesRequest(path: .all())
        let expectedURL: URL = try XCTUnwrap(.init(string: "https://restcountries.com/v3.1/all?fields=name,flag,cca2,population,area"))
        let expectedUrl = URLRequest(url: expectedURL).url
        let actualUrl = try request.request().url
        XCTAssertEqual(expectedUrl, actualUrl)
    }
    
    func testSingleCountry() throws {
        let request = GetCountriesRequest(path: .country(alphaCode: "ZA"))
        let expectedURL: URL = try XCTUnwrap(.init(string: "https://restcountries.com/v3.1/alpha/ZA"))
        let expectedUrl = URLRequest(url: expectedURL).url
        let actualUrl = try request.request().url
        XCTAssertEqual(expectedUrl, actualUrl)
    }
}

//
//  Bambuser_TestTests.swift
//  Bambuser-TestTests
//
//  Created by Tim Gunnarsson on 2023-11-21.
//

import XCTest
@testable import Bambuser_Test

final class CountryDetailViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testViewModelSuccess() async throws {
        let config = URLSessionConfiguration.default

        // Given
        let expectedCountryDetails: CountryDetailsArray = createMockDetails()
        let data = try JSONEncoder().encode(expectedCountryDetails)
        let urlProtocol = MockURLProtocol.self
        urlProtocol.requestHandler = { request in
            (HTTPURLResponse.init(), data)
        }
        config.protocolClasses = [urlProtocol]
        let session = URLSession(configuration: config)
        let networkService = NetworkService(session: session)
        
        let viewModel = CountryDetailViewModel(networkService: networkService, country: .init(name: .init(common: "South Africa", official: "Republic of South Africa"), cca2: "ZA", flag: "", population: 0, area: 0))
        
        XCTAssertEqual(viewModel.viewState, .loading)
        
        // When
        await viewModel.retrieveCountryDetails()
        
        // Then
        XCTAssertEqual(viewModel.viewState, .completed)
        XCTAssertEqual(viewModel.officalName, "Republic of South Africa")
        XCTAssertEqual(viewModel.name, "South Africa")
        XCTAssertEqual(viewModel.metaData, ["Capital: Cape Town", "Population: 2 000 000", "Area: 345 678 km²", "Region: Southern Africa, Africa", "Timezones: UTC + 1", "Is independent? Yes"])
        XCTAssertEqual(viewModel.region.center.latitude, 70)
        XCTAssertEqual(viewModel.region.center.longitude, 80)
        
    }
    
    func testViewModelFailure() async throws {
        
        let config = URLSessionConfiguration.default

        let urlProtocol = MockURLProtocol.self
        urlProtocol.error = URLError(.badServerResponse)
        config.protocolClasses = [urlProtocol]
        let session = URLSession(configuration: config)
        let networkService = NetworkService(session: session)
        
        let viewModel = CountryDetailViewModel(networkService: networkService, country: .init(name: .init(common: "South Africa", official: "Republic of South Africa"), cca2: "ZA", flag: "", population: 0, area: 0))
        
        
        await viewModel.retrieveCountryDetails()
        
        switch viewModel.viewState {
        case .failure(error: let error):
            XCTAssertEqual((error as! URLError).code, URLError(.badServerResponse).code)
        default: XCTFail()
        }
    }

    func createMockDetails() -> CountryDetailsArray {
        return [.init(
            name: .init(common: "South Africa", official: "Republic of South Africa"),
            tld: [],
            cca2: "ZA",
            ccn3: nil,
            cca3: nil,
            cioc: nil,
            independent: true,
            status: "Independent",
            unMember: true,
            capital: ["Cape Town"],
            altSpellings: nil,
            region: "Africa",
            subregion: "Southern Africa",
            latlng: [70, 80],
            landlocked: false,
            borders: nil,
            area: 345678,
            demonyms: nil,
            flag: "🇿🇦",
            maps: nil,
            population: 2000000,
            fifa: nil,
            car: nil,
            timezones: ["UTC + 1"],
            continents: ["Africa"],
            flags: .init(png: "https://test.com", svg: "https://test.com"),
            coatOfArms: nil,
            startOfWeek: "Monday",
            capitalInfo: nil)]
    }
}

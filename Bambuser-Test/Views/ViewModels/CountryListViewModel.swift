//
//  CountriesListViewModel.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation

final class CountryListViewModel: ObservableObject {
    
    let navigationTitle = "Countries"
    
    private let networkService: NetworkServiceProtocol
    @Published var viewState: ViewState = .loading
    @Published var countries: Countries = []
    @Published var sortOrder: SortOption = .name
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func metaData(for country: Country) -> String? {
        switch sortOrder {
        case .name:
            return nil
        case .population:
            return "Population: \(country.population.formatted())"
        case .area:
            return "Area: \(country.area.formatted()) km\u{00B2}"
        }
    }
    
    @MainActor
    func retrieveCountries() async {
        viewState = .loading
        let request = GetCountriesRequest(
            path: .all()
        )
        do {
            self.countries = try await networkService.perform(request: request)
            self.viewState = .completed
        } catch {
            self.viewState = .failure(error: error)
        }
    }
}

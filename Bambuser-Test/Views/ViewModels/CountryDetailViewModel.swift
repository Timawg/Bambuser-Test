//
//  CountryDetailsViewModel.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation
import MapKit

final class CountryDetailViewModel: ObservableObject {
    
    private let networkService: NetworkServiceProtocol
    private let country: Country
    private var countryDetails: CountryDetails?
    
    @Published var viewState: ViewState = .loading
    var region: MKCoordinateRegion
    
    init(networkService: NetworkServiceProtocol, country: Country) {
        self.networkService = networkService
        self.country = country
        self.viewState = .loading
        self.countryDetails = nil
        self.region = .init(.world)
    }
    
    var flag: String? {
        countryDetails?.flags.png
    }
    
    var name: String {
        country.name.common
    }
    
    var officalName: String? {
        countryDetails?.name.official
    }
    
    var metaData: [String] {
        return [
            capital, 
            population,
            area,
            regionText,
            timezones,
            independence
        ].compactMap { $0 }
    }
    
    private var capital: String? {
        guard let capital = countryDetails?.capital?.first else {
            return nil
        }
        return "Capital: \(capital)"
    }

    private var regionText: String? {
        guard let region = countryDetails?.region, let subregion = countryDetails?.subregion else {
            return nil
        }
        return "Region: \(subregion), \(region)"
    }
    
    private var population: String? {
        guard let population = countryDetails?.population else {
            return nil
        }
        return "Population: \(population.formatted())"
    }
    
    private var area: String? {
        guard let area = countryDetails?.area else {
            return nil
        }
        
        return "Area: \(area.formatted()) km\u{00B2}"
    }
    
   private var timezones: String? {
        guard let zones = countryDetails?.timezones, !zones.isEmpty else {
            return nil
        }
        return "Timezones: \(zones.joined(separator: ", "))"
    }
    
   private var independence: String? {
        guard let independent = countryDetails?.independent else {
            return nil
        }
        return "Is independent? \(independent ? "Yes" : "No")"
    }

    private func calculateRegion(area: Double, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> MKCoordinateRegion {
        
        // Calculate deltas
        let latitudeDelta = sqrt(area) / 110
        let longitudeDelta = (sqrt(area) / 110) + latitudeDelta
        
        // Calculate the span
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        // Create the coordinate region
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return MKCoordinateRegion(center: centerCoordinate, span: span)
    }
    
    @MainActor
    func retrieveCountryDetails() async {
        self.viewState = .loading
        
        let request = GetCountriesRequest(path: .country(alphaCode: country.cca2))
        do {
            let countryDetails: CountryDetailsArray = try await networkService.perform(request: request)
            self.countryDetails = countryDetails.first
            self.viewState = .completed
            if let coordinates = self.countryDetails?.latlng {
                self.region = calculateRegion(area: country.area, latitude: coordinates[0], longitude: coordinates[1])
            }
        } catch {
            self.viewState = .failure(error: error)
        }
    }
}

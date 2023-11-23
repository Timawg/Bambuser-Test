//
//  Bambuser_TestApp.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-21.
//

import SwiftUI

enum NavigationPath: Hashable {
    case list
    case detail(country: Country)
}

@main
struct Bambuser_TestApp: App {
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    @State private var navigationPaths = [NavigationPath]()
    @StateObject private var colorSchemeProxy: ColorSchemeProxy = .init()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPaths) {
                CountriesListView(viewModel: .init(networkService: networkService), navigationPaths: $navigationPaths)
                    .environmentObject(colorSchemeProxy)
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .list:
                            CountriesListView(
                                viewModel: .init(networkService: networkService),
                                navigationPaths: $navigationPaths
                            ).environmentObject(colorSchemeProxy)
                        case .detail(country: let country):
                            CountryDetailView(
                                viewModel: .init(
                                    networkService: networkService,
                                    country: country
                                )
                            )
                        }
                    }
            }
            .preferredColorScheme(colorSchemeProxy.selectedColorScheme)
        }
    }
}

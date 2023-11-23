//
//  ContentView.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-21.
//

import SwiftUI

struct CountriesListView: View {
    
    @EnvironmentObject var colorSchemeProxy: ColorSchemeProxy
    @StateObject var viewModel: CountryListViewModel
    @Binding var navigationPaths: [NavigationPath]
    @State var darkModeEnabled: Bool = false
    
    var body: some View {
        AsyncContentView(viewState: viewModel.viewState) {
            VStack {
                HStack {
                    SortingView(sortOption: $viewModel.sortOrder)
                    Toggle(isOn: $darkModeEnabled) {
                        HStack {
                            Spacer()
                            Text("Dark Mode")
                                .font(.system(size: 14))
                                
                        }
                    }
                    .frame(maxWidth: 150)
                }
                .padding(.horizontal)
                List(viewModel.countries.sorted(by: viewModel.sortOrder.sortingClosure)) { country in
                    HStack {
                        Text(country.flag)
                        Text(country.name.common)
                        Spacer()
                        
                        if let metaData = viewModel.metaData(for: country) {
                            Text(metaData)
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }

                    }.onTapGesture {
                        navigationPaths.append(.detail(country: country))
                    }
                }
            }
        } onRetry: {
            Task {
                await viewModel.retrieveCountries()
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            darkModeEnabled = colorSchemeProxy.selectedColorScheme == .dark
        }
        .task {
            await viewModel.retrieveCountries()
        }.onChange(of: darkModeEnabled, perform: { isOn in
            colorSchemeProxy.set(scheme: isOn ? .dark : .light)
        })
    }
}

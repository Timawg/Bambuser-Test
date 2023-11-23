//
//  CountryDetailView.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation
import SwiftUI
import MapKit

struct CountryDetailView: View {
    
    @StateObject var viewModel: CountryDetailViewModel
    
    var body: some View {
        AsyncContentView(viewState: viewModel.viewState) {
            GeometryReader { reader in
                ScrollView {
                    VStack(spacing: 20) {
                        if let flag = viewModel.flag {
                            AsyncImage(
                                url: .init(string: flag),
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 80, maxHeight: 40)
                                },
                                placeholder: {
                                    EmptyView()
                                }
                            )
                            .padding(.top)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                        Text(viewModel.officalName ?? "")
                            .font(.title3)
                        HStack {
                            Spacer()
                            CircularMapView(
                                region: $viewModel.region,
                                width: reader.size.width
                            )
                            .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }

                        VStack(alignment: .center, spacing: 5) {
                            ForEach(viewModel.metaData, id: \.self) { text in
                                Text(text)
                                    .multilineTextAlignment(.center)
                                Divider()
                                    .frame(maxWidth: 45)
                            }
                        }
                    }
                }
                .padding(.top)
            }
        } onRetry: {
            Task {
                await viewModel.retrieveCountryDetails()
            }
        }
        .navigationTitle(viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.retrieveCountryDetails()
        }        
    }
}

struct CircularMapView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var region: MKCoordinateRegion
    @State var width: CGFloat
    let inset: CGFloat = -15
    
    var dimension: CGFloat {
        let compactDimension = width * 1 + inset
        let regularDimension = width * 0.85 + inset
        guard let horizontalSizeClass else {
            return compactDimension
        }
        
        switch horizontalSizeClass {
        case .regular:
            return regularDimension
        case .compact:
            return compactDimension
        @unknown default:
            return compactDimension
        }
    }
    
    var body: some View {
        Map(coordinateRegion: $region)
            .frame(width: dimension,
                   height: dimension,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .clipShape(.circle)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview(body: {
    CountryDetailView(viewModel: .init(networkService: NetworkService(), country: .init(name: .init(common: "Laos", official: "Laos"), cca2: "LA", flag: "", population: 1, area: 1)))
})

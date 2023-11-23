//
//  SortOptionView.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation
import SwiftUI

enum SortOption {
    case name
    case population
    case area
    
    var sortingClosure: (Country, Country) -> Bool {
        switch self {
        case .name:
            return { $0.name.common < $1.name.common }
        case .population:
            return { $0.population > $1.population }
        case .area:
            return { $0.area > $1.area }
        }
    }
}

struct SortingView: View {
    
    @Binding var sortOption: SortOption
    
    var body: some View {
        HStack {
            Text("Sort by:")
                .font(.system(size: 14))
            Picker("Sort Order", selection: $sortOption) {
                Text("Name").tag(SortOption.name)
                Text("Population").tag(SortOption.population)
                Text("Area").tag(SortOption.area)
            }
            .frame(maxHeight: 25)
        }
    }
}

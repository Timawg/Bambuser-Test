//
//  ColorSchemeProxy.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation
import SwiftUI

final class ColorSchemeProxy: ObservableObject {
        
    @Environment(\.colorScheme) static private var colorScheme
    @AppStorage("stored_interface_style") static private var storedInterfaceStyle: UIUserInterfaceStyle = .unspecified
    @Published var selectedColorScheme: ColorScheme
    
    init() {
        switch ColorSchemeProxy.storedInterfaceStyle {
        case .unspecified:
            self.selectedColorScheme = ColorSchemeProxy.colorScheme
        case .light:
            self.selectedColorScheme = .light
        case .dark:
            self.selectedColorScheme = .dark
        @unknown default:
            self.selectedColorScheme = ColorSchemeProxy.colorScheme
        }
    }
    
    func set(scheme: ColorScheme) {
        ColorSchemeProxy.storedInterfaceStyle = scheme == .dark ? .dark : .light
        selectedColorScheme = scheme
    }
}

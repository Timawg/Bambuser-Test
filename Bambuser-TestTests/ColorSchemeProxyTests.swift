//
//  ColorSchemeProxyTests.swift
//  Bambuser-TestTests
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import XCTest
@testable import Bambuser_Test

final class ColorSchemeProxyTests: XCTestCase {
    
    let colorSchemeProxy = ColorSchemeProxy()

    override func setUpWithError() throws {
        colorSchemeProxy.set(scheme: .light)
    }

    override func tearDownWithError() throws {
        colorSchemeProxy.set(scheme: .light)
    }

    func testProxy() throws {
        XCTAssertEqual(colorSchemeProxy.selectedColorScheme, .light)
        
        colorSchemeProxy.set(scheme: .dark)
        
        XCTAssertEqual(colorSchemeProxy.selectedColorScheme, .dark)
    }
}

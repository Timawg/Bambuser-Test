//
//  AsyncContentView.swift
//  Bambuser-Test
//
//  Created by Tim Gunnarsson on 2023-11-23.
//

import Foundation
import SwiftUI

enum ViewState {
    case loading
    case completed
    case failure(error: Error)
}

struct AsyncContentView<Content: View>: View {
    
    var viewState: ViewState
    let content: () -> Content
    let onRetry: () -> Void
    
    var body: some View {
        switch viewState {
        case .loading:
            ProgressView()
        case .completed:
            AnyView(content())
        case .failure(let error):
            VStack(spacing: 20) {
                Text(error.localizedDescription)
                Button(action: {
                    onRetry()
                }, label: {
                    Text("Retry")
                })
            }
        }
    }
}

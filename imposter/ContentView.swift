//
//  ContentView.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 25/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        Group {
            switch viewModel.gameState {
            case .setup:
                SetupView(viewModel: viewModel)

            case .revealing:
                RevealView(viewModel: viewModel)

            case .discussion:
                DiscussionView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.gameState)
    }
}

#Preview {
    ContentView()
}

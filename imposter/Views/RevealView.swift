//
//  RevealView.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 26/12/25.
//

import SwiftUI

struct RevealView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var isPressed: Bool = false

    var body: some View {
        ZStack {
            // Background - Cor diferente para cada jogador
            LinearGradient(
                colors: viewModel.getCurrentPlayerColors(),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentPlayerIndex)

            VStack(spacing: 40) {
                // Player Info Header
                VStack(spacing: 10) {
                    if let player = viewModel.currentPlayer {
                        Text(player.displayName)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    } else {
                        Text("Jogador \(viewModel.currentPlayerIndex + 1)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Text("de \(viewModel.numberOfPlayers)")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 60)

                Spacer()

                // Main Reveal Card - LONG PRESS APENAS AQUI
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 20)

                    VStack(spacing: 30) {
                        // Icon
                        Image(systemName: viewModel.isWordRevealed ?
                              (viewModel.isCurrentPlayerImpostor ? "exclamationmark.triangle.fill" : "eye.fill") :
                                "eye.slash.fill")
                            .font(.system(size: 60))
                            .foregroundColor(viewModel.isWordRevealed ?
                                           (viewModel.isCurrentPlayerImpostor ? .red : .blue) : .gray)
                            .animation(.spring(response: 0.3), value: viewModel.isWordRevealed)

                        // Word or Impostor Message
                        if viewModel.isWordRevealed {
                            if viewModel.isCurrentPlayerImpostor {
                                VStack(spacing: 15) {
                                    Text("🎭")
                                        .font(.system(size: 70))

                                    Text("Você é o")
                                        .font(.title2)
                                        .foregroundColor(.secondary)

                                    Text("IMPOSTOR!")
                                        .font(.system(size: 40, weight: .black, design: .rounded))
                                        .foregroundColor(.red)

                                    Text("Tente se misturar")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 5)
                                }
                                .transition(.scale.combined(with: .opacity))
                            } else {
                                VStack(spacing: 15) {
                                    Text("Sua palavra é:")
                                        .font(.title2)
                                        .foregroundColor(.secondary)

                                    Text(viewModel.getWordForCurrentPlayer())
                                        .font(.system(size: 48, weight: .black, design: .rounded))
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.center)

                                    Text("Memorize e passe para o próximo")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 5)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        } else {
                            VStack(spacing: 15) {
                                Text("Segure para revelar")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                    .symbolEffect(.bounce, value: isPressed)
                            }
                        }
                    }
                    .padding(40)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .padding(.horizontal, 30)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                // APLICAR LONG PRESS APENAS NO CARD
                .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                    if pressing {
                        isPressed = true
                        viewModel.revealWord()
                    } else {
                        isPressed = false
                        viewModel.hideWord()
                    }
                }, perform: {})

                Spacer()

                // Instructions
                VStack(spacing: 15) {
                    if !viewModel.isWordRevealed {
                        HStack(spacing: 10) {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.white)
                            Text("Pressione e segure o card acima")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                        )
                    } else {
                        HStack(spacing: 10) {
                            Image(systemName: "hand.point.down.fill")
                                .foregroundColor(.white)
                            Text("Solte e clique em 'Próximo Jogador'")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                        )
                    }
                }

                // Next Player Button (only visible when word is hidden)
                if !viewModel.isWordRevealed {
                    Button(action: {
                        viewModel.nextPlayer()
                    }) {
                        HStack {
                            Text("Próximo Jogador")
                                .font(.title3)
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.3))
                        )
                    }
                    .padding(.horizontal, 30)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    RevealView(viewModel: GameViewModel())
}


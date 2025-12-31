//
//  DiscussionView.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 26/12/25.
//

import SwiftUI

struct DiscussionView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: viewModel.discussionTimeRemaining <= 10 ?
                    [Color.red.opacity(0.6), Color.orange.opacity(0.6)] :
                    [Color.purple.opacity(0.6), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: viewModel.discussionTimeRemaining <= 10)

            VStack(spacing: 40) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)

                    Text("DISCUSSÃO")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text("Descubram quem é o impostor!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 60)

                Spacer()

                // Timer Card
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 20)

                    VStack(spacing: 30) {
                        Text("Tempo Restante")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        ZStack {
                            Circle()
                                .stroke(lineWidth: 15)
                                .foregroundColor(Color.gray.opacity(0.2))

                            Circle()
                                .trim(from: 0, to: CGFloat(viewModel.discussionTimeRemaining) / 120.0)
                                .stroke(
                                    viewModel.discussionTimeRemaining <= 10 ? Color.red : Color.blue,
                                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: viewModel.discussionTimeRemaining)

                            VStack(spacing: 5) {
                                Text(viewModel.formattedTime)
                                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                                    .foregroundColor(viewModel.discussionTimeRemaining <= 10 ? .red : .primary)

                                if viewModel.discussionTimeRemaining > 0 {
                                    Text("minutos")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("ACABOU!")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        .frame(width: 250, height: 250)

                        // Status indicators
                        HStack(spacing: 30) {
                            VStack(spacing: 8) {
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Text("\(viewModel.numberOfPlayers)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Jogadores")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Divider()
                                .frame(height: 50)

                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                Text("1")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Impostor")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(40)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 30)

                Spacer()

                // Instructions
                VStack(spacing: 15) {
                    Text("💡 Dicas:")
                        .font(.headline)
                        .foregroundColor(.white)

                    VStack(alignment: .leading, spacing: 8) {
                        instructionRow(icon: "1.circle.fill", text: "Cada jogador dá uma dica sobre a palavra")
                        instructionRow(icon: "2.circle.fill", text: "O impostor tenta adivinhar e se misturar")
                        instructionRow(icon: "3.circle.fill", text: "Votem no suspeito ao final do tempo")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.3))
                    )
                }
                .padding(.horizontal, 30)

                Spacer()

                // Action Buttons
                VStack(spacing: 15) {
                    // Restart Button
                    Button(action: {
                        viewModel.resetGame()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title3)
                            Text("Novo Jogo")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(radius: 8)
                    }

                    // Reveal Button (for end of game)
                    if viewModel.discussionTimeRemaining == 0 {
                        Button(action: {
                            // Could add a reveal screen here
                        }) {
                            HStack {
                                Image(systemName: "eye.fill")
                                    .font(.title3)
                                Text("Ver Resultado")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.3))
                            )
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }

    // Helper function for instruction rows
    private func instructionRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.body)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    DiscussionView(viewModel: GameViewModel())
}


//
//  SetupView.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 26/12/25.
//

import SwiftUI

struct SetupView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 10) {
                            Image(systemName: "person.fill.questionmark")
                                .font(.system(size: 80))
                                .foregroundColor(.white)

                            Text("IMPOSTOR")
                                .font(.system(size: 48, weight: .black, design: .rounded))
                                .foregroundColor(.white)

                            Text("Descubra quem está mentindo")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)

                        // Configuration Card
                    VStack(spacing: 25) {
                        // Number of Players
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Número de Jogadores")
                                .font(.headline)
                                .foregroundColor(.primary)

                            HStack {
                                Button(action: {
                                    if viewModel.numberOfPlayers > 3 {
                                        viewModel.numberOfPlayers -= 1
                                        if viewModel.useCustomNames {
                                            viewModel.updatePlayerNames()
                                        }
                                        viewModel.triggerHaptic(.light)
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(viewModel.numberOfPlayers > 3 ? .blue : .gray)
                                }
                                .disabled(viewModel.numberOfPlayers <= 3)

                                Spacer()

                                Text("\(viewModel.numberOfPlayers)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .frame(width: 100)

                                Spacer()

                                Button(action: {
                                    if viewModel.numberOfPlayers < 12 {
                                        viewModel.numberOfPlayers += 1
                                        if viewModel.useCustomNames {
                                            viewModel.updatePlayerNames()
                                        }
                                        viewModel.triggerHaptic(.light)
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(viewModel.numberOfPlayers < 12 ? .blue : .gray)
                                }
                                .disabled(viewModel.numberOfPlayers >= 12)
                            }

                            Text("Mínimo: 3 | Máximo: 12")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        Divider()

                        // Custom Names Toggle
                        VStack(alignment: .leading, spacing: 15) {
                            Toggle(isOn: $viewModel.useCustomNames) {
                                HStack(spacing: 10) {
                                    Image(systemName: "person.text.rectangle.fill")
                                        .font(.title3)
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Nomes Personalizados")
                                            .font(.headline)
                                        Text("Adicione nomes aos jogadores")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .onChange(of: viewModel.useCustomNames) { newValue in
                                if newValue {
                                    viewModel.updatePlayerNames()
                                }
                                viewModel.triggerHaptic(.light)
                            }

                            if viewModel.useCustomNames {
                                VStack(spacing: 12) {
                                    Text("Digite os nomes abaixo:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    ScrollView {
                                        VStack(spacing: 12) {
                                            ForEach(0..<viewModel.numberOfPlayers, id: \.self) { index in
                                                HStack(spacing: 12) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(playerColor(for: index).opacity(0.2))
                                                            .frame(width: 40, height: 40)
                                                        Text("\(index + 1)")
                                                            .font(.headline)
                                                            .foregroundColor(playerColor(for: index))
                                                    }

                                                    TextField("Ex: João", text: Binding(
                                                        get: {
                                                            if viewModel.playerNames.indices.contains(index) {
                                                                return viewModel.playerNames[index]
                                                            }
                                                            return ""
                                                        },
                                                        set: { newValue in
                                                            viewModel.updatePlayerNames()
                                                            if viewModel.playerNames.indices.contains(index) {
                                                                viewModel.playerNames[index] = newValue
                                                            }
                                                        }
                                                    ))
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .autocorrectionDisabled()
                                                }
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                    .frame(maxHeight: 250)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.05))
                                    )
                                }
                                .padding(.top, 8)
                            }
                        }

                        Divider()

                        // Category Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categoria")
                                .font(.headline)
                                .foregroundColor(.primary)

                            VStack(spacing: 12) {
                                ForEach(Category.allCases) { category in
                                    Button(action: {
                                        viewModel.selectedCategory = category
                                        viewModel.triggerHaptic(.light)
                                    }) {
                                        HStack {
                                            Image(systemName: iconForCategory(category))
                                                .font(.title2)

                                            Text(category.rawValue)
                                                .font(.body)
                                                .fontWeight(.medium)

                                            Spacer()

                                            if viewModel.selectedCategory == category {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.title3)
                                            }
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(viewModel.selectedCategory == category ?
                                                      Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(viewModel.selectedCategory == category ?
                                                       Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(25)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 10)
                    )
                    .padding(.horizontal)

                    // Start Button
                    Button(action: {
                        viewModel.startGame()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.title2)
                            Text("Iniciar Jogo")
                                .font(.title2)
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
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .padding(.vertical)
            }
        }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Helper function for category icons
    private func iconForCategory(_ category: Category) -> String {
        switch category {
        case .comida:
            return "fork.knife"
        case .lugares:
            return "map.fill"
        case .profissoes:
            return "briefcase.fill"
        }
    }

    // Helper function for player colors
    private func playerColor(for index: Int) -> Color {
        let colors: [Color] = [
            .blue, .green, .orange, .purple, .pink, .red,
            .yellow, .cyan, .indigo, .mint, .teal, .brown
        ]
        return colors[index % colors.count]
    }
}

#Preview {
    SetupView(viewModel: GameViewModel())
}


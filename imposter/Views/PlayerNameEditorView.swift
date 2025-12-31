//
//  PlayerNameEditorView.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 31/12/25.
//

import SwiftUI

struct PlayerNameEditorView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss // Permite fechar a tela

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                List {
                    Section {
                        Text("Defina o nome de cada jogador para facilitar a identificação durante as rodadas.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .listRowBackground(Color.clear)
                    }
                    
                    Section(header: Text("Jogadores")) {
                        ForEach(0..<viewModel.numberOfPlayers, id: \.self) { index in
                            HStack(spacing: 15) {
                                // Círculo com o número do jogador
                                ZStack {
                                    Circle()
                                        .fill(playerColor(for: index).opacity(0.2))
                                        .frame(width: 32, height: 32)
                                    Text("\(index + 1)")
                                        .font(.caption).bold()
                                        .foregroundColor(playerColor(for: index))
                                }
                                
                                TextField("Nome do Jogador \(index + 1)", text: Binding(
                                    get: {
                                        // Garante que o índice existe no array antes de ler
                                        if viewModel.playerNames.indices.contains(index) {
                                            return viewModel.playerNames[index]
                                        }
                                        return ""
                                    },
                                    set: { newValue in
                                        // Garante que o array tenha o tamanho correto antes de salvar
                                        viewModel.updatePlayerNames()
                                        if viewModel.playerNames.indices.contains(index) {
                                            viewModel.playerNames[index] = newValue
                                        }
                                    }
                                ))
                                .autocorrectionDisabled()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nomes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Pronto") {
                        viewModel.triggerHaptic(.medium)
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    // Helper para as cores (mesma lógica da View principal)
    private func playerColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .yellow, .cyan, .indigo, .mint, .teal, .brown]
        return colors[index % colors.count]
    }
}

#Preview {
    PlayerNameEditorView(viewModel: GameViewModel())
}

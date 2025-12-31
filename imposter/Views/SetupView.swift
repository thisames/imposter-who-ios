import SwiftUI

struct SetupView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingNameEditor = false // Controle para o modal de nomes

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 15) {
                    // Header mais compacto
                    VStack(spacing: 5) {
                        Image(systemName: "person.fill.questionmark")
                            .font(.system(size: 50)) // Reduzido de 80
                            .foregroundColor(.white)

                        Text("IMPOSTOR")
                            .font(.system(size: 32, weight: .black, design: .rounded)) // Reduzido de 48
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)

                    // Configuration Card
                    VStack(spacing: 15) { // Espaçamento interno reduzido
                        
                        // Jogadores
                        VStack(spacing: 8) {
                            Text("Jogadores: \(viewModel.numberOfPlayers)")
                                .font(.headline)
                            
                            HStack {
                                stepperButton(systemName: "minus.circle.fill", enabled: viewModel.numberOfPlayers > 3) {
                                    viewModel.numberOfPlayers -= 1
                                    viewModel.triggerHaptic(.light)
                                }
                                
                                Slider(value: Binding(
                                    get: { Double(viewModel.numberOfPlayers) },
                                    set: { viewModel.numberOfPlayers = Int($0) }
                                ), in: 3...12, step: 1)
                                .accentColor(.blue)
                                
                                stepperButton(systemName: "plus.circle.fill", enabled: viewModel.numberOfPlayers < 12) {
                                    viewModel.numberOfPlayers += 1
                                    viewModel.triggerHaptic(.light)
                                }
                            }
                        }

                        Divider()

                        // Impostores
                        VStack(spacing: 8) {
                            Text("Impostores: \(viewModel.numberOfImpostors)")
                                .font(.headline)

                            HStack {
                                stepperButton(systemName: "minus.circle.fill", enabled: viewModel.numberOfImpostors > 1) {
                                    viewModel.numberOfImpostors -= 1
                                    viewModel.triggerHaptic(.light)
                                }

                                Slider(value: Binding(
                                    get: { Double(viewModel.numberOfImpostors) },
                                    set: { viewModel.numberOfImpostors = Int($0) }
                                ), in: 1...Double(viewModel.maxImpostors), step: 1)
                                .accentColor(.red)
                                .onChange(of: viewModel.numberOfPlayers) { _ in
                                    // Ajustar número de impostores se exceder o máximo
                                    if viewModel.numberOfImpostors > viewModel.maxImpostors {
                                        viewModel.numberOfImpostors = viewModel.maxImpostors
                                    }
                                }

                                stepperButton(systemName: "plus.circle.fill", enabled: viewModel.numberOfImpostors < viewModel.maxImpostors) {
                                    viewModel.numberOfImpostors += 1
                                    viewModel.triggerHaptic(.light)
                                }
                            }
                        }

                        Divider()

                        // Nomes Personalizados - Agora um simples botão se ativo
                        HStack {
                            Toggle("Nomes Personalizados", isOn: $viewModel.useCustomNames)
                                .font(.subheadline).bold()
                            
                            if viewModel.useCustomNames {
                                Button("Editar") {
                                    showingNameEditor = true
                                }
                                .font(.caption)
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
                            }
                        }

                        Divider()

                        // Categoria - Layout Grid para economizar espaço
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Categoria").font(.headline)
                            HStack(spacing: 10) {
                                ForEach(Category.allCases) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: viewModel.selectedCategory == category,
                                        icon: iconForCategory(category)
                                    ) {
                                        viewModel.selectedCategory = category
                                        viewModel.triggerHaptic(.light)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemBackground)))
                    .padding(.horizontal)

                    Spacer() // Garante que o botão fique embaixo

                    // Start Button
                    Button(action: { viewModel.startGame() }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Iniciar Jogo")
                        }
                        .font(.title3).bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $showingNameEditor) {
                PlayerNameEditorView(viewModel: viewModel)
            }
        }
    }

    // Botão de Categoria Compacto
    @ViewBuilder
    private func CategoryButton(category: Category, isSelected: Bool, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                Text(category.rawValue).font(.caption2).bold()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func stepperButton(systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(enabled ? .blue : .gray)
        }
        .disabled(!enabled)
    }

    private func iconForCategory(_ category: Category) -> String {
        switch category {
        case .comida: return "fork.knife"
        case .lugares: return "map.fill"
        case .profissoes: return "briefcase.fill"
        }
    }
}

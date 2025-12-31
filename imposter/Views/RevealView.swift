import SwiftUI

struct RevealView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var isPressed: Bool = false
    @State private var hasFinishedRevealing: Bool = false // Trava de segurança

    var body: some View {
        ZStack {
            // Background que muda com o jogador
            LinearGradient(
                colors: viewModel.getCurrentPlayerColors(),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 15) {
                
                // --- HEADER COMPACTO ---
                VStack(spacing: 4) {
                    Text(viewModel.currentPlayer?.displayName ?? "Jogador \(viewModel.currentPlayerIndex + 1)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("\(viewModel.currentPlayerIndex + 1) de \(viewModel.numberOfPlayers)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 20)

                Spacer(minLength: 10)

                // --- CARD PRINCIPAL ---
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 15)

                    VStack(spacing: 20) {
                        if hasFinishedRevealing {
                            // ESTADO 3: Já viu e foi bloqueado
                            VStack(spacing: 15) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.green)
                                
                                Text("Papel Memorizado!")
                                    .font(.title2).bold()
                                
                                Text("Passe o dispositivo para o próximo jogador.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .transition(.scale)
                            
                        } else if viewModel.isWordRevealed {
                            // ESTADO 2: Revelando (Segurando)
                            revealContent
                                .transition(.opacity)
                        } else {
                            // ESTADO 1: Instrução inicial
                            VStack(spacing: 15) {
                                Text("Segure para revelar")
                                    .font(.headline)
                                
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                    .symbolEffect(.bounce, value: isPressed)
                                
                                Text("Atenção: Você só pode ver uma vez!")
                                    .font(.caption2)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(25)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 320) // Altura reduzida para caber em telas menores
                .padding(.horizontal, 30)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(), value: isPressed)
                // GESTO COM TRAVA
                .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                    if !hasFinishedRevealing { // Só permite se não tiver terminado
                        isPressed = pressing
                        if pressing {
                            viewModel.revealWord()
                            viewModel.triggerHaptic(.medium)
                        } else {
                            viewModel.hideWord()
                            hasFinishedRevealing = true // ATIVA A TRAVA AO SOLTAR
                            viewModel.triggerHaptic(.heavy)
                        }
                    }
                }, perform: {})

                Spacer(minLength: 10)

                // --- BOTÃO PRÓXIMO ---
                // Só aparece após a trava ser ativada
                if hasFinishedRevealing {
                    Button(action: {
                        hasFinishedRevealing = false // Reseta a trava para o próximo
                        viewModel.nextPlayer()
                    }) {
                        HStack {
                            Text("Próximo Jogador")
                            Image(systemName: "chevron.right.circle.fill")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 20)
            }
        }
        .animation(.default, value: hasFinishedRevealing)
    }

    // Conteúdo da revelação (Impostor ou Palavra)
    @ViewBuilder
    private var revealContent: some View {
        if viewModel.isCurrentPlayerImpostor {
            VStack(spacing: 10) {
                Text("🎭").font(.system(size: 50))
                Text("Você é o").font(.headline).foregroundColor(.secondary)
                Text("IMPOSTOR")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(.red)
            }
        } else {
            VStack(spacing: 10) {
                Text("Sua palavra é:").font(.headline).foregroundColor(.secondary)
                Text(viewModel.getWordForCurrentPlayer())
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

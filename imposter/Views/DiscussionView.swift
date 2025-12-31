import SwiftUI

struct DiscussionView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            // Background Dinâmico
            LinearGradient(
                colors: viewModel.discussionTimeRemaining <= 10 ?
                [Color.red.opacity(0.7), Color.orange.opacity(0.7)] :
                [Color.purple.opacity(0.7), Color.blue.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 10) { // Spacing reduzido entre blocos

                // --- HEADER COMPACTO ---
                VStack(spacing: 4) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 30)) // Reduzido de 60
                    .foregroundColor(.white)

                    Text("DISCUSSÃO")
                    .font(.system(size: 24, weight: .black, design: .rounded)) // Reduzido de 36
                    .foregroundColor(.white)
                }
                .padding(.top, 10)

                Spacer(minLength: 0)

                // --- TIMER CARD ---
                VStack(spacing: 15) {
                    Text("Tempo Restante")
                    .font(.subheadline).bold()
                    .foregroundColor(.secondary)

                    // Círculo do Cronômetro
                    ZStack {
                        Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color.gray.opacity(0.1))

                        Circle()
                        .trim(from: 0, to: CGFloat(viewModel.discussionTimeRemaining) / 120.0)
                        .stroke(
                            viewModel.discussionTimeRemaining <= 10 ? Color.red : Color.blue,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: viewModel.discussionTimeRemaining)

                        VStack(spacing: 0) {
                            Text(viewModel.formattedTime)
                            .font(.system(size: 45, weight: .bold, design: .monospaced))
                            .foregroundColor(viewModel.discussionTimeRemaining <= 10 ? .red : .primary)

                            Text(viewModel.discussionTimeRemaining > 0 ? "restantes" : "FIM!")
                            .font(.caption2).bold()
                            .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 170, height: 170) // Reduzido drasticamente para caber

                    // Status
                    HStack(spacing: 40) {
                        statusItem(icon: "person.fill", color: .blue, value: "\(viewModel.numberOfPlayers)", label: "Jogadores")
                        statusItem(icon: "exclamationmark.triangle.fill", color: .red, value: "1", label: "Impostor")
                    }
                }
                .padding(20) // Padding interno menor
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(.systemBackground)))
                .shadow(color: .black.opacity(0.1), radius: 10)
                .padding(.horizontal, 25)

                Spacer(minLength: 0)

                // --- DICAS (Versão super compacta) ---
                VStack(alignment: .leading, spacing: 6) {
                    instructionRow(icon: "1.circle.fill", text: "Cada um dá uma dica sobre a palavra.")
                    instructionRow(icon: "2.circle.fill", text: "O impostor tenta se misturar.")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal, 30)

                Spacer(minLength: 0)

                // --- BOTÕES DE AÇÃO ---
                VStack(spacing: 12) {
                    if viewModel.discussionTimeRemaining == 0 {
                        Button(action: { /* Ação de resultado */ }) {
                            Text("Ver Resultado")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(14)
                        }
                    }

                    Button(action: { viewModel.resetGame() }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Novo Jogo")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.discussionTimeRemaining == 0 ? Color.white.opacity(0.2) : Color.blue)
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 15)
            }
        }
    }

    // Componente de Status
    private func statusItem(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon).foregroundColor(color).font(.caption)
            Text(value).font(.title3).bold()
            Text(label).font(.system(size: 10)).foregroundColor(.secondary)
        }
    }

    private func instructionRow(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).foregroundColor(.white).font(.caption)
            Text(text).font(.caption).foregroundColor(.white.opacity(0.9))
        }
    }
}
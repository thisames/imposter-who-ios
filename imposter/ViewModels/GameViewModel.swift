//
//  GameViewModel.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 26/12/25.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var gameState: GameState = .setup
    @Published var numberOfPlayers: Int = 5
    @Published var selectedCategory: Category = .comida
    @Published var players: [Player] = []
    @Published var currentPlayerIndex: Int = 0
    @Published var isWordRevealed: Bool = false
    @Published var discussionTimeRemaining: Int = 120 // 2 minutos
    @Published var useCustomNames: Bool = false
    @Published var playerNames: [String] = []

    // MARK: - Private Properties
    private var impostorIndex: Int = 0
    private var secretWord: String = ""
    private var timer: Timer?

    // MARK: - Computed Properties
    var currentPlayer: Player? {
        guard currentPlayerIndex < players.count else { return nil }
        return players[currentPlayerIndex]
    }

    var isCurrentPlayerImpostor: Bool {
        return currentPlayerIndex == impostorIndex
    }

    var formattedTime: String {
        let minutes = discussionTimeRemaining / 60
        let seconds = discussionTimeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Game Setup
    func startGame() {
        // Resetar estado
        players = (1...numberOfPlayers).map { index in
            let customName = useCustomNames && index <= playerNames.count ? playerNames[index - 1] : nil
            return Player(number: index, customName: customName)
        }
        currentPlayerIndex = 0
        isWordRevealed = false

        // Sortear impostor e palavra
        impostorIndex = Int.random(in: 0..<numberOfPlayers)
        secretWord = selectedCategory.words.randomElement() ?? ""

        // Mudar para estado de revelação
        gameState = .revealing(playerIndex: 0)

        // Haptic feedback
        triggerHaptic(.medium)
    }

    // MARK: - Player Names Management
    func updatePlayerNames() {
        // Ajustar o array de nomes para o número de jogadores
        if playerNames.count < numberOfPlayers {
            playerNames.append(contentsOf: Array(repeating: "", count: numberOfPlayers - playerNames.count))
        } else if playerNames.count > numberOfPlayers {
            playerNames = Array(playerNames.prefix(numberOfPlayers))
        }
    }

    // MARK: - Word Revelation
    func revealWord() {
        isWordRevealed = true
        triggerHaptic(.light)
    }

    func hideWord() {
        isWordRevealed = false
        triggerHaptic(.light)
    }

    func nextPlayer() {
        // Marcar jogador atual como tendo visto a palavra
        if currentPlayerIndex < players.count {
            players[currentPlayerIndex].hasSeenWord = true
        }

        currentPlayerIndex += 1

        // Verificar se todos os jogadores já viram
        if currentPlayerIndex >= numberOfPlayers {
            startDiscussion()
        } else {
            gameState = .revealing(playerIndex: currentPlayerIndex)
            triggerHaptic(.medium)
        }
    }

    // MARK: - Discussion Phase
    func startDiscussion() {
        gameState = .discussion
        discussionTimeRemaining = 120
        startTimer()
        triggerHaptic(.heavy)
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.discussionTimeRemaining > 0 {
                self.discussionTimeRemaining -= 1

                // Haptic nos últimos 5 segundos
                if self.discussionTimeRemaining <= 5 && self.discussionTimeRemaining > 0 {
                    self.triggerHaptic(.medium)
                }

                // Haptic no final
                if self.discussionTimeRemaining == 0 {
                    self.triggerHaptic(.heavy)
                }
            } else {
                self.stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Game Reset
    func resetGame() {
        stopTimer()
        gameState = .setup
        players = []
        currentPlayerIndex = 0
        isWordRevealed = false
        discussionTimeRemaining = 120
        triggerHaptic(.medium)
    }

    // MARK: - Haptic Feedback
    func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    // MARK: - Reveal Info (for testing/debugging)
    func getWordForCurrentPlayer() -> String {
        return isCurrentPlayerImpostor ? "" : secretWord
    }

    // MARK: - Player Colors
    func getPlayerColor(for index: Int) -> [Color] {
        let colorSchemes: [[Color]] = [
            [Color.blue.opacity(0.7), Color.cyan.opacity(0.7)],
            [Color.green.opacity(0.7), Color.mint.opacity(0.7)],
            [Color.orange.opacity(0.7), Color.yellow.opacity(0.7)],
            [Color.purple.opacity(0.7), Color.pink.opacity(0.7)],
            [Color.red.opacity(0.7), Color.orange.opacity(0.7)],
            [Color.indigo.opacity(0.7), Color.purple.opacity(0.7)],
            [Color.teal.opacity(0.7), Color.blue.opacity(0.7)],
            [Color.pink.opacity(0.7), Color.red.opacity(0.7)],
            [Color.mint.opacity(0.7), Color.green.opacity(0.7)],
            [Color.cyan.opacity(0.7), Color.teal.opacity(0.7)],
            [Color.yellow.opacity(0.7), Color.orange.opacity(0.7)],
            [Color.brown.opacity(0.7), Color.orange.opacity(0.7)]
        ]
        return colorSchemes[index % colorSchemes.count]
    }

    func getCurrentPlayerColors() -> [Color] {
        return isCurrentPlayerImpostor ?
            [Color.red.opacity(0.6), Color.orange.opacity(0.6)] :
            getPlayerColor(for: currentPlayerIndex)
    }

    // MARK: - Cleanup
    deinit {
        stopTimer()
    }
}


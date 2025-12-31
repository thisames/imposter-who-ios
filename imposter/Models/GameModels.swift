//
//  GameModels.swift
//  imposter
//
//  Created by Thiago  dos Santos Gomes on 26/12/25.
//

import Foundation

// MARK: - Game Models

enum Category: String, CaseIterable, Identifiable {
    case comida = "Comida"
    case lugares = "Lugares"
    case profissoes = "Profissões"

    var id: String { self.rawValue }

    var words: [String] {
        switch self {
        case .comida:
            return ["Pizza", "Sushi", "Hambúrguer", "Sorvete", "Lasanha",
                   "Tacos", "Churrasco", "Feijoada", "Macarrão", "Chocolate"]
        case .lugares:
            return ["Praia", "Cinema", "Parque", "Shopping", "Hospital",
                   "Escola", "Restaurante", "Academia", "Biblioteca", "Aeroporto"]
        case .profissoes:
            return ["Médico", "Professor", "Engenheiro", "Chef", "Piloto",
                   "Advogado", "Artista", "Bombeiro", "Jornalista", "Cientista"]
        }
    }
}

enum GameState: Equatable {
    case setup
    case revealing(playerIndex: Int)
    case discussion
}

struct Player: Identifiable {
    let id = UUID()
    let number: Int
    var customName: String?
    var hasSeenWord: Bool = false

    var displayName: String {
        return customName?.isEmpty == false ? customName! : "Jogador \(number)"
    }
}


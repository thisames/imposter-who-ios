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
            return [
                "Pizza", "Sushi", "Hambúrguer", "Sorvete", "Lasanha",
                "Tacos", "Churrasco", "Feijoada", "Macarrão", "Chocolate",
                "Arroz", "Feijão", "Picanha", "Coxinha", "Pastel",
                "Brigadeiro", "Açaí", "Cerveja", "Vinho", "Salada",
                "Frango", "Bife", "Ovo", "Leite", "Café",
                "Pão", "Queijo", "Manteiga", "Geleia", "Mel",
                "Bolo", "Pudim", "Torta", "Empada", "Quibe",
                "Esfirra", "Bobó", "Moqueca", "Vatapá", "Acarajé",
                "Pão de Queijo", "Mandioca", "Batata Frita", "Pipoca", "Algodão Doce",
                "Hot Dog", "Cachorro Quente", "Milho", "Abacaxi", "Banana",
                "Maçã", "Laranja", "Uva", "Morango", "Melancia",
                "Manga", "Kiwi", "Pêssego", "Ameixa", "Cereja"
            ]
        case .lugares:
            return [
                "Praia", "Cinema", "Parque", "Shopping", "Hospital",
                "Escola", "Restaurante", "Academia", "Biblioteca", "Aeroporto",
                "Museu", "Teatro", "Igreja", "Estádio", "Zoológico",
                "Circo", "Fazenda", "Sítio", "Cidade", "Vila",
                "Bairro", "Rua", "Avenida", "Prédio", "Apartamento",
                "Casa", "Escritório", "Fábrica", "Loja", "Mercado",
                "Supermercado", "Farmácia", "Banco", "Correios", "Piscina",
                "Cachoeira", "Montanha", "Floresta", "Deserto", "Ilha",
                "Rio", "Lago", "Oceano", "Vulcão", "Caverna",
                "Castelo", "Palácio", "Ponte", "Túnel", "Farol",
                "Porto", "Estação", "Praça", "Jardim", "Feira"
            ]
        case .profissoes:
            return [
                "Médico", "Professor", "Engenheiro", "Chef", "Piloto",
                "Advogado", "Artista", "Bombeiro", "Jornalista", "Cientista",
                "Enfermeiro", "Dentista", "Farmacêutico", "Veterinário", "Policial",
                "Militar", "Mecânico", "Eletricista", "Pedreiro", "Pintor",
                "Arquiteto", "Designer", "Programador", "Desenvolvedor", "Ator",
                "Cantor", "Dançarino", "Músico", "DJ", "Barman",
                "Garçom", "Taxista", "Motorista", "Agricultor", "Pescador",
                "Minerador", "Lençador", "Costureiro", "Alfaiate", "Ferreiro",
                "Marceneiro", "Soldador", "Encanador", "Jardineiro", "Faxineiro",
                "Contador", "Economista", "Banqueiro", "Investidor", "Empreendedor",
                "Vendedor", "Gerente", "Diretor", "Presidente", "Recepcionista"
            ]
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

//
//  CardGeneratorService.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import Foundation

protocol CardGeneratorProtocol {
    func generateCard(with url: String, and cardType: CardType) async throws -> CardResponse
}

class CardGenerator: CardGeneratorProtocol {
    static let shared: CardGeneratorProtocol = CardGenerator()
    
    func generateCard(with url: String, and cardType: CardType = .VISA) async throws -> CardResponse {
        return try await URLSession.shared.fetch(url: "\(url)\(cardType.rawValue)")
    }
    
}

struct CardResponse: Codable {
    let type: String
    let date: String
    let cardNumber: String
    let cvv: String
    let pin: Int
}


enum CardType: String {
    case VISA, MASTERCARD
}


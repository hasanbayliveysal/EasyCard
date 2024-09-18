//
//  CardGeneratorService.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import Foundation
import FirebaseFirestore

protocol CardGeneratorProtocol {
    func generateCard(with url: String, and cardType: CardType) async throws
    func uploadCard(with cardData: Card) async throws
    func fetchCardByID(with cardID: String) async throws -> Card
    func fetchAllCards() async throws -> [Card]
    func deleteCard() async throws
}

class CardGenerator: CardGeneratorProtocol {
    static let shared: CardGeneratorProtocol = CardGenerator()
    private let db = Firestore.firestore()
    
    func generateCard(with url: String, and cardType: CardType = .VISA) async throws  {
        
        let cardResponse: CardResponse = try await URLSession.shared.fetch(url: "\(url)\(cardType.rawValue)")
        let cardData = Card(id: UUID().uuidString, type: cardResponse.type, ownerID: getCurrentUserID(), cardNumber: cardResponse.cardNumber, cvv: cardResponse.cvv, balance: 10.0, date: cardResponse.date)
        try await uploadCard(with: cardData)
        
    }
    
    func uploadCard(with cardData: Card) async throws {
        let userID = getCurrentUserID()
        do {
            try await db.collection("cards")
                .document(cardData.id)
                .setData(["id": cardData.id,
                          "type": cardData.type,
                          "ownerID": userID,
                          "cardNumber": cardData.cardNumber,
                          "cvv": cardData.cvv,
                          "balance": cardData.balance,
                          "date": cardData.date])
        } catch {
            print("Error writing document: \(error)")
        }
        
        try await UserService.shared.updateUserData(with: userID, and: cardData.id)
    }
    
    func deleteCard() async throws {
        let userID = getCurrentUserID()
        let querySnapshot = try await db.collection("cards")
            .whereField("ownerID", isEqualTo: userID)
            .getDocuments()
        
        for document in querySnapshot.documents {
            try await db.collection("cards").document(document.documentID).delete()
            print("Card with ID \(document.documentID) deleted successfully.")
        }
        
        try await UserService.shared.removeCardIDFromUser(userID: userID)
    }
    
    func fetchCardByID(with cardID: String) async throws -> Card {
        let snapshot = try await db.collection("cards").document(cardID).getDocument()
        let data = snapshot.data()
        guard let id = data?["id"] as? String,
              let type = data?["type"] as? String,
              let ownerID = data?["ownerID"] as? String,
              let cardNumber = data?["cardNumber"] as? String,
              let cvv = data?["cvv"] as? String,
              let balance = data?["balance"] as? Double,
              let date = data?["date"] as? String
        else {
            throw NSError(domain: "Parsing error", code: -1)
        }
        return Card(id: id, type: type, ownerID: ownerID, cardNumber: cardNumber, cvv: cvv, balance: balance, date: date)
    }
    
    func fetchAllCards() async throws -> [Card] {
        let snapshot = try await db.collection("cards").getDocuments()
        let allCards: [Card] = snapshot.documents.compactMap { document in
            let data = document.data()
            guard let id = data["id"] as? String,
                  let type = data["type"] as? String,
                  let ownerID = data["ownerID"] as? String,
                  let cardNumber = data["cardNumber"] as? String,
                  let cvv = data["cvv"] as? String,
                  let balance = data["balance"] as? Double,
                  let date = data["date"] as? String else {
                return nil
            }
            return Card(id: id, type: type, ownerID: ownerID, cardNumber: cardNumber, cvv: cvv, balance: balance, date: date)
        }
        
        return allCards.filter { $0.ownerID != getCurrentUserID() }
    }
    
    func getCurrentUserID() -> String {
        return UserService.shared.getCurrentUserID()
    }
}

struct CardResponse: Codable {
    let type: String
    let date: String
    let cardNumber: String
    let cvv: String
    let pin: Int
}


struct Card: Decodable {
    
    let id: String
    let type: String
    let ownerID: String
    let cardNumber: String
    let cvv: String
    let balance: Double
    let date: String
    
}


enum CardType: String {
    case VISA, MASTERCARD
}


//
//  TransactionService.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import Foundation
import FirebaseFirestore

protocol TransactionServiceProtcol {
    func sendBalance(with card: Card, and amount: Double) async throws
}

final class TransactionService: TransactionServiceProtcol {
    static let shared: TransactionServiceProtcol = TransactionService()
    let db = Firestore.firestore()
    
    func sendBalance(with card: Card, and amount: Double) async throws {
        let user = try await UserService.shared.getUserData(with:  getCurrentUserID())
        guard let cardID = user.cardID else {
            return
        }
        let currentUserCard = try await CardGenerator.shared.fetchCardByID(with: cardID)
        let currentUserCardReference = db.collection("cards").document(currentUserCard.id)
        let recipientUserCardReference = db.collection("cards").document(card.id)
        let currentUserBalance = currentUserCard.balance
        let recipientUserBalance = card.balance
        
        
        do {
            try await currentUserCardReference.updateData([
                "balance" :  currentUserBalance - amount ])
            try await recipientUserCardReference.updateData([
                "balance" :  recipientUserBalance + amount ])
        } catch {
            
            
            throw error
        }
        
    }
    
    func getCurrentUserID() -> String {
        return UserService.shared.getCurrentUserID()
    }
}

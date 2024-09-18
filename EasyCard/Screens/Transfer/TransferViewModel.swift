//
//  TransferViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class TransferViewModel {
    
    func getCurrentUser() async throws -> User {
        return try await UserService.shared.getUserData(with: UserService.shared.getCurrentUserID())
    }
    
    func getCurrentUserCard() async throws -> Card {
        let user = try await getCurrentUser()
        return try await CardGenerator.shared.fetchCardByID(with: user.cardID ?? "")
    }
    
    func sendMoney(to recipientCard: Card, amount: Double) async throws {
        
        try await TransactionService.shared.sendBalance(with: recipientCard, and: amount)
        
    }

}

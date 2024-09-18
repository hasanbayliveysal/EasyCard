//
//  HomeViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

class HomeViewModel {
    
    func getCurrentUserID() -> String {
        return UserService.shared.getCurrentUserID()
    }
    
    func fetchUser() async throws -> User {
        return try await UserService.shared.getUserData(with: getCurrentUserID())
    }
    
    func generateCard(with type: CardType) async throws {
        let url = "https://randommer.io/api/Card?type="
        
        try await CardGenerator.shared.generateCard(with: url, and: type)
        
    }
    
    func deleteCard() async throws {
        
        try await CardGenerator.shared.deleteCard()
        
    }
    
    func fetchUserCard(with cardID: String) async throws -> Card {
        return try await CardGenerator.shared.fetchCardByID(with: cardID)
    }
    
    func setUserLoggedOut() {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    }
    
    
}


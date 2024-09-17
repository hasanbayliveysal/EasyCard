//
//  HomeViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

class HomeViewModel {
    
    func generateCard(with type: CardType) async throws  ->  CardResponse {
        let url = "https://randommer.io/api/Card?type="
        return try await CardGenerator.shared.generateCard(with: url, and: type)
    }
    
    func setUserLoggedOut() {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    }
    
}

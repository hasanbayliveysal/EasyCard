//
//  HomeViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

final class HomeViewModel {
    var reloadData: emptyClosure?
    var selectedCardType: ((CardType) -> (Void))?
    var cancelButtonClicked: emptyClosure?
    
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
    
    func showAlertForDeleteCard() -> UIAlertController {
        let alert = UIAlertController(title: "deletecard".localized(), message: "doyouwanttodelete".localized(), preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) {  _ in
             Task {
                 do {
                     try await self.deleteCard()
                     self.reloadData?()
                 }
             }
        }
        let cancelButton = UIAlertAction(title: "cancel".localized(), style: .destructive) {  [self] _ in
            cancelButtonClicked?()
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        return alert
    }
    
    func showAlertForSelection() -> UIAlertController {
        let alert = UIAlertController(title: "selectcardtype".localized(), message: "selectcardtypeyouwant".localized(), preferredStyle: .alert)
        let visaButton = UIAlertAction(title: "VISA", style: .default) { [self] _ in
            selectedCardType?(.VISA)
        }
        
        let mastedcardButton = UIAlertAction(title: "MASTERCARD", style: .default) {  [self] _ in
            selectedCardType?(.MASTERCARD)
        }
        let cancelButton = UIAlertAction(title: "cancel".localized(), style: .destructive) {  [self] _ in
            cancelButtonClicked?()
        }
        
        alert.addAction(visaButton)
        alert.addAction(mastedcardButton)
        alert.addAction(cancelButton)
        return alert
    }
    
}


//
//  RegisterViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

class RegisterViewModel {
    func saveUserData(_ user: User) async throws {
        try await UserService.shared.saveUserData(with: user)
        saveCurrentUserID(user.id)
        saveUserLoggedIn()
        saveApiKey()
        getUserbyID()
    }
    
    func saveCurrentUserID(_ id: String) {
        UserDefaults.standard.set(id, forKey: "currentUserID")
    }
    
    func saveUserLoggedIn() {
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        
        print("it is setted")
    }
    
    func getUserbyID() {
        guard let id = UserDefaults.standard.string(forKey: "currentUserID") else {
            return
        }
        Task {
            do {
                let user = try await UserService.shared.getUserData(with: id)
                print(user)
            }
        }
    }
    
    
    func saveApiKey() {
        if let apiKeyData = "01c50e8993b24fa5871d57fbdce233e2".data(using: .utf8) {
            let status = KeychainHelper.save(key: "apiKey", data: apiKeyData)
            if status == errSecSuccess {
                print("API Key saved successfully!")
            } else {
                print("Failed to save API Key: \(status)")
            }
        }
    }
    
    func loadApiKey() {
        
    }
}


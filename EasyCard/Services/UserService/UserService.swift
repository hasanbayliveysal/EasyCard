//
//  UserService.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func saveUserData(with userData: User) async throws
    func getUserData(with id: String) async throws -> User
    func updateUserData(with userID: String, and cardID: String) async throws
    func removeCardIDFromUser(userID: String) async throws 
    func getCurrentUserID() -> String
}

class UserService: UserServiceProtocol {
    
    static let shared: UserServiceProtocol = UserService()
    private let db = Firestore.firestore()
    func saveUserData(with userData: User) async throws {
        do {
            try await db.collection("users")
                .document("\(userData.id)")
                .setData(["name": userData.name,
                          "number": userData.number,
                          "birthDate": userData.birthDate,
                          "id": userData.id])
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func getUserData(with id: String) async throws -> User {
        let snapshot = try await db.collection("users").document(id).getDocument()
        let data = snapshot.data()
        guard let id = data?["id"] as? String,
              let name = data?["name"] as? String,
              let number = data?["number"] as? String,
              let birthDate = data?["birthDate"] as? String
              else {
           throw NSError(domain: "Parsing error", code: -1)
        }
        return User(id: id, name: name, number: number, birthDate: birthDate, cardID: (data?["cardID"] as? String))
    }
    
    func updateUserData(with userID: String, and cardID: String) async throws {
        let userRef = db.collection("users").document(userID)
        do {
            try await userRef.updateData([
                "cardID" : cardID ])
        } catch {
            throw error
        }
    }
    
    
    func removeCardIDFromUser(userID: String) async throws {
        
        let userRef = db.collection("users").document(userID)
        do {
            try await userRef.updateData([
                "cardID": FieldValue.delete()
            ])
        } catch {
            throw error
        }
    }
    
    func getCurrentUserID() -> String {
        guard let id = UserDefaults.standard.string(forKey: "currentUserID") else {
            return ""
        }
        return id
    }
    
}


struct User {
    
    let id: String
    let name: String
    let number: String
    let birthDate: String
    var cardID: String?
    
}


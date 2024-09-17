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
}


struct User {
    let id: String
    let name: String
    let number: String
    let birthDate: String
    var cardID: String?
}


struct Card: Decodable {
    
    let id: String
    let type: String
    let ownerID: String
    let code: String
    let cvv: String
    let balance: String
    let date: String
    
}

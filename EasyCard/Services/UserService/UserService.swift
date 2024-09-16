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
}

class UserService: UserServiceProtocol {
    
    static let shared: UserServiceProtocol = UserService()
    
    func saveUserData(with userData: User) async throws {
        let db = Firestore.firestore()
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
    
}


struct User: Decodable {
    
    let id: String
    let name: String
    let number: String
    let birthDate: String
    var cardIDs: [String] = []
    
}

struct Card: Decodable {
    
    let id: String
    let ownerID: String
    let code: String
    let cvv: String
    let balance: String
    let date: String
    
}

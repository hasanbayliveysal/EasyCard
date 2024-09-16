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
    }
}

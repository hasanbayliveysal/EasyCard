//
//  WelcomeViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import Foundation

final class WelcomeViewModel {
    func changeLanguage(_ language: Language) {
        LocalizationService.shared.changeLanguage(language)
    }
}

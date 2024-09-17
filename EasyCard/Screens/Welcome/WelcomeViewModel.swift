//
//  WelcomeViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 17.09.24.
//

import Foundation

class WelcomeViewModel {
    func changeLanguage(_ language: Language) {
        LocalizationService.shared.changeLanguage(language)
    }
}

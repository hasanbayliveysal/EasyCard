//
//  LocalizationService.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

protocol LocalizationServiceProtocol {
    func changeLanguage(_ language: Language)
    func getLanguage() -> String
}

final class LocalizationService: LocalizationServiceProtocol {
    static let shared = LocalizationService()
    private init(){}
    
    static let userApplicationLanguageKey = "UserApplicationLanguageKey"
    static var currentLanguage = Language.en.rawValue
    
    func changeLanguage(_ language: Language) {
        LocalizationService.currentLanguage = language.rawValue
        UserDefaults.standard.setValue(language.rawValue, forKey: LocalizationService.userApplicationLanguageKey)
    }
    
    @discardableResult
    func getLanguage() -> String {
        let language = UserDefaults.standard.string(forKey: LocalizationService.userApplicationLanguageKey) ?? LocalizationService.currentLanguage
        LocalizationService.currentLanguage = language
        return language
    }
}

enum Language: String {
    case az,en
}

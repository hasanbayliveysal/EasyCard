//
//  String+Ex.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import Foundation

extension String {
    
    func localized() -> String {
        if let path = Bundle.main.path(forResource: LocalizationService.currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return self
    }
    
}

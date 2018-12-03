//
//  LanguageEnum.swift
//
//
//  Created by Pramod Kumar on 25/09/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

enum LanguageEnum: String {
    
    case english = "en"
    case arabic = "ar"
    
    static func title(lang: LanguageEnum) -> String {
        if lang == .english {
            return LanguageEnum.selectedLanguage == .english ? "English" : "Arabic"
        } else {
            return LanguageEnum.selectedLanguage == .arabic ? "English" : "Arabic"
        }
    }
    
    var intValue: Int {
        switch self {
        case .english: return 1
        case .arabic:  return 2
        }
    }
    
    var semantic: UISemanticContentAttribute {
        switch self {
        case .english: return .forceLeftToRight
        case .arabic: return .forceRightToLeft
        }
    }
    
    static func selectLanaguage(language: LanguageEnum) {
        
        UserDefaults.setObject(language.rawValue, forKey: UserDefaults.Key.language.rawValue)
        LanguageEnum.selectedLanguage = language
        
        UIView.appearance().semanticContentAttribute = language.semantic
    }
    
    static var selectedLanguage = LanguageEnum(rawValue: UserDefaults.getObject(forKey: UserDefaults.Key.language.rawValue) as? String ?? "en") ?? .english
    
    static var isLanguageEnglish: Bool {
        return LanguageEnum.selectedLanguage == .english
    }
}

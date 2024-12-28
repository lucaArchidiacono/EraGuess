//
//  Locale+.swift
//  Fundamentals
//
//  Created by Luca Archidiacono on 13.12.2024.
//

import Foundation

public extension Locale {
    var appLanguage: String? {
        guard let currentLanguageCode = language.languageCode?.identifier else { return nil }
        let currentLocale = NSLocale(localeIdentifier: currentLanguageCode)
        return currentLocale.displayName(forKey: .identifier, value: currentLanguageCode)
    }
}

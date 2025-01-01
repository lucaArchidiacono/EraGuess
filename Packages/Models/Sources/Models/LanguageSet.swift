//
//  LanguageSet.swift
//  Models
//
//  Created by Luca Archidiacono on 29.12.2024.
//

public enum LanguageSet: Codable, Sendable, CaseIterable {
    case enDE
    case enCH

    public var code: String {
        switch self {
        case .enDE: "en-DE"
        case .enCH: "en-CH"
        }
    }

    public var localizedString: String {
        switch self {
        case .enDE:
            "English/German"
        case .enCH:
            "English/Swiss German"
        }
    }
}

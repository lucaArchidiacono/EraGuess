//
//  LanguageSet.swift
//  Models
//
//  Created by Luca Archidiacono on 29.12.2024.
//

public enum LanguageSet: Codable, Sendable, CaseIterable {
    case enDe

    public var code: String {
        switch self {
        case .enDe: "en-DE"
        }
    }

    public var localizedString: String {
        switch self {
        case .enDe:
            "English/German"
        }
    }
}

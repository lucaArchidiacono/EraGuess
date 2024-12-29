//
//  Navigation.swift
//  SettingsUI
//
//  Created by Luca Archidiacono on 29.12.2024.
//

import EmailFeatureUI

public enum Destination: Hashable {
    case privacy
    case termsOfUse
    case feedback
}

public enum Page: Hashable, Identifiable {
    case email(EmailData)

    public var id: Self { self }
}

//
//  View+.swift
//  CasaZurigo
//
//  Created by Luca Archidiacono on 15.05.2024.
//

import Foundation
import SwiftUI

public extension View {
    @MainActor func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

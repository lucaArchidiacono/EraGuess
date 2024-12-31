//
//  ContinueButton.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SwiftUI

struct ContinueButton: View {
    let onContinue: () -> Void

    var body: some View {
        Button {
            onContinue()
        } label: {
            Text("Continue")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ContinueButton(onContinue: {})
}

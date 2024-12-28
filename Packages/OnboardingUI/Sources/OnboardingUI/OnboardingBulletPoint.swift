//
//  OnboardingBulletPoint.swift
//  OnboardingFeature
//
//  Created by Luca Archidiacono on 16.09.2024.
//

import Foundation
import SwiftUI

struct OnboardingBulletPointConfig: Hashable {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingBulletPoint: View {
    let config: OnboardingBulletPointConfig

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: config.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.tint)
                .frame(width: 45, height: 45)
                .padding(.trailing)

            VStack(alignment: .leading) {
                Text(config.title)
                    .font(.headline)
                Text(config.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

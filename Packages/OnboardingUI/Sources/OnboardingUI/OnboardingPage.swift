//
//  OnboardingPage.swift
//  OnboardingFeature
//
//  Created by Luca Archidiacono on 16.09.2024.
//

import Foundation
import Models
import SwiftUI

struct OnboardingPageConfig {
    let title: String
    let bulletPoints: [OnboardingBulletPointConfig]
    var selections: [AnyHashable?] = []
    var onSelection: ((AnyHashable?) -> Void)?
    let buttonTitle: String
    let onAction: (@escaping () -> Void) -> Void
}

struct OnboardingPage: View {
    @State private var isLoading: Bool = false
    @State private var selected: AnyHashable? = nil

    let config: OnboardingPageConfig

    var body: some View {
        VStack {
            title
            list
            button
        }
    }

    var title: some View {
        Text(config.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 50)
            .padding(.horizontal)
    }

    var list: some View {
        List {
            Group {
                bulletPoints
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
    }

    var button: some View {
        Button {
            isLoading.toggle()

            config.onAction {
                isLoading.toggle()
            }
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    Text(config.buttonTitle)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .padding()
        .buttonStyle(.borderedProminent)
        .disabled(!config.selections.isEmpty && selected == nil)
    }

    private var bulletPoints: some View {
        ForEach(config.bulletPoints, id: \.self) { config in
            OnboardingBulletPoint(config: config)
        }
    }
}

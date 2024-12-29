//
//  VinylDisk.swift
//  HomeUI
//
//  Created by DG-SM-8669 on 28.12.2024.
//

import HapticFeedbackFeature
import SwiftUI
import UINavigation

struct VinylDisk: View {
    @Environment(Router<HomeUI.Destination, HomeUI.Page>.self) private var router

    @State private var rotation: Double = 0
    @State private var isPressed: Bool = false

    private let hapticFeedbackManager: HapticFeedbackManager

    init(
        hapticFeedbackManager: HapticFeedbackManager = .init()
    ) {
        self.hapticFeedbackManager = hapticFeedbackManager
    }

    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(.gray, lineWidth: 2)
                .frame(width: 280, height: 280)

            // Main vinyl body
            Circle()
                .fill(Color.black)
                .frame(width: 270, height: 270)

            // Vinyl grooves
            ForEach(0 ..< 20) { index in
                Circle()
                    .stroke(.gray.opacity(0.3), lineWidth: 0.5)
                    .frame(width: CGFloat(260 - index * 12))
            }

            // Center label
            Circle()
                .fill(Color.red)
                .frame(width: 90, height: 90)
                .overlay {
                    Text("PLAY")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

            // Center hole
            Circle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
        }
        .rotationEffect(.degrees(rotation))
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .onAppear {
            withAnimation(.linear(duration: 6)
                .repeatForever(autoreverses: false))
            {
                rotation = 360
            }
        }
        // Use gesture instead of Button
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.3)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3)) {
                        isPressed = false
                        hapticFeedbackManager.fireHaptic(of: .buttonPress)
                        router.fullScreen = .game
                    }
                }
        )
    }
}

#Preview {
    VinylDisk()
        .environment(Router<HomeUI.Destination, HomeUI.Page>())
}

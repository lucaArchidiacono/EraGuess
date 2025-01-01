//
//  SetupView.swift
//  GameUI
//
//  Created by Luca Archidiacono on 31.12.2024.
//

import Foundation
import SharedUI
import SwiftUI
import HapticFeedbackFeature
import AnalyticsDomain

struct SetupView: View {
    @Environment(GameEngine.self) private var engine
    @Environment(\.hapticFeedbackManager) private var hapticFeedbackManager
    @Environment(\.analyticsManager) private var analyticsManager

    @State private var currentCount: Int = 3
    @State private var opacityValue: Double = 0
    @State private var showingCountdown: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            if !showingCountdown {
                setupContent
            } else {
                countdownContent
            }
        }
        .padding()
    }
}

// MARK: - Setup
extension SetupView {
    private var setupContent: some View {
        VStack(spacing: 24) {
            gameModeSection

            if engine.mode == .multiplayer {
                teamNumberSection
            }

            Spacer()
            continueButton
        }
        .transition(.opacity)
    }
    
    private var gameModeSection: some View {
        VStack {
            Text("Choose Game Mode")
                .font(.title)
                .fontWeight(.bold)

            HStack(spacing: 20) {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    GameModeButton(
                        mode: mode
                    )
                    .disabled(engine.mode == mode)
                }
            }
        }
    }
    
    private var teamNumberSection: some View {
        VStack(spacing: 16) {
            Text("Number of Team")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                ForEach(engine.minTeams ... engine.maxTeams, id: \.self) { number in
                    TeamNumberButton(
                        number: number
                    )
                }
            }
        }
        .transition(.opacity)
    }
    
    private var continueButton: some View {
        ProminentButton {
            withAnimation {
                showingCountdown = true
            }
        } label: {
            Text("Continue")
                .font(.title3.weight(.semibold))
        }
        .disabled(engine.teams.isEmpty)
    }
}

// MARK: - Countdown
extension SetupView {
    private var countdownContent: some View {
        VStack(spacing: 16) {
            Text("Game starts in")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("\(currentCount)")
                .font(.system(size: 120, weight: .bold, design: .rounded))
                .opacity(opacityValue)
        }
        .transition(.opacity)
        .onAppear {
            startCountdown()
        }
    }

    private func startCountdown() {
        withAnimation(.easeIn(duration: 0.3)) {
            opacityValue = 1
        }

        Task {
            for _ in 0 ..< 3 {
                try? await Task.sleep(for: .seconds(1))

                // Fade out
                withAnimation(.easeOut(duration: 0.3)) {
                    opacityValue = 0
                }

                try? await Task.sleep(for: .seconds(0.3))

                if currentCount > 1 {
                    currentCount -= 1
                    // Fade in
                    withAnimation(.easeIn(duration: 0.3)) {
                        opacityValue = 1
                    }
                } else {
                    engine.startGame()
                    break
                }
            }
        }
    }
}

#if DEBUG
import AnalyticsFeature

#Preview {
    SetupView()
        .environment(GameEngine())
        .environment(\.analyticsManager, MockAnalyticsManager())
        .environment(\.hapticFeedbackManager, HapticFeedbackManager())
}

#endif

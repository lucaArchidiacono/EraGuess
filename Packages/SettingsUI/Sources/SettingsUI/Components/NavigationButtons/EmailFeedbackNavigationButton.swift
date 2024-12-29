//
//  EmailFeedbackNavigationButton.swift
//  SettingsFeature
//
//  Created by Luca Archidiacono on 25.12.2024.
//

import EmailFeatureUI
import EraGuessShared
import SharedUI
import SwiftUI
import UINavigation

struct EmailFeedbackNavigationButton: View {
    @Environment(\.openURL) private var openURL
    @Environment(Router<Destination, Page>.self) private var router

    var body: some View {
        navigationButton
            .buttonStyle(.plain)
    }

    private var navigationButton: some View {
        AsyncButton {
            let emailData = await loadEmailData()
            router.sheet = .email(emailData)
        } label: {
            HStack {
                Label(
                    title: {
                        Text("Leave Feedback")
                            .fontWeight(.bold)
                    },
                    icon: {
                        Image(systemName: "envelope")
                            .foregroundStyle(.gray)
                    }
                )
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.gray)
            }
            .contentShape(.interaction, Rectangle())
        }
    }

    private nonisolated
    func loadEmailData() async -> EmailData {
        let urls = EraGuessShared.Configuration.logFileURLs(for: .mainApp)
        let attachements: [EmailData.AttachmentData] = urls
            .compactMap { url -> EmailData.AttachmentData? in
                guard let data = try? Data(contentsOf: url) else {
                    return nil
                }
                return EmailData.AttachmentData(data: data, mimeType: url.mimeType(), fileName: url.lastPathComponent)
            }
        return EmailData(
            recipient: EraGuessShared.email,
            subject: "Log Files",
            body: .raw(
                body:
                """
                I'd like to take the chance and thank you for using my app!
                With this email you are trying to file a bug. Please state your issue below this line:

                """
            ),
            attachments: attachements
        )
    }
}

//
//  AppleMailView.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.

import AnalyticsDomain
import Foundation
import Logger
import MessageUI
import SwiftUI

public struct AppleMailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    private let emailData: EmailData
    private let analyticsManager: AnalyticsManager

    public static let canSendMail: Bool = MFMailComposeViewController.canSendMail()

    public init(
        emailData: EmailData,
        analyticsManager: AnalyticsManager
    ) {
        self.emailData = emailData
        self.analyticsManager = analyticsManager
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let logger = Logger(label: String(describing: Coordinator.self))

        var parent: AppleMailView

        init(_ parent: AppleMailView) {
            self.parent = parent
        }

        public func mailComposeController(_: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error {
                logger.error("Failed to compose a Controller with error: \(error)")
                return
            }

            logger.info("Finished to compose a Controller with result: \(result)")

            parent.dismiss()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        analyticsManager.track(event: .view(name: String(describing: AppleMailView.self)))

        let emailComposer = MFMailComposeViewController()
        emailComposer.mailComposeDelegate = context.coordinator

        emailComposer.setSubject(emailData.subject)
        emailComposer.setToRecipients([emailData.recipient])
        switch emailData.body {
        case let .html(body):
            emailComposer.setMessageBody(body, isHTML: true)
        case let .raw(body):
            emailComposer.setMessageBody(body, isHTML: false)
        }
        for attachment in emailData.attachments {
            emailComposer.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
        }

        return emailComposer
    }

    public func updateUIViewController(_: MFMailComposeViewController, context _: Context) {}
}

//
//  EmailData.swift
//  EmailFeature
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import Foundation

public struct EmailData: Hashable, Identifiable, Sendable {
    public let id: UUID = .init()
    public let recipient: String
    public let subject: String
    public let body: Body
    public let attachments: [AttachmentData]

    public init(
        recipient: String,
        subject: String,
        body: Body,
        attachments: [AttachmentData]
    ) {
        self.recipient = recipient
        self.subject = subject
        self.body = body
        self.attachments = attachments
    }

    public enum Body: Hashable, Sendable {
        case html(body: String)
        case raw(body: String)
    }

    public struct AttachmentData: Hashable, Sendable {
        public let data: Data
        public let mimeType: String
        public let fileName: String

        public init(data: Data, mimeType: String, fileName: String) {
            self.data = data
            self.mimeType = mimeType
            self.fileName = fileName
        }
    }
}

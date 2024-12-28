//
//  EraGuessShared.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.
//

import Foundation
import UIKit

public enum EraGuessShared {
    public static let appSettingsURL = URL(string: UIApplication.openSettingsURLString)!
    /// Feedback URL redirecting to App Store..
    public static let appFeedbackURL = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")!
    /// App ID.
    public static let appID = ""
    /// Support Mail.
    public static let email = "support@eraguess.ch"

    /// RevenueCat API Key
    public static let revenueCatAPIKey = Bundle.main.object(forInfoDictionaryKey: "REVENUE_CAT_KEY") as! String

    /// TelemetryDeck API Key
    public static let telemetryAPIKey = Bundle.main.object(forInfoDictionaryKey: "TELEMETRYDECK_KEY") as! String

    /// Privacy policy URL.
    public static let privacyPolicyURL = URL(string: "https://eraguess.ch/privacy")!
    /// Terms of Use URL.
    public static let termsOfUseURL = URL(string: "https://eraguess.ch/terms-of-use")!

    public enum Target: CaseIterable {
        case mainApp

        /// Returns target bundle identifier.
        public var bundleIdentifier: String {
            // "MainApplicationIdentifier" does not exist if running tests
            let mainBundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "MainApplicationIdentifier") as? String ?? "tests"
            switch self {
            case .mainApp:
                return mainBundleIdentifier
            }
        }

        public var currentAppVersion: String {
            let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
            switch self {
            case .mainApp:
                return currentAppVersion
            }
        }
    }

    public enum Configuration {
        private static var logFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss"
            return formatter
        }

        public static let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String

        /// Shared container security group identifier.
        public static let securityGroupIdentifier: String = Bundle.main.object(forInfoDictionaryKey: "ApplicationSecurityGroupIdentifier") as! String

        /// Container URL for security group.
        public static let containerURL: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: securityGroupIdentifier)!

        /// Returns URL for new log file associated with application target and located within shared container.
        public static func newLogFileURL(for target: Target) -> URL {
            containerURL.appendingPathComponent(
                "\(target.bundleIdentifier)_\(logFormatter.string(from: .now)).log",
                isDirectory: false
            )
        }

        /// Returns URLs for log files associated with application target and located within shared container.
        public static func logFileURLs(for _: Target) -> [URL] {
            let containerUrl = containerURL

            return (try? FileManager.default.contentsOfDirectory(atPath: containerURL.relativePath))?.compactMap { file in
                if file.split(separator: ".").last == "log" {
                    containerUrl.appendingPathComponent(file)
                } else {
                    nil
                }
            }.sorted { $0.relativePath > $1.relativePath } ?? []
        }
    }
}

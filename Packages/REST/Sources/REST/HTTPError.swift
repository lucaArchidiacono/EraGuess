//
//  HTTPError.swift
//
//  Created by Luca Archidiacono on 09.10.23.
//

import Foundation

public enum HTTPError: CustomStringConvertible, Error, Equatable {
    case noResponse
    case invalidURL
    case unauthorized
    case badHttpStatusCode(code: Int)
    case unknown
    case expired
    case invalidObject
    case unsuccessfulUpload
    case missingAuthentication
    case reachedMaxRetries
    case couldNotAccessLocalFile

    public var description: String {
        let description = "\(type(of: self)): "
        switch self {
        case .noResponse:
            return description + "No response from Server."
        case .invalidURL:
            return description + "Invalid URL."
        case .expired:
            return description + "Session expired."
        case .unauthorized:
            return description + "User is not authorized."
        case let .badHttpStatusCode(code):
            return description + "Bad status code: \(code)"
        case .unknown:
            return description + "Unkown error."
        case .invalidObject:
            return description + "Was not able to create object."
        case .unsuccessfulUpload:
            return description + "The upload was not successsful. No mediaobjects."
        case .missingAuthentication:
            return description + "Information for Base Authentication is missing (username & password)."
        case .reachedMaxRetries:
            return description + "Reached the maximum of retries for the network request."
        case .couldNotAccessLocalFile:
            return description + "Was not able to access local file, while trying to upload."
        }
    }
}

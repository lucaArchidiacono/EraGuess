//
//  HTTPHeader.swift
//
//  Created by Luca Archidiacono on 09.10.23.
//

import Foundation

public enum HTTPHeaderKey: String {
    case accept = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case authorization = "Authorization"
    case cacheControl = "Cache-Control"
    case contentType = "Content-Type"
    case contentEncoding = "Content-Encoding"
    case mediacoreToken = "X-mediaCORE-XSRF-TOKEN"
    case ifMatch = "if-match"
}

public enum HTTPHeaderValue {
    public enum Accept: String {
        case json = "application/json"
    }

    public enum ContentType {
        case json
        case multiPartFromData(boundary: String)

        var rawValue: String {
            switch self {
            case .json:
                "application/json; charset=utf-8"
            case let .multiPartFromData(boundary):
                "multipart/form-data; boundary=\(boundary)"
            }
        }
    }
}

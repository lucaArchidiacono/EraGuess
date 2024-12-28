//
//  Request.swift
//
//  Created by Luca Archidiacono on 08.10.2023.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public enum HTTPParamEncoding {
    case json
    case url

    var contentType: String {
        switch self {
        case .url:
            "application/x-www-form-urlencoded"
        case .json:
            "application/json; charset=utf-8"
        }
    }
}

public enum HTTPBody {
    case json(Encodable)
    case dictionary(_ queries: [String: Any]?, _ encoding: HTTPParamEncoding)
    case data(Data)
    case empty
}

public protocol Request {
    var baseURL: URL? { get }
    var path: String? { get }
    var body: HTTPBody { get }
    var method: HTTPMethod { get }
    var header: [String: Any] { get }
    var cached: Bool { get }
    var type: URLRequest.NetworkServiceType { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension Request {
    var path: String? { nil }
    var header: [String: Any] { [:] }
    var cached: Bool { false }
    var type: URLRequest.NetworkServiceType { .responsiveData }
    var queryItems: [URLQueryItem]? { nil }
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = baseURL?.scheme
        components.host = baseURL?.host()
        components.path = path ?? baseURL?.path() ?? ""
        components.queryItems = queryItems
        components.port = baseURL?.port
        return components
    }
}

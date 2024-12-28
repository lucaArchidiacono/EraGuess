//
//  HTTPEncodingTransformer.swift
//
//  Created by Luca Archidiacono on 09.10.23.
//

import Foundation

enum HTTPEncodingTransformer {
    static func transform(_ request: Request) throws -> URLRequest {
        guard let url: URL = request.urlComponents.url else {
            throw HTTPError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.networkServiceType = request.type

        for (key, value) in request.header {
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }

        switch request.body {
        case let .json(encodable):
            let data = try JSONEncoder().encode(encodable)

            urlRequest.httpBody = data
            urlRequest.setValue(HTTPParamEncoding.json.contentType, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)

            return urlRequest
        case let .dictionary(queries, encoding):
            urlRequest.setValue(encoding.contentType, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
            guard let queries else { return urlRequest }

            switch encoding {
            case .url:
                urlRequest.httpBody = HTTPEncodingTransformer.transform(queries)
            case .json:
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: queries)
            }
            return urlRequest
        case let .data(data):
            urlRequest.httpBody = data
            return urlRequest
        case .empty:
            return urlRequest
        }
    }

    static func transform(_ parameters: [String: Any]) -> Data? {
        let urlEncoded = parameters.compactMap { (key: String, value: Any) in
            guard let keyString = key.addingPercentEncoding(withAllowedCharacters: urlQueryValueAllowed),
                  let valueString = String(describing: value)
                  .addingPercentEncoding(withAllowedCharacters: urlQueryValueAllowed) else { return nil }
            return keyString + "=" + valueString
        }.joined(separator: "&").data(using: .utf8)
        return urlEncoded
    }

    static func transform(_ parameters: [String: Any], boundary: String) -> Data {
        var data = Data()
        let separator = "\r\n"
        for (k, v) in parameters {
            data.append("--\(boundary)\(separator)".data(using: .utf8)!)
            data.append(("Content-Disposition: form-data; name=\"\(k)\"" + "\(separator)").data(using: .utf8)!)
            data.append("\(separator)".data(using: .utf8)!)
            data.append(("\(v)" + "\(separator)").data(using: .utf8)!)
        }
        data.append("--\(boundary)--".data(using: .utf8)!)
        return data
    }
}

// MARK: - Private methods

extension HTTPEncodingTransformer {
    private static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return allowed
    }()
}

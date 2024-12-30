//
//  REST.swift
//
//  Created by Luca Archidiacono on 08.10.23.
//

import Foundation

public protocol REST: Sendable {
    func request<T: Decodable>(request: Request) async throws -> T
    func request(url: URL) async throws -> (Data, HTTPURLResponse)
    func request(request: Request) async throws -> (Data, HTTPURLResponse)
    func download(request: Request) async throws -> (URL, HTTPURLResponse)
}

public final class RESTService: REST, @unchecked Sendable {
    private lazy var session: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 8
        configuration.httpShouldUsePipelining = true

        let session = URLSession(configuration: configuration)
        return session
    }()

    private lazy var cachedSession: URLSession = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("RequestCache")
        let cache = URLCache(memoryCapacity: 1_000_000, diskCapacity: 10_000_000, directory: diskCacheURL)

        var configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 8
        configuration.httpShouldUsePipelining = true
        configuration.urlCache = cache

        let session = URLSession(configuration: configuration)
        return session
    }()

    private let decoder = JSONDecoder()

    public init() {}

    public func request<T: Decodable>(request: Request) async throws -> T {
        let urlRequest = try HTTPEncodingTransformer.transform(request)

        let session = request.cached ? cachedSession : session
        let (data, response) = try await session.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.noResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(T.self, from: data)
        default:
            throw HTTPError.badHttpStatusCode(code: response.statusCode)
        }
    }

    public func request(request: Request) async throws -> (Data, HTTPURLResponse) {
        let urlRequest = try HTTPEncodingTransformer.transform(request)

        let session = request.cached ? cachedSession : session
        let (data, response) = try await session.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.noResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return (data, response)
        default:
            throw HTTPError.badHttpStatusCode(code: response.statusCode)
        }
    }
    
    public func request(url: URL) async throws -> (Data, HTTPURLResponse) {
        struct SimpleRequest: Request {
            var baseURL: URL?
            var body: HTTPBody { .empty }
            var method: HTTPMethod { .get }
        }
        
        let request = SimpleRequest(baseURL: url)
        let urlRequest = try HTTPEncodingTransformer.transform(request)

        let session = request.cached ? cachedSession : session
        let (data, response) = try await session.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.noResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return (data, response)
        default:
            throw HTTPError.badHttpStatusCode(code: response.statusCode)
        }
    }

    public func download(request: Request) async throws -> (URL, HTTPURLResponse) {
        let urlRequest = try HTTPEncodingTransformer.transform(request)

        let session = request.cached ? cachedSession : session
        let (url, response) = try await session.download(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.noResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return (url, response)
        default:
            throw HTTPError.badHttpStatusCode(code: response.statusCode)
        }
    }
}

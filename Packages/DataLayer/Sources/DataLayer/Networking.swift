//
//  Networking.swift
//  DataLayer
//
//  Created by Fuchs on 4/11/25.
//

import Foundation

// MARK: Model

public struct HttpBinGetResponse: Decodable, Sendable {
    public let url: String
    public let origin: String
    public let headers: [String: String]

    public init(url: String, origin: String, headers: [String: String]) {
        self.url = url
        self.origin = origin
        self.headers = headers
    }
}

// MARK: Protocol

public protocol NetworkingClient: Sendable {
    func fetchSampleGet() async throws -> HttpBinGetResponse
}

// MARK: URLSession implementation

public struct URLSessionNetworkingClient: NetworkingClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchSampleGet() async throws -> HttpBinGetResponse {
        let url = URL(string: "https://httpbin.org/get")!
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(HttpBinGetResponse.self, from: data)
    }
}

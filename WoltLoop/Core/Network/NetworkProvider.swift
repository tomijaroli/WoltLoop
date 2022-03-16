//
//  NetworkProvider.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine
import os.log

extension NetworkProvider {
    enum URLError: Error {
        case couldNotBuildURLComponents(partialURL: URL)
        case couldNotBuildURL(partialURL: URL, parameters: [String: String]?)
    }
}

class NetworkProvider<E: Endpoint> {
    private let decoder: JSONDecoder
    private let session: URLSession
    private let logger: WoltLoopLogger
    
    init(decoder: JSONDecoder, session: URLSession, logger: WoltLoopLogger) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
        self.session = session
        self.logger = logger
    }
    
    func request<T: Decodable>(endpoint: E) -> AnyPublisher<T, NetworkError> {
        guard let request = makeRequest(for: endpoint) else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { _ in return NetworkError.invalidRequest }
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                self.processResponseStatus(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .map {
                print($0)
                return $0
            }
            .catch { error in
                return Fail(error: NetworkError.parseError(reason: error))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func makeURL(for endpoint: E) -> URL? {
        var partialURL = endpoint.baseURL.appendingPathComponent(endpoint.apiVersion)
        partialURL = partialURL.appendingPathComponent(endpoint.path)
        
        guard var components = URLComponents(url: partialURL, resolvingAgainstBaseURL: false) else {
            let error = URLError.couldNotBuildURLComponents(partialURL: partialURL)
            logger.logError(message: error.localizedDescription, error: error)
            return nil
        }
        
        if let parameters = endpoint.parameters {
            var queryItems = [URLQueryItem]()
            parameters.forEach { queryItems.append(URLQueryItem(name: $0.key, value: $0.value))}
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            let error = URLError.couldNotBuildURL(partialURL: partialURL, parameters: endpoint.parameters)
            logger.logError(message: error.localizedDescription, error: error)
            return nil
        }
        
        return url
    }
    
    private func makeRequest(for endpoint: E) -> URLRequest? {
        guard let url = makeURL(for: endpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        return request
    }
    
    private func processResponseStatus(data: Data, response: URLResponse) -> AnyPublisher<Data, Error> {
        guard let response = response as? HTTPURLResponse else {
            return Fail(error: NetworkError.invalidResponse)
                .eraseToAnyPublisher()
        }
        
        if response.statusCode == 404 {
            return Fail(error: NetworkError.message(reason: "Resource not found", statusCode: response.statusCode, data: data))
                .eraseToAnyPublisher()
        }
        
        guard 200..<300 ~= response.statusCode else {
            let message = response.description
            return Fail(error: NetworkError.message(reason: message, statusCode: response.statusCode, data: data))
                .eraseToAnyPublisher()
        }
        
        return Just<Data>(data)
            .mapError({ _ in NetworkError.unknown })
            .eraseToAnyPublisher()
    }
}

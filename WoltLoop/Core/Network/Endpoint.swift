//
//  Endpoint.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation

public protocol Endpoint {
    var baseURL: URL { get }
    var apiVersion: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

public enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

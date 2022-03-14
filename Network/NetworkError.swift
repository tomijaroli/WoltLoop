//
//  NetworkError.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case message(reason: String, statusCode: Int, data: Data)
    case parseError(reason: Error)
    case unknown
}

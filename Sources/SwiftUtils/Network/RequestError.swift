//
//  RequestError.swift
//
//
//  Created by Raul on 26/5/24.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case json(Error)
    case informative // 100...103
    case okey // 200...208, 226
    case redirection // 300...308
    case clientError // 4...
    case clientErrorUnauthorized // 401
    case badRequest // 400
    case clientErrorForbidden // 403
    case notFound // 404
    case duplicated // 409
    case serverError // 5...
    case expired // 450...499
    case timeout
    case unknown
    case failedConnection
    case general(Error)
    case localFileNotFound

    var customMessage: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .badRequest:
            return "Bad request"
        case .decode:
            return "Decode error"
        case .clientErrorUnauthorized:
            return "Session expired"
        case .json(let error):
            return "JSON decode error \(error)."
        default:
            return "Unknown error"
        }
    }
}

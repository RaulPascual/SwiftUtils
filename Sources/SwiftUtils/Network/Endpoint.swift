//
//  Endpoint.swift
//
//
//  Created by Raul on 26/5/24.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: Data? { get }
}

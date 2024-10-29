//
//  HTTPClient.swift
//
//
//  Created by Raul on 26/5/24.
//

import Foundation

public protocol HTTPClient {
    func sendRequest<T: Decodable>(enableDebug: Bool, endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    /**
     Sends an asynchronous network request and decodes the response into a specified model.

     - Parameters:
        - enableDebug: A boolean value indicating whether to enable debug logging. Default is false.
        - endpoint: The endpoint to which the request will be sent, including base URL, path, method, header, and body.
        - responseModel: The type of the model to decode the response into.

     - Returns: A result containing either the decoded response model on success or a `RequestError` on failure.

     - Throws: `RequestError` if the request fails or the response cannot be decoded.
     */
    public func sendRequest<T: Decodable>(
        enableDebug: Bool = false,
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        let requestDate = Date.now
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        self.logMessages(enableDebug: enableDebug,
                         message: "Complete URL: \(url.absoluteString)")
        
        if let body = endpoint.body {
            request.httpBody = body.data(using: .utf8)
        }
        
        do {
            return try await processResponse(
                enableDebug: enableDebug,
                request: request,
                responseModel: responseModel,
                urlForDebugView: url,
                endpointForDebugView: endpoint, 
                requestDate: requestDate
            )
        } catch {
            return .failure(.unknown)
        }
    }
    
    /**
     Processes the response of a network request and decodes it into a specified model.

     - Parameters:
        - request: The URLRequest to be sent.
        - responseModel: The type of the model to decode the response into.

     - Returns: A result containing either the decoded response model on success or a `RequestError` on failure.

     - Throws: An error if the network request fails or the response cannot be processed.

     - Note:
        - Status codes 200-299 are considered successful.
        - Status code 401 indicates unauthorized access.
        - Status code 403 indicates forbidden access.
        - Status code 404 indicates that the requested resource was not found.
        - Status codes 500-599 indicate server errors.
        - Any other status code or inability to decode the response results in an unknown error.
     */
    private func processResponse<T: Decodable>(
        enableDebug: Bool,
        request: URLRequest,
        responseModel: T.Type,
        urlForDebugView: URL,
        endpointForDebugView: Endpoint,
        requestDate: Date
    ) async throws -> Result<T, RequestError> {
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noResponse)
        }
        
        if enableDebug {
            // Convert data to String
            guard let jsonResponseString = String(data: data, encoding: .utf8) else {
                return .failure(.decode)
            }
            
            let request = DebugViewHTTPS.Request(
                endpoint: urlForDebugView.absoluteString,
                method: endpointForDebugView.method.rawValue,
                date: requestDate,
                body: endpointForDebugView.body ?? "nil",
                response: DebugViewHTTPS.Response(
                    endpoint: httpResponse.url?.absoluteString ?? "",
                    date: Date.now,
                    response: jsonResponseString,
                    statusCode: String(httpResponse.statusCode)
                ),
                requestOverviewInfo: [:]
            )
            
            let debugView = DebugViewHTTPS.shared
            await debugView.addRequestToList(request: request)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ✅ Status Code: \(httpResponse.statusCode) -----")
            
            guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                return .failure(.decode)
            }
            return .success(decodedResponse)
            
        case 401:
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ❌ Status Code: clientUnauthorized -----")
            return .failure(.clientErrorUnauthorized)
            
        case 403:
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ❌ Status Code: clientErrorForbidden -----")
            return .failure(.clientErrorForbidden)
            
        case 404:
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ❌ Status Code: notFound -----")
            return .failure(.notFound)
            
        case 500...599:
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ❌ Status Code: \(httpResponse.statusCode) -----")
            return .failure(.serverError)
            
        default:
            return .failure(.unknown)
        }
    }
    
    /**
     Logs debug messages if debug mode is enabled.

     - Parameters:
        - enableDebug: A boolean value indicating whether to enable debug logging.
        - message: The message to be logged.

     - Note: If `enableDebug` is true, the message will be printed to the console.
     */
    private func logMessages(enableDebug: Bool, message: String) {
        if enableDebug {
            print(message)
        }
    }
}

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
            request.httpBody = body
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
        } catch let urlError as URLError {
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- URLError: \(urlError.code) -----")
            switch urlError.code {
            case .timedOut:
                return .failure(.timeout)
            case .notConnectedToInternet, .networkConnectionLost:
                return .failure(.failedConnection)
            case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
                return .failure(.failedConnection)
            case .cancelled:
                return .failure(.unknown)
            default:
                return .failure(.general(urlError))
            }
        } catch {
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- Error: \(error) -----")
            return .failure(.general(error))
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
        - Status code 429 indicates rate limiting and includes the optional Retry-After delay.
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
            let jsonResponseString = String(data: data, encoding: .utf8) ?? "<Non-UTF8 response body>"
            
            let request = DebugViewHTTPS.Request(
                endpoint: urlForDebugView.absoluteString,
                method: endpointForDebugView.method.rawValue,
                date: requestDate,
                body: endpointForDebugView.body.flatMap { String(data: $0, encoding: .utf8) } ?? "",
                response: DebugViewHTTPS.Response(
                    endpoint: httpResponse.url?.absoluteString ?? "",
                    date: Date.now,
                    response: jsonResponseString,
                    statusCode: String(httpResponse.statusCode)
                ),
                requestOverviewInfo: [:]
            )
            
            await DebugViewHTTPS.shared.addRequestToList(request: request)
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
            
        case 429:
            let retryAfter = retryAfterDelay(from: httpResponse.value(forHTTPHeaderField: "Retry-After"))
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ❌ Status Code: tooManyRequests; Retry-After: \(String(describing: retryAfter)) -----")
            return .failure(.tooManyRequests(retryAfter: retryAfter))

        case 500...599:
            self.logMessages(enableDebug: enableDebug,
                             message: "\n----- ❌ Status Code: \(httpResponse.statusCode) -----")
            return .failure(.serverError)
            
        default:
            return .failure(.unknown)
        }
    }
    
    /// Parses Retry-After as nonnegative seconds or an HTTP date.
    /// A missing or invalid header leaves the retry policy to the caller.
    func retryAfterDelay(from header: String?, now: Date = Date()) -> TimeInterval? {
        guard let value = header?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return nil
        }

        if value.utf8.allSatisfy({ (48...57).contains($0) }),
           let seconds = TimeInterval(value), seconds.isFinite {
            return seconds
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.isLenient = false
        let formats = [
            "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
            "EEEE, dd-MMM-yy HH:mm:ss 'GMT'",
            "EEE MMM d HH:mm:ss yyyy"
        ]
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return max(0, date.timeIntervalSince(now))
            }
        }
        return nil
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

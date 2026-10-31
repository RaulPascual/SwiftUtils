import Foundation
import Synchronization
import XCTest
@testable import SwiftUtilities

final class HTTPClientRateLimitTests: XCTestCase {
    private let client = RateLimitTestClient()

    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(RateLimitTestURLProtocol.self)
    }

    override func tearDown() {
        URLProtocol.unregisterClass(RateLimitTestURLProtocol.self)
        super.tearDown()
    }

    func testRetryAfterSeconds() {
        XCTAssertEqual(client.retryAfterDelay(from: "60"), 60)
        XCTAssertEqual(client.retryAfterDelay(from: " 120 "), 120)
        XCTAssertEqual(client.retryAfterDelay(from: "0"), 0)
    }

    func testMissingOrInvalidRetryAfter() {
        let headers: [String?] = [nil, "", " ", "-1", "+1", "1.5", "NaN", "Infinity", "tomorrow",
                                  String(repeating: "9", count: 400)]
        for header in headers {
            XCTAssertNil(client.retryAfterDelay(from: header), "Unexpected delay for \(String(describing: header))")
        }
    }

    func testRetryAfterHTTPDates() throws {
        let now = try XCTUnwrap(ISO8601DateFormatter().date(from: "2015-10-21T07:27:00Z"))
        let headers = ["Wed, 21 Oct 2015 07:28:00 GMT", "Wednesday, 21-Oct-15 07:28:00 GMT",
                       "Wed Oct 21 07:28:00 2015"]
        for header in headers {
            XCTAssertEqual(client.retryAfterDelay(from: header, now: now), 60)
        }
        XCTAssertEqual(client.retryAfterDelay(from: headers[0], now: now.addingTimeInterval(120)), 0)
    }

    func test429PreservesRetryAfter() async {
        RateLimitTestURLProtocol.responseHeaders = ["Retry-After": "60"]
        RateLimitTestURLProtocol.statusCode = 429
        let result = await client.sendRequest(endpoint: RateLimitTestEndpoint(), responseModel: RateLimitTestPayload.self)
        guard case .failure(.tooManyRequests(let delay)) = result else {
            return XCTFail("Expected a rate-limit error, got \(result)")
        }
        XCTAssertEqual(delay, 60)
    }

    func test429WithoutRetryAfter() async {
        RateLimitTestURLProtocol.responseHeaders = [:]
        RateLimitTestURLProtocol.statusCode = 429
        let result = await client.sendRequest(endpoint: RateLimitTestEndpoint(), responseModel: RateLimitTestPayload.self)
        guard case .failure(.tooManyRequests(let delay)) = result else {
            return XCTFail("Expected a rate-limit error, got \(result)")
        }
        XCTAssertNil(delay)
    }

    func test429WithInvalidHeaderAndNonUTF8BodyWhenDebugging() async {
        RateLimitTestURLProtocol.responseHeaders = ["Retry-After": "invalid"]
        RateLimitTestURLProtocol.statusCode = 429
        RateLimitTestURLProtocol.body = Data([0xFF, 0xFE])
        defer { RateLimitTestURLProtocol.body = Data("{}".utf8) }
        let result = await client.sendRequest(enableDebug: true, endpoint: RateLimitTestEndpoint(),
                                              responseModel: RateLimitTestPayload.self)
        guard case .failure(.tooManyRequests(let delay)) = result else {
            return XCTFail("Debug logging must not mask the HTTP error, got \(result)")
        }
        XCTAssertNil(delay)
    }

    func testSuccessStillDecodes() async {
        RateLimitTestURLProtocol.responseHeaders = [:]
        RateLimitTestURLProtocol.statusCode = 200
        RateLimitTestURLProtocol.body = Data(#"{"value":42}"#.utf8)
        defer { RateLimitTestURLProtocol.body = Data("{}".utf8) }
        let result = await client.sendRequest(endpoint: RateLimitTestEndpoint(), responseModel: RateLimitTestPayload.self)
        guard case .success(let payload) = result else {
            return XCTFail("Expected decoded response, got \(result)")
        }
        XCTAssertEqual(payload.value, 42)
    }

    func test401StillReturnsUnauthorized() async {
        RateLimitTestURLProtocol.responseHeaders = [:]
        RateLimitTestURLProtocol.statusCode = 401
        let result = await client.sendRequest(endpoint: RateLimitTestEndpoint(), responseModel: RateLimitTestPayload.self)
        guard case .failure(.clientErrorUnauthorized) = result else {
            return XCTFail("Expected unauthorized error, got \(result)")
        }
    }
}

private struct RateLimitTestClient: HTTPClient {}

private struct RateLimitTestPayload: Decodable {
    let value: Int
}

private struct RateLimitTestEndpoint: Endpoint {
    var baseURL: String { "https://swiftutils-rate-limit.invalid" }
    var path: String { "/test" }
    var method: RequestMethod { .get }
    var header: [String: String]? { nil }
    var body: Data? { nil }
}

private final class RateLimitTestURLProtocol: URLProtocol {
    private static let state = Mutex((statusCode: 429, headers: [String: String](), body: Data("{}".utf8)))

    static var statusCode: Int {
        get { state.withLock { $0.statusCode } }
        set { state.withLock { $0.statusCode = newValue } }
    }

    static var responseHeaders: [String: String] {
        get { state.withLock { $0.headers } }
        set { state.withLock { $0.headers = newValue } }
    }

    static var body: Data {
        get { state.withLock { $0.body } }
        set { state.withLock { $0.body = newValue } }
    }

    override static func canInit(with request: URLRequest) -> Bool {
        request.url?.host == "swiftutils-rate-limit.invalid"
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url,
              let response = HTTPURLResponse(url: url, statusCode: Self.statusCode,
                                             httpVersion: "HTTP/1.1", headerFields: Self.responseHeaders) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

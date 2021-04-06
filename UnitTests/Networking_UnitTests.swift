import XCTest
@testable import Boilerplate

class NetworkTests : XCTestCase {

    private struct TestResponse : Decodable {
        let token: String
        let message: String
    }

    private let api = API(scheme: "http", host: "domain.com")
    private let path = "/test/response"
    private let coordinate = ["email": "mail@domain", "password": "securePassword"]
    private let result: String = """
    {
        "token": "fdsgegs3r43f34",
        "message": "Welcome to ExpertLead",
    }
    """

    func testGET() throws {
        // Given
        let request = Request<TestResponse>.get(
            at: path,
            input: .none,
            output: .json
        )

        // When
        let urlRequest = try api.urlRequest(for: request)

        // Then
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.url?.absoluteString, "http://domain.com/test/response")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
    }

    func testPOST() throws {
        // Given
        let request = try Request<TestResponse>.post(
            at: path,
            input: .json(coordinate),
            output: .json
        )

        // When
        let urlRequest = try api.urlRequest(for: request)

        // Then
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.url?.absoluteString, "http://domain.com/test/response")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Accept": "application/json", "Content-Type": "application/json"])

        guard let httpBody = urlRequest.httpBody else {
            return XCTFail("httBody must not be nil")
        }

        let body = String(decoding: httpBody, as: UTF8.self)
        XCTAssertTrue(body.contains("\"email\":\"mail@domain"))
        XCTAssertTrue(body.contains("\"password\":\"securePassword"))
    }

    func testDecodeJSON() throws {
        // Given
        let request = try Request<TestResponse>.post(
            at: path,
            input: .json(coordinate),
            output: .json
        )

        // When
        let response = try request.decode(Data(result.utf8))

        // Then
        XCTAssertEqual(response.token, "fdsgegs3r43f34")
        XCTAssertEqual(response.message, "Welcome to ExpertLead")
    }

}

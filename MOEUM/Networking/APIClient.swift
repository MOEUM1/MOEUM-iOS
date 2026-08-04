import Foundation

struct APIClient: Sendable {
    static let shared = APIClient()

    private let baseURL: URL
    private let session: URLSession

    init(
        baseURL: URL = URL(string: "http://165.140.22.54:4000/api")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func send<Response: Decodable>(
        _ path: String,
        method: HTTPMethod = .get,
        body: (any Encodable)? = nil,
        accessToken: String? = nil
    ) async throws -> Response {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder.moeum.encode(AnyEncodable(body))
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            let payload = try? JSONDecoder.moeum.decode(APIErrorPayload.self, from: data)
            throw APIError.server(statusCode: httpResponse.statusCode, message: payload?.message)
        }
        return try JSONDecoder.moeum.decode(Response.self, from: data)
    }
}

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum APIError: LocalizedError {
    case invalidResponse
    case server(statusCode: Int, message: String?)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "서버 응답을 확인할 수 없습니다."
        case let .server(statusCode, message):
            message ?? "서버 요청에 실패했습니다. (\(statusCode))"
        }
    }
}

private struct APIErrorPayload: Decodable {
    let message: String?
}

private struct AnyEncodable: Encodable {
    private let encodeValue: (Encoder) throws -> Void

    init(_ value: any Encodable) {
        encodeValue = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeValue(encoder)
    }
}

private extension JSONEncoder {
    static let moeum: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

private extension JSONDecoder {
    static let moeum: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

import Foundation

struct SupabaseAuthService {
    private let projectURL = "https://anjpigzpgaqvmlzduosb.supabase.co"
    private let publishableKey = "sb_publishable_czrEBraIutPr3fow7A9sdg__8RasXXI"

    func signUp(email: String, password: String, nickname: String, fullName: String) async throws -> AuthResponse {
        try await request(
            path: "auth/v1/signup",
            body: SignUpRequest(
                email: email,
                password: password,
                data: ["nickname": nickname, "full_name": fullName]
            )
        )
    }

    func signIn(email: String, password: String) async throws -> AuthResponse {
        try await request(path: "auth/v1/token?grant_type=password", body: ["email": email, "password": password])
    }

    func resetPassword(email: String) async throws {
        let _: EmptyResponse = try await request(path: "auth/v1/recover", body: ["email": email])
    }

    private func request<Response: Decodable, Body: Encodable>(path: String, body: Body) async throws -> Response {
        guard let url = URL(string: "\(projectURL)/\(path)") else { throw AuthError.unexpectedResponse }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(publishableKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(publishableKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw AuthError.unexpectedResponse }
        guard 200..<300 ~= httpResponse.statusCode else {
            let error = try? JSONDecoder().decode(SupabaseError.self, from: data)
            throw AuthError.message(error?.message ?? error?.errorDescription ?? error?.messageFromGoTrue ?? "Authentication failed. Please try again.")
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

struct AuthResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let user: AuthUser?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

struct AuthUser: Decodable {
    let email: String?
}

private struct SignUpRequest: Encodable {
    let email: String
    let password: String
    let data: [String: String]
}

private struct SupabaseError: Decodable {
    let message: String?
    let errorDescription: String?
    let messageFromGoTrue: String?

    enum CodingKeys: String, CodingKey {
        case message
        case errorDescription = "error_description"
        case messageFromGoTrue = "msg"
    }
}

private struct EmptyResponse: Decodable {}

enum AuthError: LocalizedError {
    case message(String)
    case unexpectedResponse

    var errorDescription: String? {
        switch self {
        case .message(let message): return message
        case .unexpectedResponse: return "The server sent an unexpected response. Please try again."
        }
    }
}

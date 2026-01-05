import Foundation

/// API error types
enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case notFound
    case rateLimited
    case serverError
    case offline

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .notFound:
            return "Resource not found"
        case .rateLimited:
            return "Too many requests. Please try again later."
        case .serverError:
            return "Server error. Please try again later."
        case .offline:
            return "No internet connection"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .offline:
            return "Check your internet connection and try again."
        case .rateLimited:
            return "Wait a few moments before making another request."
        case .serverError:
            return "The server is experiencing issues. Please try again later."
        default:
            return "Please try again."
        }
    }
}

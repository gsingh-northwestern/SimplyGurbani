import Foundation

/// Main API client for BaniDB
actor APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL = URL(string: "https://api.banidb.com/v2")!

    static let shared = APIClient()

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    // MARK: - Generic Request

    func request<T: Decodable>(_ endpoint: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    // Debug: print raw response for decoding errors
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Failed to decode response: \(jsonString.prefix(500))")
                    }
                    throw APIError.decodingError(error)
                }
            case 404:
                throw APIError.notFound
            case 429:
                throw APIError.rateLimited
            case 500...599:
                throw APIError.serverError
            default:
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Shabads

    func fetchShabad(id: Int) async throws -> ShabadResponse {
        try await request("shabads/\(id)")
    }

    func fetchRandomShabad(sourceID: String? = nil) async throws -> ShabadResponse {
        var queryItems: [URLQueryItem]? = nil
        if let sourceID {
            queryItems = [URLQueryItem(name: "source", value: sourceID)]
        }
        return try await request("random", queryItems: queryItems)
    }

    // MARK: - Banis

    func fetchBaniList() async throws -> [Bani] {
        try await request("banis")
    }

    func fetchBani(id: Int) async throws -> BaniResponse {
        try await request("banis/\(id)")
    }

    // MARK: - Hukamnama

    func fetchTodayHukamnama() async throws -> HukamnamaResponse {
        try await request("hukamnamas/today")
    }

    func fetchHukamnama(year: Int, month: Int, day: Int) async throws -> HukamnamaResponse {
        try await request("hukamnamas/\(year)/\(month)/\(day)")
    }

    // MARK: - Search

    func search(query: String, searchType: SearchType = .firstLetter) async throws -> SearchResponse {
        let queryItems = [
            URLQueryItem(name: "searchtype", value: String(searchType.rawValue))
        ]
        return try await request("search/\(query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? query)", queryItems: queryItems)
    }

    func searchByWriter(writerID: Int, sourceID: String = "G") async throws -> SearchResponse {
        let queryItems = [
            URLQueryItem(name: "writer", value: String(writerID)),
            URLQueryItem(name: "source", value: sourceID)
        ]
        return try await request("search/*", queryItems: queryItems)
    }

    // MARK: - Angs (Pages)

    func fetchAng(number: Int, sourceID: String = "G") async throws -> ShabadResponse {
        let queryItems = [URLQueryItem(name: "source", value: sourceID)]
        return try await request("angs/\(number)", queryItems: queryItems)
    }
}

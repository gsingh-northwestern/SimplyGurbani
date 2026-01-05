import Foundation
import Observation

/// Main service for Gurbani data operations
@Observable
@MainActor
final class GurbaniService {
    private let apiClient: APIClient

    // Cached data
    private(set) var baniList: [Bani] = []
    private(set) var todayHukamnama: Hukamnama?

    // Loading states
    private(set) var isLoadingBanis = false
    private(set) var isLoadingHukamnama = false

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    // MARK: - Shabads

    func fetchShabad(id: Int) async throws -> Shabad {
        let response = try await apiClient.fetchShabad(id: id)
        return Shabad.from(response: response)
    }

    func fetchRandomShabad(sourceID: String? = nil) async throws -> Shabad {
        let response = try await apiClient.fetchRandomShabad(sourceID: sourceID)
        return Shabad.from(response: response)
    }

    // MARK: - Banis

    func fetchBaniList() async throws -> [Bani] {
        if !baniList.isEmpty {
            return baniList
        }

        isLoadingBanis = true
        defer { isLoadingBanis = false }

        let response = try await apiClient.fetchBaniList()
        let banis = response.values.sorted { $0.id < $1.id }
        baniList = banis
        return banis
    }

    func fetchBani(id: Int) async throws -> BaniContent {
        let response = try await apiClient.fetchBani(id: id)
        return response.toBaniContent()
    }

    // MARK: - Hukamnama

    func fetchTodayHukamnama() async throws -> Hukamnama {
        if let cached = todayHukamnama,
           Calendar.current.isDateInToday(cached.date) {
            return cached
        }

        isLoadingHukamnama = true
        defer { isLoadingHukamnama = false }

        let response = try await apiClient.fetchTodayHukamnama()
        let hukamnama = response.toHukamnama()
        todayHukamnama = hukamnama
        return hukamnama
    }

    // MARK: - Search

    func search(query: String, searchType: SearchType = .firstLetter) async throws -> [SearchResult] {
        let response = try await apiClient.search(query: query, searchType: searchType)
        return response.verses.map { $0.toSearchResult() }
    }

    // MARK: - Angs

    func fetchAng(number: Int, sourceID: String = "G") async throws -> Shabad {
        let response = try await apiClient.fetchAng(number: number, sourceID: sourceID)
        return Shabad.from(response: response)
    }
}

// MARK: - Shared Instance

extension GurbaniService {
    static let shared = GurbaniService()
}

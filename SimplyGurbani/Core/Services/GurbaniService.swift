import Foundation
import SwiftData
import Observation

/// Main service for Gurbani data operations with offline caching
@Observable
@MainActor
final class GurbaniService {
    private let apiClient: APIClient
    private var cacheService: CacheService?

    // In-memory cached data
    private(set) var baniList: [Bani] = []
    private(set) var todayHukamnama: Hukamnama?

    // Loading states
    private(set) var isLoadingBanis = false
    private(set) var isLoadingHukamnama = false

    // Offline mode
    private(set) var isOffline = false

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    /// Configure the cache service with a model context
    func configureCaching(with modelContext: ModelContext) {
        self.cacheService = CacheService(modelContext: modelContext)
        // Clean up expired cache on startup
        cacheService?.clearExpiredCache()
    }

    // MARK: - Shabads

    func fetchShabad(id: Int) async throws -> Shabad {
        // Try cache first
        if let cacheService,
           let cached = cacheService.getCachedShabad(id: id),
           let shabad = cacheService.shabadFromCache(cached) {
            // Return cached while refreshing in background
            Task {
                await refreshShabadInBackground(id: id)
            }
            return shabad
        }

        // Fetch from API
        do {
            let response = try await apiClient.fetchShabad(id: id)
            let shabad = Shabad.from(response: response)

            // Cache the result
            cacheService?.cacheShabad(shabad)
            isOffline = false

            return shabad
        } catch {
            isOffline = true

            // Try cache as fallback (even if expired)
            if let cacheService,
               let cached = cacheService.getCachedShabad(id: id, ignoreExpiration: true),
               let shabad = cacheService.shabadFromCache(cached) {
                return shabad
            }
            throw error
        }
    }

    private func refreshShabadInBackground(id: Int) async {
        do {
            let response = try await apiClient.fetchShabad(id: id)
            let shabad = Shabad.from(response: response)
            cacheService?.cacheShabad(shabad)
            isOffline = false
        } catch {
            // Silently fail - we already have cached data
        }
    }

    func fetchRandomShabad(sourceID: String? = nil) async throws -> Shabad {
        let response = try await apiClient.fetchRandomShabad(sourceID: sourceID)
        let shabad = Shabad.from(response: response)
        cacheService?.cacheShabad(shabad)
        return shabad
    }

    // MARK: - Banis

    func fetchBaniList() async throws -> [Bani] {
        if !baniList.isEmpty {
            return baniList
        }

        isLoadingBanis = true
        defer { isLoadingBanis = false }

        let banis = try await apiClient.fetchBaniList()
        baniList = banis.sorted { $0.id < $1.id }
        return baniList
    }

    func fetchBani(id: Int) async throws -> BaniContent {
        // Try cache first
        if let cacheService,
           let cached = cacheService.getCachedBani(id: id),
           let bani = cacheService.baniFromCache(cached) {
            // Return cached while refreshing in background
            Task {
                await refreshBaniInBackground(id: id)
            }
            return bani
        }

        // Fetch from API
        do {
            let response = try await apiClient.fetchBani(id: id)
            let bani = response.toBaniContent()

            // Cache the result
            cacheService?.cacheBani(bani)
            isOffline = false

            return bani
        } catch {
            isOffline = true

            // Try cache as fallback (even if expired)
            if let cacheService,
               let cached = cacheService.getCachedBani(id: id, ignoreExpiration: true),
               let bani = cacheService.baniFromCache(cached) {
                return bani
            }
            throw error
        }
    }

    private func refreshBaniInBackground(id: Int) async {
        do {
            let response = try await apiClient.fetchBani(id: id)
            let bani = response.toBaniContent()
            cacheService?.cacheBani(bani)
            isOffline = false
        } catch {
            // Silently fail
        }
    }

    // MARK: - Hukamnama

    func fetchTodayHukamnama() async throws -> Hukamnama {
        // Check in-memory cache
        if let cached = todayHukamnama,
           Calendar.current.isDateInToday(cached.date) {
            return cached
        }

        // Check persistent cache
        if let cacheService,
           let cached = cacheService.getCachedHukamnama(for: Date()) {
            let hukamnama = cached.toHukamnama()
            todayHukamnama = hukamnama

            // Refresh in background
            Task {
                await refreshHukamnamaInBackground()
            }
            return hukamnama
        }

        isLoadingHukamnama = true
        defer { isLoadingHukamnama = false }

        // Fetch from API
        do {
            let response = try await apiClient.fetchTodayHukamnama()
            let hukamnama = response.toHukamnama()
            todayHukamnama = hukamnama
            isOffline = false

            // Cache it
            cacheService?.cacheHukamnama(hukamnama)

            return hukamnama
        } catch {
            isOffline = true

            // Try yesterday's hukamnama as fallback
            if let cacheService {
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                if let cached = cacheService.getCachedHukamnama(for: yesterday) {
                    return cached.toHukamnama()
                }
            }
            throw error
        }
    }

    private func refreshHukamnamaInBackground() async {
        do {
            let response = try await apiClient.fetchTodayHukamnama()
            let hukamnama = response.toHukamnama()
            todayHukamnama = hukamnama
            cacheService?.cacheHukamnama(hukamnama)
            isOffline = false
        } catch {
            // Silently fail
        }
    }

    // MARK: - Search

    func search(query: String, searchType: SearchType = .firstLetter) async throws -> [SearchResult] {
        // Search doesn't use caching - always fresh
        let response = try await apiClient.search(query: query, searchType: searchType)
        return response.verses.map { $0.toSearchResult() }
    }

    func searchByWriter(writerID: Int, sourceID: String = "G") async throws -> [SearchResult] {
        let response = try await apiClient.searchByWriter(writerID: writerID, sourceID: sourceID)
        return response.verses.map { $0.toSearchResult() }
    }

    // MARK: - Angs

    func fetchAng(number: Int, sourceID: String = "G") async throws -> Shabad {
        let response = try await apiClient.fetchAng(number: number, sourceID: sourceID)
        let shabad = response.toShabad()
        cacheService?.cacheShabad(shabad)
        return shabad
    }

    // MARK: - Cache Management

    func clearCache() {
        cacheService?.clearAllCache()
        baniList = []
        todayHukamnama = nil
    }

    var cacheStats: (shabads: Int, banis: Int, hukamnamas: Int)? {
        cacheService?.cacheStats
    }
}

// MARK: - Shared Instance

extension GurbaniService {
    static let shared = GurbaniService()
}

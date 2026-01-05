import Foundation
import Observation

@Observable
@MainActor
final class SearchViewModel {
    private let gurbaniService: GurbaniService

    // State
    private(set) var results: [SearchResult] = []
    private(set) var isSearching = false
    private(set) var error: APIError?
    private(set) var hasSearched = false

    // Query
    var searchText = ""
    var searchType: SearchType = .firstLetter

    // History
    private(set) var searchHistory: [String] = []

    init(gurbaniService: GurbaniService = .shared) {
        self.gurbaniService = gurbaniService
        loadSearchHistory()
    }

    func search() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty, !isSearching else { return }

        isSearching = true
        error = nil
        hasSearched = true

        do {
            results = try await gurbaniService.search(query: query, searchType: searchType)
            addToHistory(query)
        } catch let apiError as APIError {
            error = apiError
            results = []
        } catch {
            self.error = .networkError(error)
            results = []
        }

        isSearching = false
    }

    func clearResults() {
        results = []
        hasSearched = false
        error = nil
    }

    // MARK: - History

    private func loadSearchHistory() {
        searchHistory = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    }

    private func addToHistory(_ query: String) {
        var history = searchHistory
        history.removeAll { $0.lowercased() == query.lowercased() }
        history.insert(query, at: 0)
        if history.count > 10 {
            history = Array(history.prefix(10))
        }
        searchHistory = history
        UserDefaults.standard.set(history, forKey: "searchHistory")
    }

    func clearHistory() {
        searchHistory = []
        UserDefaults.standard.removeObject(forKey: "searchHistory")
    }

    func selectFromHistory(_ query: String) {
        searchText = query
        Task { await search() }
    }
}

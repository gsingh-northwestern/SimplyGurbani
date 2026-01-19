import Foundation
import Observation

@Observable
@MainActor
final class SearchViewModel {
    private let gurbaniService: GurbaniService

    // State
    private(set) var baniResults: [Bani] = []
    private(set) var verseResults: [SearchResult] = []
    private(set) var isSearching = false
    private(set) var error: APIError?
    private(set) var hasSearched = false

    // Query
    var searchText = ""

    // Bani cache for local search
    private var allBanis: [Bani] = []

    // History
    private(set) var searchHistory: [String] = []

    var hasResults: Bool {
        !baniResults.isEmpty || !verseResults.isEmpty
    }

    var totalResultCount: Int {
        baniResults.count + verseResults.count
    }

    init(gurbaniService: GurbaniService = .shared) {
        self.gurbaniService = gurbaniService
        loadSearchHistory()
        Task { await loadBanis() }
    }

    private func loadBanis() async {
        do {
            allBanis = try await gurbaniService.fetchBaniList()
        } catch {
            // Silently fail - banis just won't be searchable locally
        }
    }

    private func determineSearchType(for query: String) -> SearchType {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        // If purely numeric, use ang search
        if trimmed.allSatisfy({ $0.isNumber }) {
            return .angSearch
        }
        // Otherwise use romanized (English text) search
        return .romanized
    }

    private func searchBanis(query: String) -> [Bani] {
        let q = query.lowercased()
        return allBanis.filter { bani in
            bani.displayName.lowercased().contains(q) ||
            (bani.transliteration?.lowercased().contains(q) ?? false)
        }
    }

    func search() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty, !isSearching else { return }

        isSearching = true
        error = nil
        hasSearched = true
        baniResults = []
        verseResults = []

        // Determine search type automatically
        let searchType = determineSearchType(for: query)

        // If numeric query, only do ang search (no bani search)
        if searchType == .angSearch {
            do {
                verseResults = try await gurbaniService.search(query: query, searchType: searchType)
                addToHistory(query)
            } catch let apiError as APIError {
                error = apiError
            } catch {
                self.error = .networkError(error)
            }
        } else {
            // Non-numeric: search banis locally AND verses via API
            baniResults = searchBanis(query: query)

            do {
                verseResults = try await gurbaniService.search(query: query, searchType: .fullWordAnywhere)
                addToHistory(query)
            } catch let apiError as APIError {
                error = apiError
            } catch {
                self.error = .networkError(error)
            }
        }

        isSearching = false
    }

    func clearResults() {
        baniResults = []
        verseResults = []
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

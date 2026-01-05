import Testing
import Foundation
@testable import SimplyGurbani

// MARK: - Test Data

struct TestData {
    static let sampleVerse = Verse(
        id: 1,
        shabadID: 1,
        gurmukhi: "jpu",
        gurmukhiUnicode: "ਜਪੁ",
        larivaar: nil,
        larivaarUnicode: nil,
        transliteration: "japu",
        translation: "Chant",
        sourceID: "G",
        ang: 1
    )

    static let sampleShabad = Shabad(
        id: 1,
        sourceID: "G",
        sourceName: "Sri Guru Granth Sahib",
        ang: 1,
        writer: Writer(id: 1, gurmukhi: "mÚ 1", gurmukhiUnicode: "ਮਃ ੧", english: "Guru Nanak Dev Ji"),
        raag: Raag(id: 1, gurmukhi: "rwgu sohI", gurmukhiUnicode: "ਰਾਗੁ ਸੋਹੀ", english: "Raag Sohi"),
        verses: [sampleVerse]
    )

    static let sampleBani = Bani(
        id: 1,
        gurmukhi: "jpujI swihb",
        gurmukhiUnicode: "ਜਪੁਜੀ ਸਾਹਿਬ",
        transliteration: "Japji Sahib",
        english: "Japji Sahib"
    )

    static let sampleBaniContent = BaniContent(
        id: 1,
        name: "Japji Sahib",
        nameUnicode: "ਜਪੁਜੀ ਸਾਹਿਬ",
        transliteration: "Japji Sahib",
        verses: [sampleVerse]
    )

    static let sampleHukamnama = Hukamnama(
        date: Date(),
        ang: 1,
        gurmukhi: "ਸੋਹਿਲਾ",
        transliteration: "sohila",
        translation: "Song of Praise",
        shabadID: 1
    )

    static let sampleSearchResult = SearchResult(
        id: 1,
        shabadID: 1,
        gurmukhi: "jpu",
        gurmukhiUnicode: "ਜਪੁ",
        transliteration: "japu",
        translation: "Chant",
        ang: 1,
        sourceID: "G",
        writerID: nil,
        raagID: nil
    )
}

// MARK: - HomeViewModel Tests

@Suite("HomeViewModel Tests")
struct HomeViewModelTests {

    @Test("Initial state is correct")
    @MainActor
    func initialState() {
        let viewModel = HomeViewModel()

        #expect(viewModel.hukamnama == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }
}

// MARK: - SearchViewModel Tests

@Suite("SearchViewModel Tests")
struct SearchViewModelTests {

    @Test("Initial state is correct")
    @MainActor
    func initialState() {
        let viewModel = SearchViewModel()

        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.results.isEmpty)
        #expect(viewModel.isSearching == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.searchType == .firstLetter)
        #expect(viewModel.hasSearched == false)
    }

    @Test("Clear results resets state")
    @MainActor
    func clearResults() {
        let viewModel = SearchViewModel()
        viewModel.searchText = "test"

        viewModel.clearResults()

        #expect(viewModel.results.isEmpty)
        #expect(viewModel.hasSearched == false)
        #expect(viewModel.error == nil)
    }

    @Test("Search type changes correctly")
    @MainActor
    func searchTypeChange() {
        let viewModel = SearchViewModel()

        viewModel.searchType = .fullWord
        #expect(viewModel.searchType == .fullWord)

        viewModel.searchType = .romanized
        #expect(viewModel.searchType == .romanized)
    }

    @Test("Clear history removes all items")
    @MainActor
    func clearHistory() {
        let viewModel = SearchViewModel()

        viewModel.clearHistory()

        #expect(viewModel.searchHistory.isEmpty)
    }
}

// MARK: - ReaderViewModel Tests

@Suite("ReaderViewModel Tests")
struct ReaderViewModelTests {

    @Test("Initial state is correct")
    @MainActor
    func initialState() {
        let viewModel = ReaderViewModel()

        #expect(viewModel.shabad == nil)
        #expect(viewModel.baniContent == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.showGurmukhi == true)
        #expect(viewModel.showTransliteration == true)
        #expect(viewModel.showTranslation == true)
        #expect(viewModel.useLarivaar == false)
    }

    @Test("Verses returns empty when no content")
    @MainActor
    func versesEmpty() {
        let viewModel = ReaderViewModel()

        #expect(viewModel.verses.isEmpty)
    }

    @Test("Title shows loading when no content")
    @MainActor
    func titleLoading() {
        let viewModel = ReaderViewModel()

        #expect(viewModel.title == "Loading...")
    }

    @Test("Share text is empty when no content")
    @MainActor
    func shareTextEmpty() {
        let viewModel = ReaderViewModel()

        let text = viewModel.shareText()

        #expect(text.isEmpty)
    }

    @Test("First verse bookmark check returns false when empty")
    @MainActor
    func firstVerseBookmark() {
        let viewModel = ReaderViewModel()

        #expect(viewModel.isFirstVerseBookmarked == false)
    }

    @Test("Display settings can be toggled")
    @MainActor
    func toggleDisplaySettings() {
        let viewModel = ReaderViewModel()

        viewModel.showGurmukhi = false
        #expect(viewModel.showGurmukhi == false)

        viewModel.showTransliteration = false
        #expect(viewModel.showTransliteration == false)

        viewModel.useLarivaar = true
        #expect(viewModel.useLarivaar == true)
    }
}

// MARK: - BookmarksViewModel Tests

@Suite("BookmarksViewModel Tests")
struct BookmarksViewModelTests {

    @Test("Initial state is correct")
    @MainActor
    func initialState() {
        let viewModel = BookmarksViewModel()

        #expect(viewModel.bookmarks.isEmpty)
        #expect(viewModel.folders.isEmpty)
        #expect(viewModel.selectedFolder == nil)
    }
}

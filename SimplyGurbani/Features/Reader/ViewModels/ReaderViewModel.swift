import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class ReaderViewModel {
    private let gurbaniService: GurbaniService
    private var bookmarkService: BookmarkService?

    // Content
    private(set) var shabad: Shabad?
    private(set) var baniContent: BaniContent?

    // State
    private(set) var isLoading = false
    private(set) var error: APIError?

    // Bookmark state
    private(set) var bookmarkedVerseIDs: Set<Int> = []
    var selectedVerseForBookmark: Verse?
    var isShowingBookmarkSheet = false

    // Display settings
    var showGurmukhi = true
    var showTransliteration = true
    var showTranslation = true
    var useLarivaar = false

    init(gurbaniService: GurbaniService = .shared) {
        self.gurbaniService = gurbaniService
    }

    func configureBookmarks(with modelContext: ModelContext) {
        self.bookmarkService = BookmarkService(modelContext: modelContext)
        refreshBookmarkStatus()
    }

    // MARK: - Load Shabad

    func loadShabad(id: Int) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            shabad = try await gurbaniService.fetchShabad(id: id)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    // MARK: - Load Bani

    func loadBani(id: Int) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            baniContent = try await gurbaniService.fetchBani(id: id)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    // MARK: - Computed Properties

    var verses: [Verse] {
        if let shabad {
            return shabad.verses
        } else if let bani = baniContent {
            return bani.verses
        }
        return []
    }

    var title: String {
        if let shabad {
            return "Ang \(shabad.ang)"
        } else if let bani = baniContent {
            // Prefer English transliteration for nav title, fallback to Unicode
            return bani.transliteration ?? bani.nameUnicode
        }
        return "Loading..."
    }

    var subtitle: String? {
        if let shabad {
            return shabad.sourceName
        } else if let bani = baniContent {
            return bani.transliteration
        }
        return nil
    }

    // MARK: - Share

    func shareText() -> String {
        var content = ""

        for verse in verses {
            content += verse.gurmukhiUnicode + "\n"
            if showTransliteration, let translit = verse.transliteration {
                content += translit + "\n"
            }
            if showTranslation, let translation = verse.translation {
                content += translation + "\n"
            }
            content += "\n"
        }

        if let shabad {
            content += "- \(shabad.sourceName), Ang \(shabad.ang)"
        } else if let bani = baniContent {
            content += "- \(bani.name)"
        }

        return content
    }

    // MARK: - Bookmarks

    func refreshBookmarkStatus() {
        guard let service = bookmarkService else { return }
        bookmarkedVerseIDs = Set(verses.filter { service.isBookmarked(verseID: $0.id) }.map { $0.id })
    }

    func isVerseBookmarked(_ verse: Verse) -> Bool {
        bookmarkedVerseIDs.contains(verse.id)
    }

    func toggleBookmark(for verse: Verse) {
        guard let service = bookmarkService else { return }

        if isVerseBookmarked(verse) {
            service.removeBookmark(verseID: verse.id)
            bookmarkedVerseIDs.remove(verse.id)
        } else {
            service.bookmarkVerse(verse)
            bookmarkedVerseIDs.insert(verse.id)
        }
    }

    func bookmarkVerse(_ verse: Verse, folderName: String? = nil, notes: String? = nil) {
        guard let service = bookmarkService else { return }
        service.bookmarkVerse(verse, folderName: folderName, notes: notes)
        bookmarkedVerseIDs.insert(verse.id)
    }

    var bookmarkFolders: [BookmarkFolder] {
        bookmarkService?.getAllFolders() ?? []
    }

    /// Bookmark the first verse of the shabad (quick bookmark)
    func bookmarkFirstVerse() {
        guard let verse = verses.first else { return }
        toggleBookmark(for: verse)
    }

    var isFirstVerseBookmarked: Bool {
        guard let verse = verses.first else { return false }
        return isVerseBookmarked(verse)
    }
}

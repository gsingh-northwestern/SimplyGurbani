import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class ReaderViewModel {
    private let gurbaniService: GurbaniService
    private var bookmarkService: BookmarkService?
    private var readingPositionService: ReadingPositionService?

    // Content
    private(set) var shabad: Shabad?
    private(set) var baniContent: BaniContent?

    // Ang navigation state
    private(set) var currentAngNumber: Int?
    private(set) var currentSourceID: String?

    // State
    private(set) var isLoading = false
    private(set) var error: APIError?

    // Bookmark state
    private(set) var bookmarkedVerseIDs: Set<Int> = []
    var selectedVerseForBookmark: Verse?
    var isShowingBookmarkSheet = false

    // Scroll tracking
    private(set) var scrollPosition: Int?  // Current top verse ID

    init(gurbaniService: GurbaniService = .shared) {
        self.gurbaniService = gurbaniService
    }

    func configureBookmarks(with modelContext: ModelContext) {
        self.bookmarkService = BookmarkService(modelContext: modelContext)
        refreshBookmarkStatus()
    }

    func configureReadingPosition(with modelContext: ModelContext) {
        self.readingPositionService = ReadingPositionService(modelContext: modelContext)
    }

    // MARK: - Reading Position Management

    /// Get saved scroll position for current content
    func getSavedScrollPosition() -> Int? {
        guard let service = readingPositionService else { return nil }

        if let shabad = shabad {
            return service.getPosition(contentType: "shabad", contentID: shabad.id)?.topVisibleVerseID
        } else if let bani = baniContent {
            return service.getPosition(contentType: "bani", contentID: bani.id)?.topVisibleVerseID
        } else if let angNum = currentAngNumber {
            return service.getPosition(contentType: "ang", contentID: angNum, sourceID: currentSourceID ?? "G")?.topVisibleVerseID
        }
        return nil
    }

    /// Save current scroll position
    func saveScrollPosition(_ verseID: Int) {
        guard let service = readingPositionService else { return }

        self.scrollPosition = verseID

        // Get the verse for preview
        guard let verse = verses.first(where: { $0.id == verseID }) else { return }

        if let shabad = shabad {
            service.savePosition(
                contentType: "shabad",
                contentID: shabad.id,
                topVisibleVerseID: verseID,
                displayName: title,
                gurmukhiPreview: verse.gurmukhiUnicode,
                transliterationPreview: verse.transliteration
            )
        } else if let bani = baniContent {
            service.savePosition(
                contentType: "bani",
                contentID: bani.id,
                topVisibleVerseID: verseID,
                displayName: title,
                gurmukhiPreview: verse.gurmukhiUnicode,
                transliterationPreview: verse.transliteration
            )
        } else if let angNum = currentAngNumber {
            service.savePosition(
                contentType: "ang",
                contentID: angNum,
                sourceID: currentSourceID ?? "G",
                topVisibleVerseID: verseID,
                displayName: title,
                gurmukhiPreview: verse.gurmukhiUnicode,
                transliterationPreview: verse.transliteration
            )
        }
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

    // MARK: - Load Ang

    func loadAng(number: Int, sourceID: String = "G") async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        currentAngNumber = number
        currentSourceID = sourceID

        do {
            shabad = try await gurbaniService.fetchAng(number: number, sourceID: sourceID)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    // MARK: - Ang Navigation

    var canGoToPreviousAng: Bool {
        guard let ang = currentAngNumber else { return false }
        return ang > 1
    }

    var canGoToNextAng: Bool {
        guard let ang = currentAngNumber else { return false }
        let maxAng = currentSourceID == "G" ? 1430 : 1428
        return ang < maxAng
    }

    func goToPreviousAng() async {
        guard canGoToPreviousAng, let ang = currentAngNumber, let source = currentSourceID else { return }
        await loadAng(number: ang - 1, sourceID: source)
    }

    func goToNextAng() async {
        guard canGoToNextAng, let ang = currentAngNumber, let source = currentSourceID else { return }
        await loadAng(number: ang + 1, sourceID: source)
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
            // Use proper capitalized name for well-known banis
            if let wellKnownBani = WellKnownBani(rawValue: bani.id) {
                return wellKnownBani.displayName
            }
            // Fall back to transliteration or Unicode name for other banis
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

    func shareText(showTransliteration: Bool, showTranslation: Bool) -> String {
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
            // Pass baniID if we're viewing a bani
            service.bookmarkVerse(verse, baniID: baniContent?.id)
            bookmarkedVerseIDs.insert(verse.id)
        }
    }

    func bookmarkVerse(_ verse: Verse, folderName: String? = nil, notes: String? = nil) {
        guard let service = bookmarkService else { return }
        // Pass baniID if we're viewing a bani
        service.bookmarkVerse(verse, baniID: baniContent?.id, folderName: folderName, notes: notes)
        bookmarkedVerseIDs.insert(verse.id)
    }

    var bookmarkFolders: [BookmarkFolder] {
        bookmarkService?.getAllFolders() ?? []
    }

    /// Bookmark the currently visible top verse (tile-based bookmarking)
    func bookmarkTopVerse() {
        guard let service = bookmarkService else { return }

        // Use the currently tracked scroll position
        let verseID = scrollPosition ?? verses.first?.id
        guard let verseID = verseID,
              let verse = verses.first(where: { $0.id == verseID }) else {
            // Fallback to first verse if position unknown
            guard let firstVerse = verses.first else { return }
            toggleBookmark(for: firstVerse)
            return
        }

        toggleBookmark(for: verse)
    }

    /// Bookmark the first verse of the shabad (quick bookmark) - redirects to tile-based bookmarking
    func bookmarkFirstVerse() {
        bookmarkTopVerse()
    }

    /// Check if the topmost visible verse is bookmarked
    var isTopVerseBookmarked: Bool {
        let verseID = scrollPosition ?? verses.first?.id
        guard let verseID = verseID else { return false }
        return bookmarkedVerseIDs.contains(verseID)
    }

    /// Legacy property for backwards compatibility
    var isFirstVerseBookmarked: Bool {
        isTopVerseBookmarked
    }
}

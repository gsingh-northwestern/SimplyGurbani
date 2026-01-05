import Testing
import Foundation
import SwiftData
@testable import SimplyGurbani

// MARK: - CacheService Tests

@Suite("CacheService Tests")
struct CacheServiceTests {

    @Test("Cache shabad and retrieve")
    @MainActor
    func cacheAndRetrieveShabad() throws {
        // Create in-memory model container
        let schema = Schema([
            CachedShabad.self,
            CachedBani.self,
            CachedHukamnama.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let cacheService = CacheService(modelContext: context)

        // Create test shabad
        let verse = Verse(
            id: 1,
            shabadID: 100,
            gurmukhi: "jpu",
            gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil,
            larivaarUnicode: nil,
            transliteration: "japu",
            translation: "Chant",
            sourceID: "G",
            ang: 1
        )

        let shabad = Shabad(
            id: 100,
            sourceID: "G",
            sourceName: "Sri Guru Granth Sahib",
            ang: 1,
            writer: nil,
            raag: nil,
            verses: [verse]
        )

        // Cache the shabad
        cacheService.cacheShabad(shabad)

        // Retrieve it
        let cached = cacheService.getCachedShabad(id: 100)
        #expect(cached != nil)
        #expect(cached?.shabadID == 100)

        // Convert back to Shabad
        if let cached = cached {
            let retrieved = cacheService.shabadFromCache(cached)
            #expect(retrieved != nil)
            #expect(retrieved?.id == 100)
            #expect(retrieved?.verses.count == 1)
            #expect(retrieved?.verses.first?.gurmukhiUnicode == "ਜਪੁ")
        }
    }

    @Test("Cache bani and retrieve")
    @MainActor
    func cacheAndRetrieveBani() throws {
        let schema = Schema([
            CachedShabad.self,
            CachedBani.self,
            CachedHukamnama.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let cacheService = CacheService(modelContext: context)

        let verse = Verse(
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

        let bani = BaniContent(
            id: 1,
            name: "Japji Sahib",
            nameUnicode: "ਜਪੁਜੀ ਸਾਹਿਬ",
            transliteration: "Japji Sahib",
            verses: [verse]
        )

        cacheService.cacheBani(bani)

        let cached = cacheService.getCachedBani(id: 1)
        #expect(cached != nil)
        #expect(cached?.baniID == 1)

        if let cached = cached {
            let retrieved = cacheService.baniFromCache(cached)
            #expect(retrieved != nil)
            #expect(retrieved?.name == "Japji Sahib")
        }
    }

    @Test("Cache hukamnama and retrieve")
    @MainActor
    func cacheAndRetrieveHukamnama() throws {
        let schema = Schema([
            CachedShabad.self,
            CachedBani.self,
            CachedHukamnama.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let cacheService = CacheService(modelContext: context)

        let hukamnama = Hukamnama(
            date: Date(),
            ang: 1,
            gurmukhi: "ਸੋਹਿਲਾ",
            transliteration: "sohila",
            translation: "Song of Praise",
            shabadID: 1
        )

        cacheService.cacheHukamnama(hukamnama)

        let cached = cacheService.getCachedHukamnama(for: Date())
        #expect(cached != nil)
        #expect(cached?.ang == 1)
    }

    @Test("Cache stats returns correct counts")
    @MainActor
    func cacheStats() throws {
        let schema = Schema([
            CachedShabad.self,
            CachedBani.self,
            CachedHukamnama.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let cacheService = CacheService(modelContext: context)

        let stats = cacheService.cacheStats
        #expect(stats.shabads == 0)
        #expect(stats.banis == 0)
        #expect(stats.hukamnamas == 0)
    }

    @Test("Clear all cache removes all items")
    @MainActor
    func clearAllCache() throws {
        let schema = Schema([
            CachedShabad.self,
            CachedBani.self,
            CachedHukamnama.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let cacheService = CacheService(modelContext: context)

        // Add some data
        let verse = Verse(
            id: 1, shabadID: 1, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )
        let shabad = Shabad(
            id: 1, sourceID: "G", sourceName: "SGGS", ang: 1,
            writer: nil, raag: nil, verses: [verse]
        )
        cacheService.cacheShabad(shabad)

        // Clear
        cacheService.clearAllCache()

        // Verify empty
        let stats = cacheService.cacheStats
        #expect(stats.shabads == 0)
    }

    @Test("Ignore expiration returns expired items")
    @MainActor
    func ignoreExpiration() throws {
        let schema = Schema([
            CachedShabad.self,
            CachedBani.self,
            CachedHukamnama.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let cacheService = CacheService(modelContext: context)

        // Create and cache a shabad
        let verse = Verse(
            id: 1, shabadID: 1, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )
        let shabad = Shabad(
            id: 1, sourceID: "G", sourceName: "SGGS", ang: 1,
            writer: nil, raag: nil, verses: [verse]
        )
        cacheService.cacheShabad(shabad)

        // Manually expire it
        let descriptor = FetchDescriptor<CachedShabad>()
        if let cached = try? context.fetch(descriptor).first {
            cached.expiresAt = Date().addingTimeInterval(-1) // Expired
            try? context.save()
        }

        // Normal fetch should return nil
        let normalFetch = cacheService.getCachedShabad(id: 1)
        #expect(normalFetch == nil)

        // Fetch with ignoreExpiration should return it
        let expiredFetch = cacheService.getCachedShabad(id: 1, ignoreExpiration: true)
        #expect(expiredFetch != nil)
    }
}

// MARK: - BookmarkService Tests

@Suite("BookmarkService Tests")
struct BookmarkServiceTests {

    @Test("Bookmark verse and check status")
    @MainActor
    func bookmarkVerse() throws {
        let schema = Schema([
            BookmarkedVerse.self,
            BookmarkFolder.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let bookmarkService = BookmarkService(modelContext: context)

        let verse = Verse(
            id: 1, shabadID: 100, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )

        // Initially not bookmarked
        #expect(bookmarkService.isBookmarked(verseID: 1) == false)

        // Bookmark it
        bookmarkService.bookmarkVerse(verse)

        // Now should be bookmarked
        #expect(bookmarkService.isBookmarked(verseID: 1) == true)
    }

    @Test("Remove bookmark")
    @MainActor
    func removeBookmark() throws {
        let schema = Schema([
            BookmarkedVerse.self,
            BookmarkFolder.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let bookmarkService = BookmarkService(modelContext: context)

        let verse = Verse(
            id: 1, shabadID: 100, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )

        bookmarkService.bookmarkVerse(verse)
        #expect(bookmarkService.isBookmarked(verseID: 1) == true)

        bookmarkService.removeBookmark(verseID: 1)
        #expect(bookmarkService.isBookmarked(verseID: 1) == false)
    }

    @Test("Create and delete folder")
    @MainActor
    func createAndDeleteFolder() throws {
        let schema = Schema([
            BookmarkedVerse.self,
            BookmarkFolder.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let bookmarkService = BookmarkService(modelContext: context)

        // Create folder
        bookmarkService.createFolder(name: "Favorites")

        // Get all folders
        let folders = bookmarkService.getAllFolders()
        #expect(folders.count == 1)
        #expect(folders.first?.name == "Favorites")

        // Delete folder
        bookmarkService.deleteFolder(name: "Favorites")
        let foldersAfter = bookmarkService.getAllFolders()
        #expect(foldersAfter.isEmpty)
    }

    @Test("Bookmark with folder")
    @MainActor
    func bookmarkWithFolder() throws {
        let schema = Schema([
            BookmarkedVerse.self,
            BookmarkFolder.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let bookmarkService = BookmarkService(modelContext: context)

        let verse = Verse(
            id: 1, shabadID: 100, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )

        bookmarkService.bookmarkVerse(verse, folderName: "Daily", notes: "Morning prayer")

        let bookmarks = bookmarkService.getAllBookmarks()
        #expect(bookmarks.count == 1)
        #expect(bookmarks.first?.folderName == "Daily")
        #expect(bookmarks.first?.notes == "Morning prayer")
    }

    @Test("Get bookmarks in folder")
    @MainActor
    func getBookmarksInFolder() throws {
        let schema = Schema([
            BookmarkedVerse.self,
            BookmarkFolder.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let bookmarkService = BookmarkService(modelContext: context)

        let verse1 = Verse(
            id: 1, shabadID: 100, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )
        let verse2 = Verse(
            id: 2, shabadID: 101, gurmukhi: "mUl", gurmukhiUnicode: "ਮੂਲ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "mool",
            translation: "Root", sourceID: "G", ang: 2
        )

        bookmarkService.bookmarkVerse(verse1, folderName: "Daily")
        bookmarkService.bookmarkVerse(verse2, folderName: "Study")

        let dailyBookmarks = bookmarkService.getBookmarks(in: "Daily")
        #expect(dailyBookmarks.count == 1)

        let allBookmarks = bookmarkService.getAllBookmarks()
        #expect(allBookmarks.count == 2)
    }

    @Test("Bookmark count")
    @MainActor
    func bookmarkCount() throws {
        let schema = Schema([
            BookmarkedVerse.self,
            BookmarkFolder.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let bookmarkService = BookmarkService(modelContext: context)

        #expect(bookmarkService.bookmarkCount == 0)

        let verse = Verse(
            id: 1, shabadID: 100, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )

        bookmarkService.bookmarkVerse(verse)
        #expect(bookmarkService.bookmarkCount == 1)
    }
}

// MARK: - Model Tests

@Suite("Model Tests")
struct ModelTests {

    @Test("Verse creation")
    func verseCreation() {
        let verse = Verse(
            id: 1,
            shabadID: 100,
            gurmukhi: "jpu",
            gurmukhiUnicode: "ਜਪੁ",
            larivaar: "jpu",
            larivaarUnicode: "ਜਪੁ",
            transliteration: "japu",
            translation: "Chant",
            sourceID: "G",
            ang: 1
        )

        #expect(verse.id == 1)
        #expect(verse.shabadID == 100)
        #expect(verse.gurmukhiUnicode == "ਜਪੁ")
        #expect(verse.ang == 1)
    }

    @Test("Shabad creation")
    func shabadCreation() {
        let verse = Verse(
            id: 1, shabadID: 1, gurmukhi: "jpu", gurmukhiUnicode: "ਜਪੁ",
            larivaar: nil, larivaarUnicode: nil, transliteration: "japu",
            translation: "Chant", sourceID: "G", ang: 1
        )

        let writer = Writer(id: 1, gurmukhi: "mÚ 1", gurmukhiUnicode: "ਮਃ ੧", english: "Guru Nanak Dev Ji")
        let raag = Raag(id: 1, gurmukhi: "rwgu sohI", gurmukhiUnicode: "ਰਾਗੁ ਸੋਹੀ", english: "Raag Sohi")

        let shabad = Shabad(
            id: 1,
            sourceID: "G",
            sourceName: "Sri Guru Granth Sahib",
            ang: 1,
            writer: writer,
            raag: raag,
            verses: [verse]
        )

        #expect(shabad.id == 1)
        #expect(shabad.sourceName == "Sri Guru Granth Sahib")
        #expect(shabad.writer?.english == "Guru Nanak Dev Ji")
        #expect(shabad.raag?.english == "Raag Sohi")
        #expect(shabad.verses.count == 1)
    }

    @Test("Hukamnama creation")
    func hukamnamaCreation() {
        let date = Date()
        let hukamnama = Hukamnama(
            date: date,
            ang: 42,
            gurmukhi: "ਸੋਹਿਲਾ",
            transliteration: "sohila",
            translation: "Song of Praise",
            shabadID: 100
        )

        #expect(hukamnama.date == date)
        #expect(hukamnama.ang == 42)
        #expect(hukamnama.shabadID == 100)
    }

    @Test("SearchResult creation")
    func searchResultCreation() {
        let result = SearchResult(
            id: 1,
            shabadID: 100,
            gurmukhi: "jpu",
            gurmukhiUnicode: "ਜਪੁ",
            transliteration: "japu",
            translation: "Chant",
            ang: 1,
            sourceID: "G",
            writerID: nil,
            raagID: nil
        )

        #expect(result.id == 1)
        #expect(result.shabadID == 100)
        #expect(result.ang == 1)
    }

    @Test("Bani creation")
    func baniCreation() {
        let bani = Bani(
            id: 1,
            gurmukhi: "jpujI swihb",
            gurmukhiUnicode: "ਜਪੁਜੀ ਸਾਹਿਬ",
            transliteration: "Japji Sahib",
            english: "Japji Sahib"
        )

        #expect(bani.id == 1)
        #expect(bani.english == "Japji Sahib")
    }
}

// MARK: - SearchType Tests

@Suite("SearchType Tests")
struct SearchTypeTests {

    @Test("Search type raw values")
    func searchTypeRawValues() {
        #expect(SearchType.firstLetter.rawValue == 0)
        #expect(SearchType.fullWord.rawValue == 2)
        #expect(SearchType.romanized.rawValue == 4)
    }

    @Test("Search type display names")
    func searchTypeDisplayNames() {
        #expect(SearchType.firstLetter.displayName == "First Letter")
        #expect(SearchType.fullWord.displayName == "Full Word")
        #expect(SearchType.romanized.displayName == "Romanized")
    }
}

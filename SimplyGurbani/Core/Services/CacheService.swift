import Foundation
import SwiftData

/// Service for caching Gurbani content using SwiftData
@MainActor
final class CacheService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Shabad Caching

    func getCachedShabad(id: Int, ignoreExpiration: Bool = false) -> CachedShabad? {
        let descriptor = FetchDescriptor<CachedShabad>(
            predicate: #Predicate { $0.shabadID == id }
        )
        guard let cached = try? modelContext.fetch(descriptor).first else {
            return nil
        }
        // Return expired items only if ignoreExpiration is true (used for offline fallback)
        if !ignoreExpiration && cached.isExpired {
            return nil
        }
        return cached
    }

    func cacheShabad(_ shabad: Shabad) {
        // Encode verses to JSON
        let encoder = JSONEncoder()
        guard let versesData = try? encoder.encode(shabad.verses.map { VerseCache(from: $0) }) else {
            return
        }

        // Check if already cached
        let shabadID = shabad.id
        let descriptor = FetchDescriptor<CachedShabad>(
            predicate: #Predicate { $0.shabadID == shabadID }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            // Update existing
            existing.versesJSON = versesData
            existing.cachedAt = Date()
            existing.expiresAt = Date().addingTimeInterval(7 * 24 * 60 * 60)
        } else {
            // Create new
            let cached = CachedShabad(
                shabadID: shabad.id,
                sourceID: shabad.sourceID,
                sourceName: shabad.sourceName,
                ang: shabad.ang,
                writerName: shabad.writer?.english,
                raagName: shabad.raag?.english,
                versesJSON: versesData
            )
            modelContext.insert(cached)
        }
        try? modelContext.save()
    }

    func shabadFromCache(_ cached: CachedShabad) -> Shabad? {
        let decoder = JSONDecoder()
        guard let verseCaches = try? decoder.decode([VerseCache].self, from: cached.versesJSON) else {
            return nil
        }

        let verses = verseCaches.map { $0.toVerse() }

        return Shabad(
            id: cached.shabadID,
            sourceID: cached.sourceID,
            sourceName: cached.sourceName,
            ang: cached.ang,
            writer: cached.writerName.map { Writer(id: 0, gurmukhi: "", gurmukhiUnicode: "", english: $0) },
            raag: cached.raagName.map { Raag(id: 0, gurmukhi: "", gurmukhiUnicode: "", english: $0) },
            verses: verses
        )
    }

    // MARK: - Bani Caching

    func getCachedBani(id: Int, ignoreExpiration: Bool = false) -> CachedBani? {
        let descriptor = FetchDescriptor<CachedBani>(
            predicate: #Predicate { $0.baniID == id }
        )
        guard let cached = try? modelContext.fetch(descriptor).first else {
            return nil
        }
        if !ignoreExpiration && cached.isExpired {
            return nil
        }
        return cached
    }

    func cacheBani(_ bani: BaniContent) {
        let encoder = JSONEncoder()
        guard let versesData = try? encoder.encode(bani.verses.map { VerseCache(from: $0) }) else {
            return
        }

        let baniID = bani.id
        let descriptor = FetchDescriptor<CachedBani>(
            predicate: #Predicate { $0.baniID == baniID }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.versesJSON = versesData
            existing.cachedAt = Date()
            existing.expiresAt = Date().addingTimeInterval(7 * 24 * 60 * 60)
        } else {
            let cached = CachedBani(
                baniID: bani.id,
                name: bani.name,
                nameUnicode: bani.nameUnicode,
                transliteration: bani.transliteration,
                versesJSON: versesData
            )
            modelContext.insert(cached)
        }
        try? modelContext.save()
    }

    func baniFromCache(_ cached: CachedBani) -> BaniContent? {
        let decoder = JSONDecoder()
        guard let verseCaches = try? decoder.decode([VerseCache].self, from: cached.versesJSON) else {
            return nil
        }

        return BaniContent(
            id: cached.baniID,
            name: cached.name,
            nameUnicode: cached.nameUnicode,
            transliteration: cached.transliteration,
            verses: verseCaches.map { $0.toVerse() }
        )
    }

    // MARK: - Hukamnama Caching

    func getCachedHukamnama(for date: Date) -> CachedHukamnama? {
        let dateString = formatDate(date)
        let descriptor = FetchDescriptor<CachedHukamnama>(
            predicate: #Predicate { $0.dateString == dateString }
        )
        return try? modelContext.fetch(descriptor).first
    }

    func cacheHukamnama(_ hukamnama: Hukamnama) {
        let dateString = formatDate(hukamnama.date)

        let descriptor = FetchDescriptor<CachedHukamnama>(
            predicate: #Predicate { $0.dateString == dateString }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.gurmukhiText = hukamnama.gurmukhi
            existing.transliteration = hukamnama.transliteration
            existing.translation = hukamnama.translation
            existing.cachedAt = Date()
        } else {
            let cached = CachedHukamnama(
                dateString: dateString,
                ang: hukamnama.ang,
                gurmukhiText: hukamnama.gurmukhi,
                transliteration: hukamnama.transliteration,
                translation: hukamnama.translation,
                shabadID: hukamnama.shabadID
            )
            modelContext.insert(cached)
        }
        try? modelContext.save()
    }

    // MARK: - Cache Management

    func clearExpiredCache() {
        let now = Date()

        // Clear expired shabads
        let shabadDescriptor = FetchDescriptor<CachedShabad>(
            predicate: #Predicate { $0.expiresAt < now }
        )
        if let expired = try? modelContext.fetch(shabadDescriptor) {
            for item in expired {
                modelContext.delete(item)
            }
        }

        // Clear expired banis
        let baniDescriptor = FetchDescriptor<CachedBani>(
            predicate: #Predicate { $0.expiresAt < now }
        )
        if let expired = try? modelContext.fetch(baniDescriptor) {
            for item in expired {
                modelContext.delete(item)
            }
        }

        try? modelContext.save()
    }

    func clearAllCache() {
        // Clear all shabads
        let shabadDescriptor = FetchDescriptor<CachedShabad>()
        if let all = try? modelContext.fetch(shabadDescriptor) {
            for item in all {
                modelContext.delete(item)
            }
        }

        // Clear all banis
        let baniDescriptor = FetchDescriptor<CachedBani>()
        if let all = try? modelContext.fetch(baniDescriptor) {
            for item in all {
                modelContext.delete(item)
            }
        }

        // Clear all hukamnamas
        let hukamnamaDescriptor = FetchDescriptor<CachedHukamnama>()
        if let all = try? modelContext.fetch(hukamnamaDescriptor) {
            for item in all {
                modelContext.delete(item)
            }
        }

        try? modelContext.save()
    }

    var cacheStats: (shabads: Int, banis: Int, hukamnamas: Int) {
        let shabadCount = (try? modelContext.fetchCount(FetchDescriptor<CachedShabad>())) ?? 0
        let baniCount = (try? modelContext.fetchCount(FetchDescriptor<CachedBani>())) ?? 0
        let hukamnamaCount = (try? modelContext.fetchCount(FetchDescriptor<CachedHukamnama>())) ?? 0
        return (shabadCount, baniCount, hukamnamaCount)
    }

    // MARK: - Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// MARK: - Cache Helper Structs

/// Codable version of Verse for JSON storage
struct VerseCache: Codable {
    let id: Int
    let shabadID: Int
    let gurmukhi: String
    let gurmukhiUnicode: String
    let larivaar: String?
    let larivaarUnicode: String?
    let transliteration: String?
    let translation: String?
    let sourceID: String
    let ang: Int

    init(from verse: Verse) {
        self.id = verse.id
        self.shabadID = verse.shabadID
        self.gurmukhi = verse.gurmukhi
        self.gurmukhiUnicode = verse.gurmukhiUnicode
        self.larivaar = verse.larivaar
        self.larivaarUnicode = verse.larivaarUnicode
        self.transliteration = verse.transliteration
        self.translation = verse.translation
        self.sourceID = verse.sourceID
        self.ang = verse.ang
    }

    func toVerse() -> Verse {
        Verse(
            id: id,
            shabadID: shabadID,
            gurmukhi: gurmukhi,
            gurmukhiUnicode: gurmukhiUnicode,
            larivaar: larivaar,
            larivaarUnicode: larivaarUnicode,
            transliteration: transliteration,
            translation: translation,
            sourceID: sourceID,
            ang: ang
        )
    }
}

import Foundation
import SwiftData

/// Cached shabad for offline access
@Model
final class CachedShabad {
    @Attribute(.unique) var shabadID: Int
    var sourceID: String
    var sourceName: String
    var ang: Int
    var writerName: String?
    var raagName: String?
    var versesJSON: Data  // Stored as JSON for flexibility
    var cachedAt: Date
    var expiresAt: Date

    init(
        shabadID: Int,
        sourceID: String,
        sourceName: String,
        ang: Int,
        writerName: String? = nil,
        raagName: String? = nil,
        versesJSON: Data,
        cacheDuration: TimeInterval = 7 * 24 * 60 * 60  // 7 days default
    ) {
        self.shabadID = shabadID
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.ang = ang
        self.writerName = writerName
        self.raagName = raagName
        self.versesJSON = versesJSON
        self.cachedAt = Date()
        self.expiresAt = Date().addingTimeInterval(cacheDuration)
    }

    var isExpired: Bool {
        Date() > expiresAt
    }
}

/// Cached bani for offline access
@Model
final class CachedBani {
    @Attribute(.unique) var baniID: Int
    var name: String
    var nameUnicode: String
    var transliteration: String?
    var versesJSON: Data
    var cachedAt: Date
    var expiresAt: Date

    init(
        baniID: Int,
        name: String,
        nameUnicode: String,
        transliteration: String? = nil,
        versesJSON: Data,
        cacheDuration: TimeInterval = 7 * 24 * 60 * 60
    ) {
        self.baniID = baniID
        self.name = name
        self.nameUnicode = nameUnicode
        self.transliteration = transliteration
        self.versesJSON = versesJSON
        self.cachedAt = Date()
        self.expiresAt = Date().addingTimeInterval(cacheDuration)
    }

    var isExpired: Bool {
        Date() > expiresAt
    }
}

/// Cached hukamnama
@Model
final class CachedHukamnama {
    @Attribute(.unique) var dateString: String  // YYYY-MM-DD
    var ang: Int
    var gurmukhiText: String
    var transliteration: String?
    var translation: String?
    var shabadID: Int?
    var cachedAt: Date

    init(
        dateString: String,
        ang: Int,
        gurmukhiText: String,
        transliteration: String? = nil,
        translation: String? = nil,
        shabadID: Int? = nil
    ) {
        self.dateString = dateString
        self.ang = ang
        self.gurmukhiText = gurmukhiText
        self.transliteration = transliteration
        self.translation = translation
        self.shabadID = shabadID
        self.cachedAt = Date()
    }

    func toHukamnama() -> Hukamnama {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString) ?? Date()

        return Hukamnama(
            date: date,
            ang: ang,
            gurmukhi: gurmukhiText,
            transliteration: transliteration,
            translation: translation,
            shabadID: shabadID
        )
    }
}

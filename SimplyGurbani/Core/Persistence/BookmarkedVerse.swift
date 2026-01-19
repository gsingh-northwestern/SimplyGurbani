import Foundation
import SwiftData

/// A bookmarked verse stored in SwiftData
@Model
final class BookmarkedVerse {
    @Attribute(.unique) var verseID: Int
    var shabadID: Int
    var baniID: Int?  // Track which bani this verse is from (if applicable)
    var gurmukhiUnicode: String
    var transliteration: String?
    var translation: String?
    var ang: Int
    var sourceID: String
    var createdAt: Date
    var folderName: String?
    var notes: String?

    init(
        verseID: Int,
        shabadID: Int,
        baniID: Int? = nil,
        gurmukhiUnicode: String,
        transliteration: String? = nil,
        translation: String? = nil,
        ang: Int,
        sourceID: String,
        folderName: String? = nil,
        notes: String? = nil
    ) {
        self.verseID = verseID
        self.shabadID = shabadID
        self.baniID = baniID
        self.gurmukhiUnicode = gurmukhiUnicode
        self.transliteration = transliteration
        self.translation = translation
        self.ang = ang
        self.sourceID = sourceID
        self.createdAt = Date()
        self.folderName = folderName
        self.notes = notes
    }

    /// Convert to a Verse for display
    func toVerse() -> Verse {
        Verse(
            id: verseID,
            shabadID: shabadID,
            gurmukhi: gurmukhiUnicode,
            gurmukhiUnicode: gurmukhiUnicode,
            transliteration: transliteration,
            translation: translation,
            sourceID: sourceID,
            ang: ang
        )
    }
}

/// A bookmark folder for organizing verses
@Model
final class BookmarkFolder {
    @Attribute(.unique) var name: String
    var createdAt: Date
    var colorHex: String?

    init(name: String, colorHex: String? = nil) {
        self.name = name
        self.createdAt = Date()
        self.colorHex = colorHex
    }
}

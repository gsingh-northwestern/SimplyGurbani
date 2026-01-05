import Foundation

/// Represents a single verse/line of Gurbani
struct Verse: Identifiable, Decodable, Hashable, Sendable {
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
    let raagID: Int?
    let writerID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "verseId"
        case shabadID = "shabadId"
        case verse
        case larivaar
        case transliteration
        case translation
        case sourceID = "sourceId"
        case ang = "pageNo"
        case raagID = "raagId"
        case writerID = "writerId"
    }

    private enum VerseContentKeys: String, CodingKey {
        case gurmukhi
        case unicode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        shabadID = try container.decodeIfPresent(Int.self, forKey: .shabadID) ?? 0
        sourceID = try container.decodeIfPresent(String.self, forKey: .sourceID) ?? "G"
        ang = try container.decodeIfPresent(Int.self, forKey: .ang) ?? 0
        raagID = try container.decodeIfPresent(Int.self, forKey: .raagID)
        writerID = try container.decodeIfPresent(Int.self, forKey: .writerID)

        // Handle verse content (can be nested object or plain string)
        if let verseContainer = try? container.nestedContainer(keyedBy: VerseContentKeys.self, forKey: .verse) {
            gurmukhi = try verseContainer.decode(String.self, forKey: .gurmukhi)
            gurmukhiUnicode = try verseContainer.decode(String.self, forKey: .unicode)
        } else if let plainVerse = try? container.decode(String.self, forKey: .verse) {
            gurmukhi = plainVerse
            gurmukhiUnicode = plainVerse
        } else {
            gurmukhi = ""
            gurmukhiUnicode = ""
        }

        // Handle larivaar content
        if let larivaarContainer = try? container.nestedContainer(keyedBy: VerseContentKeys.self, forKey: .larivaar) {
            larivaar = try larivaarContainer.decodeIfPresent(String.self, forKey: .gurmukhi)
            larivaarUnicode = try larivaarContainer.decodeIfPresent(String.self, forKey: .unicode)
        } else {
            larivaar = nil
            larivaarUnicode = nil
        }

        // Handle nested transliteration
        if let translit = try? container.nestedContainer(keyedBy: TransliterationKeys.self, forKey: .transliteration) {
            transliteration = try translit.decodeIfPresent(String.self, forKey: .english)
                ?? translit.decodeIfPresent(String.self, forKey: .en)
        } else {
            transliteration = nil
        }

        // Handle nested translation
        if let trans = try? container.nestedContainer(keyedBy: TranslationKeys.self, forKey: .translation) {
            if let enContainer = try? trans.nestedContainer(keyedBy: TranslationSourceKeys.self, forKey: .english) {
                translation = try enContainer.decodeIfPresent(String.self, forKey: .bdb)
                    ?? enContainer.decodeIfPresent(String.self, forKey: .ssk)
                    ?? enContainer.decodeIfPresent(String.self, forKey: .ms)
            } else {
                translation = nil
            }
        } else {
            translation = nil
        }
    }

    private enum TransliterationKeys: String, CodingKey {
        case english, en
        case hindi, hi
    }

    private enum TranslationKeys: String, CodingKey {
        case english = "en"
        case punjabi = "pu"
        case hindi = "hi"
    }

    private enum TranslationSourceKeys: String, CodingKey {
        case bdb, ssk, ms, ft
    }

    // Manual initializer for creating instances
    init(
        id: Int,
        shabadID: Int,
        gurmukhi: String,
        gurmukhiUnicode: String,
        larivaar: String? = nil,
        larivaarUnicode: String? = nil,
        transliteration: String? = nil,
        translation: String? = nil,
        sourceID: String = "G",
        ang: Int = 0,
        raagID: Int? = nil,
        writerID: Int? = nil
    ) {
        self.id = id
        self.shabadID = shabadID
        self.gurmukhi = gurmukhi
        self.gurmukhiUnicode = gurmukhiUnicode
        self.larivaar = larivaar
        self.larivaarUnicode = larivaarUnicode
        self.transliteration = transliteration
        self.translation = translation
        self.sourceID = sourceID
        self.ang = ang
        self.raagID = raagID
        self.writerID = writerID
    }
}

// MARK: - BaniDB API Response Models

/// Response wrapper for shabad endpoint
struct ShabadResponse: Codable, Sendable {
    let shabadInfo: ShabadInfo
    let verses: [APIVerse]

    struct ShabadInfo: Codable, Sendable {
        let shabadId: Int
        let pageNo: Int
        let source: SourceInfo
        let raag: RaagInfo?
        let writer: WriterInfo?

        struct SourceInfo: Codable, Sendable {
            let sourceId: String
            let gurmukhi: String
            let unicode: String
            let english: String
            let pageNo: Int
        }

        struct RaagInfo: Codable, Sendable {
            let raagId: Int
            let gurmukhi: String
            let unicode: String
            let english: String
        }

        struct WriterInfo: Codable, Sendable {
            let writerId: Int
            let gurmukhi: String
            let unicode: String
            let english: String
        }
    }
}

/// API verse format from BaniDB
struct APIVerse: Codable, Sendable {
    let verseId: Int
    let shabadId: Int
    let verse: VerseContent
    let larivaar: VerseContent?
    let translation: Translation?
    let transliteration: Transliteration?
    let pageNo: Int
    let lineNo: Int
    let sourceId: String

    struct VerseContent: Codable, Sendable {
        let gurmukhi: String
        let unicode: String
    }

    struct Translation: Codable, Sendable {
        let en: TranslationSources?
        let pu: TranslationSources?
        let es: TranslationSources?

        struct TranslationSources: Codable, Sendable {
            let bdb: String?
            let ms: String?
            let ssk: String?
        }
    }

    struct Transliteration: Codable, Sendable {
        let english: String?
        let hindi: String?
        let en: String?
        let hi: String?

        var englishText: String? {
            english ?? en
        }
    }

    func toVerse() -> Verse {
        Verse(
            id: verseId,
            shabadID: shabadId,
            gurmukhi: verse.gurmukhi,
            gurmukhiUnicode: verse.unicode,
            larivaar: larivaar?.gurmukhi,
            larivaarUnicode: larivaar?.unicode,
            transliteration: transliteration?.englishText,
            translation: translation?.en?.bdb ?? translation?.en?.ssk ?? translation?.en?.ms,
            sourceID: sourceId,
            ang: pageNo
        )
    }
}

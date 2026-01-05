import Foundation

/// A named collection of verses (e.g., Japji Sahib, Rehras)
struct Bani: Identifiable, Decodable, Hashable, Sendable {
    let id: Int
    let gurmukhi: String
    let gurmukhiUnicode: String
    let transliteration: String?
    let english: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case gurmukhi
        case gurmukhiUnicode = "gurmukhiUni"
        case transliteration
        case transliterations
        case english
    }

    private enum TranslitKeys: String, CodingKey {
        case english = "en"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        gurmukhi = try container.decode(String.self, forKey: .gurmukhi)
        gurmukhiUnicode = try container.decode(String.self, forKey: .gurmukhiUnicode)

        // Handle nested transliterations object (API returns "transliterations" with "en" inside)
        if let translitContainer = try? container.nestedContainer(keyedBy: TranslitKeys.self, forKey: .transliterations) {
            transliteration = try translitContainer.decodeIfPresent(String.self, forKey: .english)
        } else if let directTranslit = try? container.decode(String.self, forKey: .transliteration) {
            transliteration = directTranslit
        } else {
            transliteration = nil
        }

        english = nil // Not provided in list endpoint
    }

    init(id: Int, gurmukhi: String, gurmukhiUnicode: String, transliteration: String?, english: String?) {
        self.id = id
        self.gurmukhi = gurmukhi
        self.gurmukhiUnicode = gurmukhiUnicode
        self.transliteration = transliteration
        self.english = english
    }
}

/// Full bani content with verses
struct BaniContent: Identifiable, Sendable {
    let id: Int
    let name: String
    let nameUnicode: String
    let transliteration: String?
    let verses: [Verse]

    init(id: Int, name: String, nameUnicode: String, transliteration: String?, verses: [Verse]) {
        self.id = id
        self.name = name
        self.nameUnicode = nameUnicode
        self.transliteration = transliteration
        self.verses = verses
    }
}

/// API response for bani content
struct BaniResponse: Codable, Sendable {
    let baniInfo: BaniInfo
    let verses: [BaniVerseWrapper]

    struct BaniInfo: Codable, Sendable {
        let baniID: Int
        let gurmukhi: String
        let unicode: String
        let english: String?
        let en: String?

        var transliteration: String? {
            english ?? en
        }
    }

    /// Wrapper for verse in bani response (has extra nesting)
    struct BaniVerseWrapper: Codable, Sendable {
        let verse: BaniAPIVerse
    }

    /// Verse structure specific to bani endpoint
    struct BaniAPIVerse: Codable, Sendable {
        let verseId: Int
        let verse: VerseContent
        let larivaar: VerseContent?
        let translation: Translation?
        let transliteration: Transliteration?

        struct VerseContent: Codable, Sendable {
            let gurmukhi: String
            let unicode: String
        }

        struct Translation: Codable, Sendable {
            let en: TranslationSources?

            struct TranslationSources: Codable, Sendable {
                let bdb: String?
            }
        }

        struct Transliteration: Codable, Sendable {
            let english: String?
            let en: String?

            var englishText: String? {
                english ?? en
            }
        }

        func toVerse() -> Verse {
            Verse(
                id: verseId,
                shabadID: 0,
                gurmukhi: verse.gurmukhi,
                gurmukhiUnicode: verse.unicode,
                larivaar: larivaar?.gurmukhi,
                larivaarUnicode: larivaar?.unicode,
                transliteration: transliteration?.englishText,
                translation: translation?.en?.bdb,
                sourceID: "G",
                ang: 0
            )
        }
    }

    func toBaniContent() -> BaniContent {
        BaniContent(
            id: baniInfo.baniID,
            name: baniInfo.gurmukhi,
            nameUnicode: baniInfo.unicode,
            transliteration: baniInfo.transliteration,
            verses: verses.map { $0.verse.toVerse() }
        )
    }
}

/// Well-known bani IDs from BaniDB
enum WellKnownBani: Int, CaseIterable {
    case japjiSahib = 2       // ਜਪੁਜੀ ਸਾਹਿਬ
    case rehrasSahib = 21     // ਰਹਰਾਸਿ ਸਾਹਿਬ
    case kirtanSohila = 23    // ਸੋਹਿਲਾ ਸਾਹਿਬ
    case anandSahib = 10      // ਅਨੰਦੁ ਸਾਹਿਬ
    case sukhmaniSahib = 31   // ਸੁਖਮਨੀ ਸਾਹਿਬ
    case asaDiVar = 90        // ਆਸਾ ਦੀ ਵਾਰ
    case chaupaiSahib = 9     // ਬੇਨਤੀ ਚੌਪਈ ਸਾਹਿਬ
    case tavPrasad = 6        // ਤ੍ਵ ਪ੍ਰਸਾਦਿ ਸਵੱਯੇ
    case ardas = 24           // ਅਰਦਾਸ

    var displayName: String {
        switch self {
        case .japjiSahib: return "Japji Sahib"
        case .rehrasSahib: return "Rehras Sahib"
        case .kirtanSohila: return "Kirtan Sohila"
        case .anandSahib: return "Anand Sahib"
        case .sukhmaniSahib: return "Sukhmani Sahib"
        case .asaDiVar: return "Asa di Var"
        case .chaupaiSahib: return "Chaupai Sahib"
        case .tavPrasad: return "Tav Prasad Svaiye"
        case .ardas: return "Ardas"
        }
    }

    var icon: String {
        switch self {
        case .japjiSahib: return "sunrise"
        case .rehrasSahib: return "sunset"
        case .kirtanSohila: return "moon.stars"
        case .anandSahib: return "sparkles"
        case .sukhmaniSahib: return "heart.circle"
        case .asaDiVar: return "music.note"
        case .chaupaiSahib: return "shield"
        case .tavPrasad: return "star"
        case .ardas: return "hands.sparkles"
        }
    }
}

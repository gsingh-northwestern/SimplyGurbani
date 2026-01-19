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

    /// Returns the proper English display name for well-known banis, or the transliteration for others
    var displayName: String {
        if let wellKnownBani = WellKnownBani(rawValue: id) {
            return wellKnownBani.displayName
        }
        // Capitalize transliteration properly
        if let translit = transliteration {
            return Self.capitalizeTransliteration(translit)
        }
        return gurmukhiUnicode
    }

    /// Properly capitalizes transliteration strings from the API
    static func capitalizeTransliteration(_ text: String) -> String {
        // Split by spaces
        let words = text.split(separator: " ")

        // Capitalize each word
        let capitalizedWords = words.map { word -> String in
            let wordString = String(word)

            // Check if word starts with a parenthesis (like "(dheenan")
            if wordString.hasPrefix("(") {
                let afterParen = wordString.dropFirst()
                if let firstChar = afterParen.first {
                    return "(" + firstChar.uppercased() + afterParen.dropFirst()
                }
                return wordString
            }

            // Regular word - capitalize first letter only
            guard let firstChar = wordString.first else { return wordString }
            return firstChar.uppercased() + wordString.dropFirst()
        }

        return capitalizedWords.joined(separator: " ")
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

    /// Returns the proper English display name for well-known banis, or the transliteration for others
    var displayName: String {
        if let wellKnownBani = WellKnownBani(rawValue: id) {
            return wellKnownBani.displayName
        }
        // Capitalize transliteration properly
        if let translit = transliteration {
            return Bani.capitalizeTransliteration(translit)
        }
        return nameUnicode
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
    case shabadHazare = 3     // ਸ਼ਬਦ ਹਜ਼ਾਰੇ
    case jaapSahib = 4        // ਜਾਪੁ ਸਾਹਿਬ
    case tavPrasad = 6        // ਤ੍ਵ ਪ੍ਰਸਾਦਿ ਸਵੱਯੇ
    case chaupaiSahib = 9     // ਬੇਨਤੀ ਚੌਪਈ ਸਾਹਿਬ
    case anandSahib = 10      // ਅਨੰਦੁ ਸਾਹਿਬ
    case lavaan = 11          // ਲਾਵਾਂ
    case rehrasSahib = 21     // ਰਹਰਾਸਿ ਸਾਹਿਬ
    case kirtanSohila = 23    // ਸੋਹਿਲਾ ਸਾਹਿਬ
    case ardas = 24           // ਅਰਦਾਸ
    case sukhmaniSahib = 31   // ਸੁਖਮਨੀ ਸਾਹਿਬ
    case asaDiVar = 90        // ਆਸਾ ਦੀ ਵਾਰ

    var displayName: String {
        switch self {
        case .japjiSahib: return "Japji Sahib"
        case .shabadHazare: return "Shabad Hazare"
        case .jaapSahib: return "Jaap Sahib"
        case .tavPrasad: return "Tav Prasad Svaiye"
        case .chaupaiSahib: return "Chaupai Sahib"
        case .anandSahib: return "Anand Sahib"
        case .lavaan: return "Lavaan"
        case .rehrasSahib: return "Rehras Sahib"
        case .kirtanSohila: return "Kirtan Sohila"
        case .ardas: return "Ardas"
        case .sukhmaniSahib: return "Sukhmani Sahib"
        case .asaDiVar: return "Asa di Var"
        }
    }

    var icon: String {
        switch self {
        case .japjiSahib: return "sunrise"
        case .shabadHazare: return "book.pages"
        case .jaapSahib: return "flame"
        case .tavPrasad: return "star"
        case .chaupaiSahib: return "shield"
        case .anandSahib: return "sparkles"
        case .lavaan: return "heart.circle.fill"
        case .rehrasSahib: return "sunset"
        case .kirtanSohila: return "moon.stars"
        case .ardas: return "hands.sparkles"
        case .sukhmaniSahib: return "heart.circle"
        case .asaDiVar: return "music.note"
        }
    }
}

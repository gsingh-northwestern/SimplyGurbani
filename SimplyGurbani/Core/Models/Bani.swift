import Foundation

/// A named collection of verses (e.g., Japji Sahib, Rehras)
struct Bani: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let gurmukhi: String
    let gurmukhiUnicode: String
    let transliteration: String?
    let english: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case gurmukhi
        case gurmukhiUnicode = "unicode"
        case transliteration
        case english
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        gurmukhi = try container.decode(String.self, forKey: .gurmukhi)
        gurmukhiUnicode = try container.decode(String.self, forKey: .gurmukhiUnicode)

        // Handle nested transliteration
        if let translitContainer = try? container.nestedContainer(keyedBy: TranslitKeys.self, forKey: .transliteration) {
            transliteration = try translitContainer.decodeIfPresent(String.self, forKey: .english)
        } else {
            transliteration = nil
        }

        english = nil // Not provided in list endpoint
    }

    private enum TranslitKeys: String, CodingKey {
        case english = "en"
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
    let verses: [APIVerse]

    struct BaniInfo: Codable, Sendable {
        let baniId: Int
        let gurmukhi: String
        let unicode: String
        let transliteration: TranslitInfo?

        struct TranslitInfo: Codable, Sendable {
            let en: String?
        }
    }

    func toBaniContent() -> BaniContent {
        BaniContent(
            id: baniInfo.baniId,
            name: baniInfo.gurmukhi,
            nameUnicode: baniInfo.unicode,
            transliteration: baniInfo.transliteration?.en,
            verses: verses.map { $0.toVerse() }
        )
    }
}

/// Well-known bani IDs from BaniDB
enum WellKnownBani: Int, CaseIterable {
    case japjiSahib = 1
    case rehrasSahib = 2
    case kirtanSohila = 3
    case anandSahibBhog = 4
    case sukhmaniSahib = 20
    case anandSahib = 21
    case asaDiVar = 22
    case chaupaiSahib = 5
    case tavPrasad = 6
    case ardas = 7

    var displayName: String {
        switch self {
        case .japjiSahib: return "Japji Sahib"
        case .rehrasSahib: return "Rehras Sahib"
        case .kirtanSohila: return "Kirtan Sohila"
        case .anandSahibBhog: return "Anand Sahib (Bhog)"
        case .sukhmaniSahib: return "Sukhmani Sahib"
        case .anandSahib: return "Anand Sahib"
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
        case .anandSahibBhog, .anandSahib: return "sparkles"
        case .sukhmaniSahib: return "heart.circle"
        case .asaDiVar: return "music.note"
        case .chaupaiSahib: return "shield"
        case .tavPrasad: return "star"
        case .ardas: return "hands.sparkles"
        }
    }
}

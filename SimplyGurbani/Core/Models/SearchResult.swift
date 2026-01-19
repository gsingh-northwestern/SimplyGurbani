import Foundation

/// Search result from BaniDB
struct SearchResult: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let shabadID: Int
    let gurmukhi: String
    let gurmukhiUnicode: String
    let transliteration: String?
    let translation: String?
    let ang: Int
    let sourceID: String
    let writerID: Int?
    let raagID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "verseId"
        case shabadID = "shabadId"
        case gurmukhi
        case gurmukhiUnicode = "unicode"
        case transliteration
        case translation
        case ang = "pageNo"
        case sourceID = "sourceId"
        case writerID = "writerId"
        case raagID = "raagId"
    }
}

/// API response for search
struct SearchResponse: Codable, Sendable {
    let verses: [SearchVerse]

    struct SearchVerse: Codable, Sendable {
        let verseId: Int
        let shabadId: Int
        let verse: VerseContent
        let transliteration: TranslitContent?
        let translation: TransContent?
        let pageNo: Int?
        let source: SourceInfo?
        let writer: WriterInfo?
        let raag: RaagInfo?

        struct VerseContent: Codable, Sendable {
            let gurmukhi: String
            let unicode: String
        }

        struct TranslitContent: Codable, Sendable {
            let en: String?
            let english: String?
        }

        struct TransContent: Codable, Sendable {
            let en: EnTranslation?

            struct EnTranslation: Codable, Sendable {
                let bdb: String?
                let ssk: String?
            }
        }

        struct SourceInfo: Codable, Sendable {
            let sourceId: String
        }

        struct WriterInfo: Codable, Sendable {
            let writerId: Int
        }

        struct RaagInfo: Codable, Sendable {
            let raagId: Int?
        }

        func toSearchResult() -> SearchResult {
            SearchResult(
                id: verseId,
                shabadID: shabadId,
                gurmukhi: verse.gurmukhi,
                gurmukhiUnicode: verse.unicode,
                transliteration: transliteration?.en ?? transliteration?.english,
                translation: translation?.en?.bdb ?? translation?.en?.ssk,
                ang: pageNo ?? 0,
                sourceID: source?.sourceId ?? "G",
                writerID: writer?.writerId,
                raagID: raag?.raagId
            )
        }
    }
}

/// Search query parameters
struct SearchQuery: Sendable {
    let query: String
    let searchType: SearchType

    init(query: String, searchType: SearchType = .firstLetter) {
        self.query = query
        self.searchType = searchType
    }
}

/// Available search types from BaniDB
enum SearchType: Int, CaseIterable, Sendable {
    case firstLetter = 0
    case firstLetterAnywhere = 1
    case fullWord = 2
    case fullWordAnywhere = 3
    case romanized = 4
    case angSearch = 5
    case mainLetter = 6

    var displayName: String {
        switch self {
        case .firstLetter: return "First Letter"
        case .firstLetterAnywhere: return "First Letter (Anywhere)"
        case .fullWord: return "Full Word"
        case .fullWordAnywhere: return "Full Word (Anywhere)"
        case .romanized: return "Romanized"
        case .angSearch: return "Page Number"
        case .mainLetter: return "Main Letter"
        }
    }
}

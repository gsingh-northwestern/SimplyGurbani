import Foundation

/// A composition/hymn containing multiple verses
struct Shabad: Identifiable, Hashable, Sendable {
    let id: Int
    let sourceID: String
    let sourceName: String
    let ang: Int
    let writer: Writer?
    let raag: Raag?
    let verses: [Verse]

    init(
        id: Int,
        sourceID: String,
        sourceName: String,
        ang: Int,
        writer: Writer? = nil,
        raag: Raag? = nil,
        verses: [Verse]
    ) {
        self.id = id
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.ang = ang
        self.writer = writer
        self.raag = raag
        self.verses = verses
    }

    /// Create from API response
    static func from(response: ShabadResponse) -> Shabad {
        let info = response.shabadInfo

        let writer: Writer? = info.writer.map {
            Writer(
                id: $0.writerId,
                gurmukhi: $0.gurmukhi,
                gurmukhiUnicode: $0.unicode,
                english: $0.english
            )
        }

        let raag: Raag? = info.raag.map {
            Raag(
                id: $0.raagId,
                gurmukhi: $0.gurmukhi,
                gurmukhiUnicode: $0.unicode,
                english: $0.english
            )
        }

        let verses = response.verses.map { $0.toVerse() }

        return Shabad(
            id: info.shabadId,
            sourceID: info.source.sourceId,
            sourceName: info.source.english,
            ang: info.pageNo,
            writer: writer,
            raag: raag,
            verses: verses
        )
    }

    /// First line preview for display
    var firstLine: String {
        verses.first?.gurmukhiUnicode ?? ""
    }

    var firstLineTransliteration: String? {
        verses.first?.transliteration
    }
}

/// Summary of a shabad for list displays
struct ShabadSummary: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let firstLine: String
    let firstLineUnicode: String
    let transliteration: String?
    let ang: Int
    let sourceID: String
    let writerID: Int?
}

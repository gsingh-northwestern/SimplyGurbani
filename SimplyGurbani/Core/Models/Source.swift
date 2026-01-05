import Foundation

/// Gurbani scripture source
struct Source: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let gurmukhi: String
    let gurmukhiUnicode: String
    let english: String
    let pageCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "sourceId"
        case gurmukhi
        case gurmukhiUnicode = "unicode"
        case english
        case pageCount
    }

    init(id: String, gurmukhi: String, gurmukhiUnicode: String, english: String, pageCount: Int?) {
        self.id = id
        self.gurmukhi = gurmukhi
        self.gurmukhiUnicode = gurmukhiUnicode
        self.english = english
        self.pageCount = pageCount
    }
}

/// Known scripture sources
extension Source {
    static let sriGuruGranthSahib = Source(
        id: "G",
        gurmukhi: "sRI gurU gRMQ swihb jI",
        gurmukhiUnicode: "ਸ੍ਰੀ ਗੁਰੂ ਗ੍ਰੰਥ ਸਾਹਿਬ ਜੀ",
        english: "Sri Guru Granth Sahib Ji",
        pageCount: 1430
    )

    static let dasamGranth = Source(
        id: "D",
        gurmukhi: "dsm bwxI",
        gurmukhiUnicode: "ਦਸਮ ਬਾਣੀ",
        english: "Dasam Bani",
        pageCount: nil
    )

    static let bhaiGurdasVaaran = Source(
        id: "B",
        gurmukhi: "BweI gurdws jI vwrW",
        gurmukhiUnicode: "ਭਾਈ ਗੁਰਦਾਸ ਜੀ ਵਾਰਾਂ",
        english: "Bhai Gurdas Ji Vaaran",
        pageCount: nil
    )

    static let allSources: [Source] = [
        .sriGuruGranthSahib,
        .dasamGranth,
        .bhaiGurdasVaaran
    ]
}

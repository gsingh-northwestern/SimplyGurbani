import Foundation

/// Author/composer of Gurbani
struct Writer: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let gurmukhi: String
    let gurmukhiUnicode: String
    let english: String

    enum CodingKeys: String, CodingKey {
        case id = "writerId"
        case gurmukhi
        case gurmukhiUnicode = "unicode"
        case english
    }

    init(id: Int, gurmukhi: String, gurmukhiUnicode: String, english: String) {
        self.id = id
        self.gurmukhi = gurmukhi
        self.gurmukhiUnicode = gurmukhiUnicode
        self.english = english
    }
}

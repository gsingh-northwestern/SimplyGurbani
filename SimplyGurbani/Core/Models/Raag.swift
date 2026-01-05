import Foundation

/// Musical mode/scale in Gurbani
struct Raag: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let gurmukhi: String
    let gurmukhiUnicode: String
    let english: String
    let startAng: Int?
    let endAng: Int?

    enum CodingKeys: String, CodingKey {
        case id = "raagId"
        case gurmukhi
        case gurmukhiUnicode = "unicode"
        case english
        case startAng
        case endAng
    }

    init(id: Int, gurmukhi: String, gurmukhiUnicode: String, english: String, startAng: Int? = nil, endAng: Int? = nil) {
        self.id = id
        self.gurmukhi = gurmukhi
        self.gurmukhiUnicode = gurmukhiUnicode
        self.english = english
        self.startAng = startAng
        self.endAng = endAng
    }
}

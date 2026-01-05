import Foundation

/// Daily Hukamnama from Sri Harmandir Sahib
struct Hukamnama: Identifiable, Sendable {
    var id: String { date.formatted(.iso8601) }
    let date: Date
    let ang: Int
    let gurmukhi: String
    let transliteration: String?
    let translation: String?
    let shabadID: Int?

    init(
        date: Date,
        ang: Int,
        gurmukhi: String,
        transliteration: String?,
        translation: String?,
        shabadID: Int?
    ) {
        self.date = date
        self.ang = ang
        self.gurmukhi = gurmukhi
        self.transliteration = transliteration
        self.translation = translation
        self.shabadID = shabadID
    }
}

/// API response for hukamnama
struct HukamnamaResponse: Codable, Sendable {
    let date: DateInfo
    let shabadIds: [Int]
    let shabads: [HukamnamaShabad]

    struct DateInfo: Codable, Sendable {
        let gregorian: GregorianDate

        struct GregorianDate: Codable, Sendable {
            let month: Int
            let date: Int
            let year: Int
        }
    }

    struct HukamnamaShabad: Codable, Sendable {
        let shabadInfo: ShabadInfo
        let verses: [HukamnamaVerse]

        struct ShabadInfo: Codable, Sendable {
            let shabadId: Int
            let pageNo: Int
        }
    }

    struct HukamnamaVerse: Codable, Sendable {
        let verseId: Int
        let verse: VerseContent
        let translation: TranslationContent?
        let transliteration: TransliterationContent?

        struct VerseContent: Codable, Sendable {
            let gurmukhi: String
            let unicode: String
        }

        struct TranslationContent: Codable, Sendable {
            let en: TranslationSources?

            struct TranslationSources: Codable, Sendable {
                let bdb: String?
                let ms: String?
                let ssk: String?
            }
        }

        struct TransliterationContent: Codable, Sendable {
            let english: String?
            let en: String?

            var text: String? {
                english ?? en
            }
        }
    }

    func toHukamnama() -> Hukamnama {
        // Parse the date
        var dateComponents = DateComponents()
        dateComponents.year = date.gregorian.year
        dateComponents.month = date.gregorian.month
        dateComponents.day = date.gregorian.date
        let calendar = Calendar.current
        let parsedDate = calendar.date(from: dateComponents) ?? Date()

        // Get the first shabad and its verses
        guard let firstShabad = shabads.first else {
            return Hukamnama(
                date: parsedDate,
                ang: 0,
                gurmukhi: "",
                transliteration: nil,
                translation: nil,
                shabadID: nil
            )
        }

        // Combine the first few verses for display
        let gurmukhiLines = firstShabad.verses.prefix(3).map { $0.verse.unicode }.joined(separator: "\n")
        let translitLines = firstShabad.verses.prefix(3).compactMap { $0.transliteration?.text }.joined(separator: " ")
        let translationLines = firstShabad.verses.prefix(3).compactMap {
            $0.translation?.en?.bdb ?? $0.translation?.en?.ssk ?? $0.translation?.en?.ms
        }.joined(separator: " ")

        return Hukamnama(
            date: parsedDate,
            ang: firstShabad.shabadInfo.pageNo,
            gurmukhi: gurmukhiLines,
            transliteration: translitLines.isEmpty ? nil : translitLines,
            translation: translationLines.isEmpty ? nil : translationLines,
            shabadID: firstShabad.shabadInfo.shabadId
        )
    }
}

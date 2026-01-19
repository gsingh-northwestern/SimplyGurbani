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
    let isLatest: Bool?
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
        let count: Int?
        let navigation: Navigation?

        struct Navigation: Codable, Sendable {
            let previous: Int?
            let next: Int?
        }

        struct ShabadInfo: Codable, Sendable {
            let shabadId: Int
            let shabadName: Int?
            let pageNo: Int
            let source: Source?
            let raag: Raag?
            let writer: Writer?

            struct Source: Codable, Sendable {
                let sourceId: String?
                let gurmukhi: String?
                let unicode: String?
                let english: String?
                let pageNo: Int?
            }

            struct Raag: Codable, Sendable {
                let raagId: Int?
                let gurmukhi: String?
                let unicode: String?
                let english: String?
                let raagWithPage: String?
            }

            struct Writer: Codable, Sendable {
                let writerId: Int?
                let gurmukhi: String?
                let unicode: String?
                let english: String?
            }
        }
    }

    struct HukamnamaVerse: Codable, Sendable {
        let verseId: Int
        let shabadId: Int?
        let verse: VerseContent
        let larivaar: VerseContent?
        let translation: TranslationContent?
        let transliteration: TransliterationContent?
        let pageNo: Int?
        let lineNo: Int?
        let updated: String?
        let visraam: VisraamContent?

        struct VerseContent: Codable, Sendable {
            let gurmukhi: String?
            let unicode: String?
        }

        struct TranslationContent: Codable, Sendable {
            let en: TranslationSources?
            let pu: PunjabiTranslation?
            let es: SpanishTranslation?
            let hi: HindiTranslation?

            struct TranslationSources: Codable, Sendable {
                let bdb: String?
                let ms: String?
                let ssk: String?
            }

            struct PunjabiTranslation: Codable, Sendable {
                let ss: TranslationText?
                let ft: TranslationText?
                let bdb: TranslationText?
                let ms: TranslationText?

                struct TranslationText: Codable, Sendable {
                    let gurmukhi: String?
                    let unicode: String?
                }
            }

            struct SpanishTranslation: Codable, Sendable {
                let sn: String?
            }

            struct HindiTranslation: Codable, Sendable {
                let ss: String?
                let sts: String?
            }
        }

        struct TransliterationContent: Codable, Sendable {
            let english: String?
            let en: String?
            let hindi: String?
            let hi: String?
            let ipa: String?
            let ur: String?

            var text: String? {
                english ?? en
            }
        }

        struct VisraamContent: Codable, Sendable {
            let sttm: [VisraamMark]?
            let igurbani: [VisraamMark]?
            let sttm2: [VisraamMark]?

            struct VisraamMark: Codable, Sendable {
                let p: Int
                let t: String
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
        let gurmukhiLines = firstShabad.verses.prefix(3).compactMap { $0.verse.unicode }.joined(separator: "\n")
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

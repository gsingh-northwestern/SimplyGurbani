import Foundation

/// Type-safe navigation routes
enum Route: Hashable {
    // Reader routes
    case shabadReader(shabadID: Int, scrollToVerseID: Int? = nil)
    case baniReader(baniID: Int, scrollToVerseID: Int? = nil)
    case angReader(ang: Int, sourceID: String)
    case hukamnamaReader(date: Date? = nil)

    // Browse routes
    case scriptureList
    case baniList
    case categorizedBaniList
    case raagList
    case writerList
    case writerShabads(writerID: Int, writerName: String, writerGurmukhi: String)
    case angPicker(sourceID: String)
    case raagDetail(raagID: Int)

    // Search routes
    case searchResults(query: String)

    // Settings routes
    case languageSettings
    case displaySettings
    case about
}

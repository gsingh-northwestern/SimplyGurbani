import Foundation

/// Type-safe navigation routes
enum Route: Hashable {
    // Reader routes
    case shabadReader(shabadID: Int)
    case baniReader(baniID: Int)
    case angReader(ang: Int, sourceID: String)
    case hukamnamaReader(date: Date? = nil)

    // Browse routes
    case scriptureList
    case baniList
    case raagList
    case writerList
    case angPicker(sourceID: String)
    case raagDetail(raagID: Int)

    // Search routes
    case searchResults(query: String)

    // Settings routes
    case languageSettings
    case displaySettings
    case about
}

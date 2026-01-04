import Foundation

/// Main tab destinations
enum TabRoute: Int, CaseIterable, Identifiable, Hashable {
    case home
    case browse
    case search
    case bookmarks
    case settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .browse: return "Browse"
        case .search: return "Search"
        case .bookmarks: return "Bookmarks"
        case .settings: return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .browse: return "book.fill"
        case .search: return "magnifyingglass"
        case .bookmarks: return "bookmark.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

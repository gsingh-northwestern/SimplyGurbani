import SwiftUI
import Observation

/// Centralized navigation state manager
@Observable
final class AppRouter {
    var selectedTab: TabRoute = .home
    var homePath: [Route] = []
    var browsePath: [Route] = []
    var searchPath: [Route] = []
    var bookmarksPath: [Route] = []
    var settingsPath: [Route] = []

    // MARK: - Navigation Helpers

    func navigateToShabad(_ shabadID: Int) {
        switch selectedTab {
        case .home:
            homePath.append(.shabadReader(shabadID: shabadID))
        case .browse:
            browsePath.append(.shabadReader(shabadID: shabadID))
        case .search:
            searchPath.append(.shabadReader(shabadID: shabadID))
        case .bookmarks:
            bookmarksPath.append(.shabadReader(shabadID: shabadID))
        case .settings:
            settingsPath.append(.shabadReader(shabadID: shabadID))
        }
    }

    func navigateToBani(_ baniID: Int) {
        switch selectedTab {
        case .home:
            homePath.append(.baniReader(baniID: baniID))
        case .browse:
            browsePath.append(.baniReader(baniID: baniID))
        default:
            browsePath.append(.baniReader(baniID: baniID))
            selectedTab = .browse
        }
    }

    func popToRoot() {
        switch selectedTab {
        case .home: homePath = []
        case .browse: browsePath = []
        case .search: searchPath = []
        case .bookmarks: bookmarksPath = []
        case .settings: settingsPath = []
        }
    }

    // MARK: - Deep Linking

    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else { return }

        switch host {
        case "shabad":
            if let shabadIDString = components.queryItems?.first(where: { $0.name == "id" })?.value,
               let shabadID = Int(shabadIDString) {
                selectedTab = .browse
                browsePath.append(.shabadReader(shabadID: shabadID))
            }
        case "hukamnama":
            selectedTab = .home
            homePath.append(.hukamnamaReader())
        case "search":
            if let query = components.queryItems?.first(where: { $0.name == "q" })?.value {
                selectedTab = .search
                searchPath.append(.searchResults(query: query))
            }
        default:
            break
        }
    }
}

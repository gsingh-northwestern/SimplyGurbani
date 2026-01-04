import SwiftUI

struct ContentView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            NavigationStack(path: $router.homePath) {
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(TabRoute.home.title, systemImage: TabRoute.home.systemImage)
            }
            .tag(TabRoute.home)

            NavigationStack(path: $router.browsePath) {
                BrowseView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(TabRoute.browse.title, systemImage: TabRoute.browse.systemImage)
            }
            .tag(TabRoute.browse)

            NavigationStack(path: $router.searchPath) {
                SearchView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(TabRoute.search.title, systemImage: TabRoute.search.systemImage)
            }
            .tag(TabRoute.search)

            NavigationStack(path: $router.bookmarksPath) {
                BookmarksView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(TabRoute.bookmarks.title, systemImage: TabRoute.bookmarks.systemImage)
            }
            .tag(TabRoute.bookmarks)

            NavigationStack(path: $router.settingsPath) {
                SettingsView()
                    .navigationDestination(for: Route.self) { route in
                        destinationView(for: route)
                    }
            }
            .tabItem {
                Label(TabRoute.settings.title, systemImage: TabRoute.settings.systemImage)
            }
            .tag(TabRoute.settings)
        }
        .tint(AppTheme.Colors.primarySaffron)
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .shabadReader(let shabadID):
            ReaderView(shabadID: shabadID)
        case .baniReader(let baniID):
            BaniReaderView(baniID: baniID)
        case .hukamnamaReader:
            HukamnamaDetailView()
        case .angPicker(let sourceID):
            AngPickerView(sourceID: sourceID)
        case .searchResults(let query):
            SearchResultsView(query: query)
        default:
            Text("Coming Soon")
        }
    }
}

#Preview {
    ContentView()
        .environment(AppRouter())
}

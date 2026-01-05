import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var router = router
        legacyTabView(router: router)
    }

    @available(iOS 18.0, *)
    @ViewBuilder
    private func modernTabView(router: AppRouter) -> some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            Tab(value: TabRoute.home) {
                NavigationStack(path: $router.homePath) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
            } label: {
                Label(TabRoute.home.title, systemImage: TabRoute.home.systemImage)
            }

            Tab(value: TabRoute.browse) {
                NavigationStack(path: $router.browsePath) {
                    BrowseView()
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
            } label: {
                Label(TabRoute.browse.title, systemImage: TabRoute.browse.systemImage)
            }

            Tab(value: TabRoute.search) {
                NavigationStack(path: $router.searchPath) {
                    SearchView()
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
            } label: {
                Label(TabRoute.search.title, systemImage: TabRoute.search.systemImage)
            }

            Tab(value: TabRoute.bookmarks) {
                NavigationStack(path: $router.bookmarksPath) {
                    BookmarksView()
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
            } label: {
                Label(TabRoute.bookmarks.title, systemImage: TabRoute.bookmarks.systemImage)
            }

            Tab(value: TabRoute.settings) {
                NavigationStack(path: $router.settingsPath) {
                    SettingsView()
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
            } label: {
                Label(TabRoute.settings.title, systemImage: TabRoute.settings.systemImage)
            }
        }
        .tabViewStyle(.tabBarOnly)
        .tint(AppTheme.Colors.primaryBurgundy)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.light, for: .tabBar)
        .task {
            GurbaniService.shared.configureCaching(with: modelContext)
        }
    }

    @ViewBuilder
    private func legacyTabView(router: AppRouter) -> some View {
        @Bindable var router = router
        TabView {
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
        .tint(AppTheme.Colors.primaryBurgundy)
        .task {
            GurbaniService.shared.configureCaching(with: modelContext)
        }
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
        case .angReader(let ang, let sourceID):
            AngReaderView(angNumber: ang, sourceID: sourceID)
        case .writerShabads(let writerID, let writerName, let writerGurmukhi):
            WriterShabadsView(writerID: writerID, writerName: writerName, writerGurmukhi: writerGurmukhi)
        case .categorizedBaniList:
            CategorizedBaniListView()
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

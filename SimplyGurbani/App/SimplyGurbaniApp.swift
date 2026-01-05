import SwiftUI
import SwiftData

@main
struct SimplyGurbaniApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                BookmarkedVerse.self,
                BookmarkFolder.self,
                CachedShabad.self,
                CachedBani.self,
                CachedHukamnama.self
            ])
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AppRouter())
        }
        .modelContainer(modelContainer)
    }
}

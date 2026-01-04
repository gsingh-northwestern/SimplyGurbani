import SwiftUI
import SwiftData

@main
struct SimplyGurbaniApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                // SwiftData models will be added here
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

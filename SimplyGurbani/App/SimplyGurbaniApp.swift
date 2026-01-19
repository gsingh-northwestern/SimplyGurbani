import SwiftUI
import SwiftData
import UIKit

@main
struct SimplyGurbaniApp: App {
    let modelContainer: ModelContainer

    init() {
        // Configure UI appearances
        Self.configureTabBarAppearance()
        Self.configureNavigationBarAppearance()

        do {
            let schema = Schema([
                BookmarkedVerse.self,
                BookmarkFolder.self,
                CachedShabad.self,
                CachedBani.self,
                CachedHukamnama.self,
                ReadingPosition.self
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

    private static func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Set background to beige (#FDF0D5)
        let beigeColor = UIColor(red: 0.992, green: 0.941, blue: 0.835, alpha: 1.0)
        appearance.backgroundColor = beigeColor

        // Burgundy color for selected (#AB364D)
        let burgundyColor = UIColor(red: 0.671, green: 0.212, blue: 0.302, alpha: 1.0)
        // Dark blue for unselected (#003049)
        let darkBlueColor = UIColor(red: 0.0, green: 0.188, blue: 0.286, alpha: 1.0)

        // Configure item appearance
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = darkBlueColor
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: darkBlueColor]
        itemAppearance.selected.iconColor = burgundyColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: burgundyColor]

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance

        // Also set the tint colors directly for iOS 26 floating tab bar
        UITabBar.appearance().tintColor = burgundyColor
        UITabBar.appearance().unselectedItemTintColor = darkBlueColor
    }

    private static func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // Dark blue for title (#003049)
        let darkBlueColor = UIColor(red: 0.0, green: 0.188, blue: 0.286, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: darkBlueColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: darkBlueColor]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        // Burgundy tint for buttons (#AB364D)
        let burgundyColor = UIColor(red: 0.671, green: 0.212, blue: 0.302, alpha: 1.0)
        UINavigationBar.appearance().tintColor = burgundyColor
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AppRouter())
        }
        .modelContainer(modelContainer)
    }
}

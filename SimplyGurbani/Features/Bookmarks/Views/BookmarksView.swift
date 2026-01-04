import SwiftUI

struct BookmarksView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        List {
            Section {
                // Placeholder for when bookmarks are empty
                ContentUnavailableView {
                    Label("No Bookmarks", systemImage: "bookmark")
                } description: {
                    Text("Save your favorite shabads and verses to access them quickly.")
                } actions: {
                    Button("Browse Gurbani") {
                        router.selectedTab = .browse
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.Colors.saffronFallback)
                }
            }
        }
        .navigationTitle("Bookmarks")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Add folder action
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookmarksView()
    }
    .environment(AppRouter())
}

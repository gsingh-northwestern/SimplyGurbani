import SwiftUI

struct BrowseView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        List {
            Section {
                NavigationLink(value: Route.baniList) {
                    Label("Nitnem Banis", systemImage: "book.closed")
                }

                NavigationLink(value: Route.angPicker(sourceID: "G")) {
                    Label("Sri Guru Granth Sahib Ji", systemImage: "book")
                }

                NavigationLink(value: Route.raagList) {
                    Label("Browse by Raag", systemImage: "music.note.list")
                }

                NavigationLink(value: Route.writerList) {
                    Label("Browse by Writer", systemImage: "person.2")
                }
            } header: {
                Text("Scriptures")
            }

            Section {
                NavigationLink(value: Route.baniReader(baniID: 1)) {
                    BaniRowView(name: "Japji Sahib", icon: "sunrise")
                }

                NavigationLink(value: Route.baniReader(baniID: 2)) {
                    BaniRowView(name: "Rehras Sahib", icon: "sunset")
                }

                NavigationLink(value: Route.baniReader(baniID: 3)) {
                    BaniRowView(name: "Kirtan Sohila", icon: "moon.stars")
                }

                NavigationLink(value: Route.baniReader(baniID: 20)) {
                    BaniRowView(name: "Sukhmani Sahib", icon: "heart.circle")
                }

                NavigationLink(value: Route.baniReader(baniID: 21)) {
                    BaniRowView(name: "Anand Sahib", icon: "sparkles")
                }
            } header: {
                Text("Popular Banis")
            }
        }
        .navigationTitle("Browse")
    }
}

struct BaniRowView: View {
    let name: String
    let icon: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppTheme.Colors.saffronFallback)
                .frame(width: 32)

            Text(name)
        }
    }
}

// Placeholder views
struct BaniListView: View {
    var body: some View {
        Text("Bani List")
            .navigationTitle("All Banis")
    }
}

struct RaagListView: View {
    var body: some View {
        Text("Raag List")
            .navigationTitle("Raags")
    }
}

struct WriterListView: View {
    var body: some View {
        Text("Writer List")
            .navigationTitle("Writers")
    }
}

struct AngPickerView: View {
    let sourceID: String

    var body: some View {
        Text("Ang Picker for \(sourceID)")
            .navigationTitle("Select Ang")
    }
}

#Preview {
    NavigationStack {
        BrowseView()
    }
    .environment(AppRouter())
}

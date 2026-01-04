import SwiftUI

struct SearchView: View {
    @Environment(AppRouter.self) private var router
    @State private var searchText = ""
    @State private var searchHistory: [String] = []

    var body: some View {
        List {
            if searchText.isEmpty {
                Section {
                    ForEach(searchHistory, id: \.self) { query in
                        Button {
                            searchText = query
                            performSearch()
                        } label: {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                Text(query)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Recent Searches")
                }

                Section {
                    Text("Search for Gurbani by entering Gurmukhi, transliteration, or English text.")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Tips")
                }
            } else {
                Section {
                    Button {
                        performSearch()
                    } label: {
                        Label("Search \"\(searchText)\"", systemImage: "magnifyingglass")
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search Gurbani")
        .onSubmit(of: .search) {
            performSearch()
        }
        .navigationTitle("Search")
    }

    private func performSearch() {
        guard !searchText.isEmpty else { return }
        router.searchPath.append(.searchResults(query: searchText))
    }
}

struct SearchResultsView: View {
    let query: String

    var body: some View {
        List {
            Text("Searching for: \(query)")
                .foregroundStyle(.secondary)

            // Placeholder results
            ForEach(0..<5, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sample Gurmukhi Result \(index + 1)")
                        .font(.headline)
                    Text("Sample transliteration")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Results")
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .environment(AppRouter())
}

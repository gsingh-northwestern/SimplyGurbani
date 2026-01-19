import SwiftUI

struct SearchView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = SearchViewModel()

    var body: some View {
        Group {
            if viewModel.hasSearched {
                searchResultsContent
            } else {
                searchHomeContent
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Gurbani")
        .onSubmit(of: .search) {
            Task { await viewModel.search() }
        }
        .onChange(of: viewModel.searchText) { oldValue, newValue in
            if newValue.isEmpty && viewModel.hasSearched {
                viewModel.clearResults()
            }
        }
        .navigationTitle("Search")
    }

    private var searchHomeContent: some View {
        List {
            if !viewModel.searchHistory.isEmpty {
                Section {
                    ForEach(viewModel.searchHistory, id: \.self) { query in
                        Button {
                            viewModel.selectFromHistory(query)
                        } label: {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                Text(query)
                            }
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                    }
                    .onDelete { indexSet in
                        // Remove from history
                    }
                } header: {
                    HStack {
                        Text("Recent Searches")
                        Spacer()
                        Button("Clear") {
                            viewModel.clearHistory()
                        }
                        .font(.caption)
                    }
                }
            }

            Section {
                VStack(alignment: .leading, spacing: 12) {
                    searchTip(icon: "book.closed", text: "Search banis by name (e.g., 'Japji')")
                    searchTip(icon: "textformat.abc", text: "Search verses in romanized text")
                    searchTip(icon: "number", text: "Enter ang number to jump to page")
                }
                .padding(.vertical, 8)
                .listRowBackground(AppTheme.Colors.cardBackground)
            } header: {
                Text("Search Tips")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
    }

    private func searchTip(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.Colors.saffronFallback)
                .frame(width: 24)
            Text(text)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var searchResultsContent: some View {
        Group {
            if viewModel.isSearching {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ContentUnavailableView {
                    Label("Search Failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.search() }
                    }
                }
            } else if !viewModel.hasResults {
                ContentUnavailableView {
                    Label("No Results", systemImage: "magnifyingglass")
                } description: {
                    Text("No results found for \"\(viewModel.searchText)\"")
                } actions: {
                    Button("Clear Search") {
                        viewModel.searchText = ""
                        viewModel.clearResults()
                    }
                }
            } else {
                resultsListView
            }
        }
    }

    private var resultsListView: some View {
        List {
            // Results count header
            Section {
                Text("\(viewModel.totalResultCount) results")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.secondary)
                    .listRowBackground(AppTheme.Colors.cardBackground)
            }

            // Banis section (if any)
            if !viewModel.baniResults.isEmpty {
                Section {
                    ForEach(viewModel.baniResults) { bani in
                        Button {
                            router.searchPath.append(.baniReader(baniID: bani.id))
                        } label: {
                            BaniSearchResultRow(bani: bani)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .listRowBackground(AppTheme.Colors.cardBackground)
                    }
                } header: {
                    Text("Banis")
                }
            }

            // Verses section (if any)
            if !viewModel.verseResults.isEmpty {
                Section {
                    ForEach(viewModel.verseResults) { result in
                        Button {
                            router.searchPath.append(.shabadReader(shabadID: result.shabadID))
                        } label: {
                            SearchResultRow(result: result)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .listRowBackground(AppTheme.Colors.cardBackground)
                    }
                } header: {
                    Text("Verses")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
    }
}

struct SearchResultRow: View {
    let result: SearchResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(result.gurmukhiUnicode)
                .font(.system(size: 18))
                .lineLimit(2)

            if let translit = result.transliteration {
                Text(translit)
                    .font(.system(size: 14, design: .serif))
                    .italic()
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if let translation = result.translation {
                Text(translation)
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                Text("Ang \(result.ang)")
                Spacer()
                Text(result.sourceID == "G" ? "SGGS" : result.sourceID)
            }
            .font(AppTheme.Typography.caption)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

struct BaniSearchResultRow: View {
    let bani: Bani

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bani.gurmukhiUnicode)
                .font(.system(size: 18))

            Text(bani.displayName)
                .font(AppTheme.Typography.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Image(systemName: "book.closed.fill")
                    .foregroundStyle(AppTheme.Colors.saffronFallback)
                Text("Bani")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SearchResultsView: View {
    let query: String
    @Environment(AppRouter.self) private var router
    @State private var viewModel = SearchViewModel()

    var body: some View {
        Group {
            if viewModel.isSearching {
                ProgressView("Searching...")
            } else if !viewModel.hasResults {
                ContentUnavailableView.search(text: query)
            } else {
                List(viewModel.verseResults) { result in
                    Button {
                        router.searchPath.append(.shabadReader(shabadID: result.shabadID))
                    } label: {
                        SearchResultRow(result: result)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(AppTheme.Colors.cardBackground)
                }
                .scrollContentBackground(.hidden)
                .background(AppTheme.Colors.backgroundBeige)
            }
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Results")
        .task {
            viewModel.searchText = query
            await viewModel.search()
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .environment(AppRouter())
}

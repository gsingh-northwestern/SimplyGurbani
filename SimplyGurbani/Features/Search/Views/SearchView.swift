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
                    searchTip(icon: "character.textbox", text: "Type Gurmukhi or transliteration")
                    searchTip(icon: "textformat.abc", text: "Use first letters (e.g., 'sngkdjm')")
                    searchTip(icon: "number", text: "Enter ang number to jump to page")
                }
                .padding(.vertical, 8)
                .listRowBackground(AppTheme.Colors.cardBackground)
            } header: {
                Text("Search Tips")
            }

            Section {
                Picker("Search Type", selection: $viewModel.searchType) {
                    ForEach(SearchType.allCases, id: \.rawValue) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .listRowBackground(AppTheme.Colors.cardBackground)
            } header: {
                Text("Search Mode")
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
            } else if viewModel.results.isEmpty {
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
                List {
                    Section {
                        Text("\(viewModel.results.count) results")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.secondary)
                            .listRowBackground(AppTheme.Colors.cardBackground)
                    }

                    ForEach(viewModel.results) { result in
                        Button {
                            router.searchPath.append(.shabadReader(shabadID: result.shabadID))
                        } label: {
                            SearchResultRow(result: result)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(AppTheme.Colors.backgroundBeige)
            }
        }
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

struct SearchResultsView: View {
    let query: String
    @Environment(AppRouter.self) private var router
    @State private var viewModel = SearchViewModel()

    var body: some View {
        Group {
            if viewModel.isSearching {
                ProgressView("Searching...")
            } else if viewModel.results.isEmpty {
                ContentUnavailableView.search(text: query)
            } else {
                List(viewModel.results) { result in
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

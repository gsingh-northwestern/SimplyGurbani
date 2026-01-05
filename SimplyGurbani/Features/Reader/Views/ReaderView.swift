import SwiftUI
import SwiftData

struct ReaderView: View {
    let shabadID: Int
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ReaderViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ContentUnavailableView {
                    Label("Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.loadShabad(id: shabadID) }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.Colors.saffronFallback)
                }
            } else {
                readerContent
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    bookmarkButton
                    toolbarMenu
                }
            }
        }
        .task {
            await viewModel.loadShabad(id: shabadID)
            viewModel.configureBookmarks(with: modelContext)
            viewModel.refreshBookmarkStatus()
        }
    }

    private var bookmarkButton: some View {
        Button {
            viewModel.bookmarkFirstVerse()
        } label: {
            Image(systemName: viewModel.isFirstVerseBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundStyle(viewModel.isFirstVerseBookmarked ? AppTheme.Colors.saffronFallback : .primary)
        }
    }

    private var readerContent: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.lg) {
                // Header
                if let shabad = viewModel.shabad {
                    headerView(shabad: shabad)
                }

                // Verses
                ForEach(viewModel.verses) { verse in
                    VerseCardView(
                        verse: verse,
                        showGurmukhi: viewModel.showGurmukhi,
                        showTransliteration: viewModel.showTransliteration,
                        showTranslation: viewModel.showTranslation,
                        useLarivaar: viewModel.useLarivaar
                    )
                }

                // Footer
                if let shabad = viewModel.shabad {
                    footerView(shabad: shabad)
                }
            }
            .padding()
        }
    }

    private func headerView(shabad: Shabad) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.sm) {
                if let raag = shabad.raag {
                    Text(raag.gurmukhiUnicode)
                        .font(.system(size: 18))
                        .foregroundStyle(AppTheme.Colors.goldFallback)

                    Text(raag.english)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Label("Ang \(shabad.ang)", systemImage: "book")

                    if let writer = shabad.writer {
                        Spacer()
                        Text(writer.english)
                    }
                }
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.tertiary)
            }
        }
    }

    private func footerView(shabad: Shabad) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Divider()

            Text("\(shabad.sourceName) - Ang \(shabad.ang)")
                .font(AppTheme.Typography.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, AppTheme.Spacing.xl)
    }

    private var toolbarMenu: some View {
        Menu {
            Toggle("Gurmukhi", isOn: $viewModel.showGurmukhi)
            Toggle("Transliteration", isOn: $viewModel.showTransliteration)
            Toggle("Translation", isOn: $viewModel.showTranslation)
            Toggle("Larivaar", isOn: $viewModel.useLarivaar)

            Divider()

            ShareLink(item: viewModel.shareText()) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

struct BaniReaderView: View {
    let baniID: Int
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ReaderViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ContentUnavailableView {
                    Label("Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.loadBani(id: baniID) }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.Colors.saffronFallback)
                }
            } else {
                baniContent
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    bookmarkButton
                    toolbarMenu
                }
            }
        }
        .task {
            await viewModel.loadBani(id: baniID)
            viewModel.configureBookmarks(with: modelContext)
            viewModel.refreshBookmarkStatus()
        }
    }

    private var bookmarkButton: some View {
        Button {
            viewModel.bookmarkFirstVerse()
        } label: {
            Image(systemName: viewModel.isFirstVerseBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundStyle(viewModel.isFirstVerseBookmarked ? AppTheme.Colors.saffronFallback : .primary)
        }
    }

    private var baniContent: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.lg) {
                // Header
                if let bani = viewModel.baniContent {
                    GlassCard {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Text(bani.nameUnicode)
                                .font(.system(size: 24))
                                .foregroundStyle(AppTheme.Colors.saffronFallback)

                            if let translit = bani.transliteration {
                                Text(translit)
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Text("\(bani.verses.count) verses")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }

                // Verses
                ForEach(viewModel.verses) { verse in
                    VerseCardView(
                        verse: verse,
                        showGurmukhi: viewModel.showGurmukhi,
                        showTransliteration: viewModel.showTransliteration,
                        showTranslation: viewModel.showTranslation,
                        useLarivaar: viewModel.useLarivaar
                    )
                }
            }
            .padding()
        }
    }

    private var toolbarMenu: some View {
        Menu {
            Toggle("Gurmukhi", isOn: $viewModel.showGurmukhi)
            Toggle("Transliteration", isOn: $viewModel.showTransliteration)
            Toggle("Translation", isOn: $viewModel.showTranslation)
            Toggle("Larivaar", isOn: $viewModel.useLarivaar)

            Divider()

            ShareLink(item: viewModel.shareText()) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

struct VerseCardView: View {
    let verse: Verse
    let showGurmukhi: Bool
    let showTransliteration: Bool
    let showTranslation: Bool
    let useLarivaar: Bool

    @AppStorage("gurmukhiFontSize") private var gurmukhiFontSize = 24.0

    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.md) {
                if showGurmukhi {
                    Text(useLarivaar ? (verse.larivaarUnicode ?? verse.gurmukhiUnicode) : verse.gurmukhiUnicode)
                        .font(.system(size: gurmukhiFontSize))
                        .multilineTextAlignment(.center)
                        .lineSpacing(gurmukhiFontSize * 0.4)
                }

                if showTransliteration, let translit = verse.transliteration {
                    Text(translit)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .italic()
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                if showTranslation, let translation = verse.translation {
                    Text(translation)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct HukamnamaDetailView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Hukamnama...")
            } else if let hukamnama = viewModel.hukamnama {
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        // Header
                        GlassCard {
                            VStack(spacing: AppTheme.Spacing.sm) {
                                Text("Today's Hukamnama")
                                    .font(AppTheme.Typography.title2)

                                Text(hukamnama.date.formatted(date: .complete, time: .omitted))
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundStyle(.secondary)

                                Text("Sri Harmandir Sahib, Amritsar")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundStyle(.tertiary)

                                Text("Ang \(hukamnama.ang)")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundStyle(AppTheme.Colors.goldFallback)
                            }
                        }

                        // Content
                        GlassCard {
                            VStack(spacing: AppTheme.Spacing.md) {
                                Text(hukamnama.gurmukhi)
                                    .font(.system(size: 22))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(10)

                                if let translit = hukamnama.transliteration {
                                    Divider()
                                    Text(translit)
                                        .font(.system(size: 16, design: .serif))
                                        .italic()
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }

                                if let translation = hukamnama.translation {
                                    Divider()
                                    Text(translation)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text("Could not load today's Hukamnama")
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.loadHukamnama() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hukamnama")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadHukamnama()
        }
    }
}

#Preview {
    NavigationStack {
        ReaderView(shabadID: 1)
    }
    .environment(AppRouter())
}

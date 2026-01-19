import SwiftUI
import SwiftData

struct ReaderView: View {
    let shabadID: Int
    let scrollToVerseID: Int?
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ReaderViewModel()
    @State private var scrollPosition: Int?  // Track topmost verse ID

    // Display settings from UserDefaults - synced with Settings
    @AppStorage("showGurmukhi") private var showGurmukhi = true
    @AppStorage("showTransliteration") private var showTransliteration = true
    @AppStorage("showEnglish") private var showTranslation = true
    @AppStorage("useLarivaar") private var useLarivaar = false

    init(shabadID: Int, scrollToVerseID: Int? = nil) {
        self.shabadID = shabadID
        self.scrollToVerseID = scrollToVerseID
    }

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
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolbarMenu
            }
            ToolbarItem(placement: .topBarTrailing) {
                bookmarkButton
            }
        }
        .task {
            await viewModel.loadShabad(id: shabadID)
            viewModel.configureBookmarks(with: modelContext)
            viewModel.configureReadingPosition(with: modelContext)
            viewModel.refreshBookmarkStatus()

            // Scroll to bookmarked verse if provided, otherwise restore saved position
            if let scrollToVerseID = scrollToVerseID {
                scrollPosition = scrollToVerseID
            } else if let savedPosition = viewModel.getSavedScrollPosition() {
                scrollPosition = savedPosition
            }
        }
        .onChange(of: scrollPosition) { oldValue, newValue in
            if let newValue = newValue {
                viewModel.saveScrollPosition(newValue)
            }
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
                        showGurmukhi: showGurmukhi,
                        showTransliteration: showTransliteration,
                        showTranslation: showTranslation,
                        useLarivaar: useLarivaar
                    )
                    .id(verse.id)  // Enable scroll position tracking
                }

                // Footer
                if let shabad = viewModel.shabad {
                    footerView(shabad: shabad)
                }
            }
            .padding()
            .scrollTargetLayout()  // iOS 17: Enable position tracking
        }
        .scrollPosition(id: $scrollPosition, anchor: .top)  // iOS 17: Track top verse
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
            .frame(maxWidth: .infinity)
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
            Toggle("Gurmukhi", isOn: $showGurmukhi)
            Toggle("Transliteration", isOn: $showTransliteration)
            Toggle("Translation", isOn: $showTranslation)
            Toggle("Larivaar", isOn: $useLarivaar)

            Divider()

            ShareLink(item: viewModel.shareText(showTransliteration: showTransliteration, showTranslation: showTranslation)) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

struct BaniReaderView: View {
    let baniID: Int
    let scrollToVerseID: Int?
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ReaderViewModel()
    @State private var scrollPosition: Int?  // Track topmost verse ID

    // Display settings from UserDefaults - synced with Settings
    @AppStorage("showGurmukhi") private var showGurmukhi = true
    @AppStorage("showTransliteration") private var showTransliteration = true
    @AppStorage("showEnglish") private var showTranslation = true
    @AppStorage("useLarivaar") private var useLarivaar = false

    init(baniID: Int, scrollToVerseID: Int? = nil) {
        self.baniID = baniID
        self.scrollToVerseID = scrollToVerseID
    }

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
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolbarMenu
            }
            ToolbarItem(placement: .topBarTrailing) {
                bookmarkButton
            }
        }
        .task {
            await viewModel.loadBani(id: baniID)
            viewModel.configureBookmarks(with: modelContext)
            viewModel.configureReadingPosition(with: modelContext)
            viewModel.refreshBookmarkStatus()

            // Scroll to bookmarked verse if provided, otherwise restore saved position
            if let scrollToVerseID = scrollToVerseID {
                scrollPosition = scrollToVerseID
            } else if let savedPosition = viewModel.getSavedScrollPosition() {
                scrollPosition = savedPosition
            }
        }
        .onChange(of: scrollPosition) { oldValue, newValue in
            if let newValue = newValue {
                viewModel.saveScrollPosition(newValue)
            }
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

                            Text(bani.displayName)
                                .font(AppTheme.Typography.subheadline)
                                .foregroundStyle(.secondary)

                            Text("\(bani.verses.count) verses")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                // Verses
                ForEach(viewModel.verses) { verse in
                    VerseCardView(
                        verse: verse,
                        showGurmukhi: showGurmukhi,
                        showTransliteration: showTransliteration,
                        showTranslation: showTranslation,
                        useLarivaar: useLarivaar
                    )
                    .id(verse.id)  // Enable scroll position tracking
                }
            }
            .padding()
            .scrollTargetLayout()  // iOS 17: Enable position tracking
        }
        .scrollPosition(id: $scrollPosition, anchor: .top)  // iOS 17: Track top verse
    }

    private var toolbarMenu: some View {
        Menu {
            Toggle("Gurmukhi", isOn: $showGurmukhi)
            Toggle("Transliteration", isOn: $showTransliteration)
            Toggle("Translation", isOn: $showTranslation)
            Toggle("Larivaar", isOn: $useLarivaar)

            Divider()

            ShareLink(item: viewModel.shareText(showTransliteration: showTransliteration, showTranslation: showTranslation)) {
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
                            .frame(maxWidth: .infinity)
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
        .background(AppTheme.Colors.backgroundBeige)
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

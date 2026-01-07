import SwiftUI
import SwiftData

struct AngReaderView: View {
    let angNumber: Int
    let sourceID: String

    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ReaderViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Ang \(viewModel.currentAngNumber ?? angNumber)...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                ContentUnavailableView {
                    Label("Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await viewModel.loadAng(number: angNumber, sourceID: sourceID) }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.Colors.primaryBurgundy)
                }
            } else {
                angContent
            }
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Ang \(viewModel.currentAngNumber ?? angNumber)")
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
            await viewModel.loadAng(number: angNumber, sourceID: sourceID)
            viewModel.configureBookmarks(with: modelContext)
            viewModel.refreshBookmarkStatus()
        }
    }

    private var bookmarkButton: some View {
        Button {
            viewModel.bookmarkFirstVerse()
        } label: {
            Image(systemName: viewModel.isFirstVerseBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundStyle(viewModel.isFirstVerseBookmarked ? AppTheme.Colors.primaryBurgundy : .primary)
        }
    }

    private var angContent: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.lg) {
                // Header
                headerView

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

                // Pagination
                paginationControls

                // Footer
                footerView
            }
            .padding()
        }
    }

    private var headerView: some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Ang \(viewModel.currentAngNumber ?? angNumber)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.primaryBurgundy)

                if let shabad = viewModel.shabad, let raag = shabad.raag {
                    Text(raag.gurmukhiUnicode)
                        .font(.system(size: 18))
                        .foregroundStyle(AppTheme.Colors.secondaryBlue)

                    Text(raag.english)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(sourceDisplayName)
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var sourceDisplayName: String {
        switch sourceID {
        case "G": return "Sri Guru Granth Sahib Ji"
        case "D": return "Dasam Granth"
        case "B": return "Bhai Gurdas Ji Vaaran"
        default: return sourceID
        }
    }

    private var paginationControls: some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            Button {
                Task { await viewModel.goToPreviousAng() }
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Ang \((viewModel.currentAngNumber ?? angNumber) - 1)")
                }
                .font(AppTheme.Typography.subheadline)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.Colors.textPrimary)
            .disabled(!viewModel.canGoToPreviousAng || viewModel.isLoading)

            Spacer()

            Button {
                Task { await viewModel.goToNextAng() }
            } label: {
                HStack {
                    Text("Ang \((viewModel.currentAngNumber ?? angNumber) + 1)")
                    Image(systemName: "chevron.right")
                }
                .font(AppTheme.Typography.subheadline)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
            }
            .buttonStyle(.bordered)
            .tint(AppTheme.Colors.textPrimary)
            .disabled(!viewModel.canGoToNextAng || viewModel.isLoading)
        }
        .padding(.vertical, AppTheme.Spacing.md)
    }

    private var footerView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Divider()

            if let shabad = viewModel.shabad {
                Text("\(shabad.sourceName) - Ang \(viewModel.currentAngNumber ?? angNumber)")
                    .font(AppTheme.Typography.footnote)
                    .foregroundStyle(.tertiary)
            }

            Text("\(viewModel.verses.count) verses on this ang")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.quaternary)
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

#Preview {
    NavigationStack {
        AngReaderView(angNumber: 1, sourceID: "G")
    }
    .environment(AppRouter())
}

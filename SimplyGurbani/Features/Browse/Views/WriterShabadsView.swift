import SwiftUI

struct WriterShabadsView: View {
    let writerID: Int
    let writerName: String
    let writerGurmukhi: String

    @Environment(AppRouter.self) private var router
    @State private var shabads: [SearchResult] = []
    @State private var isLoading = true
    @State private var error: APIError?

    // Group results by shabad to show unique shabads
    private var uniqueShabads: [SearchResult] {
        var seen = Set<Int>()
        return shabads.filter { result in
            if seen.contains(result.shabadID) {
                return false
            }
            seen.insert(result.shabadID)
            return true
        }
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading shabads...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error {
                errorView(error: error)
            } else if uniqueShabads.isEmpty {
                emptyView
            } else {
                shabadListContent
            }
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle(writerName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadShabads()
        }
    }

    private func errorView(error: APIError) -> some View {
        ContentUnavailableView {
            Label("Error Loading Shabads", systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.localizedDescription)
        } actions: {
            Button("Try Again") {
                Task { await loadShabads() }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.Colors.primaryBurgundy)
        }
    }

    private var emptyView: some View {
        ContentUnavailableView {
            Label("No Shabads Found", systemImage: "doc.text.magnifyingglass")
        } description: {
            Text("No shabads found for \(writerName)")
        }
    }

    private var shabadListContent: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                // Header with writer info
                headerView

                // Shabad list
                ForEach(uniqueShabads) { result in
                    Button {
                        router.browsePath.append(Route.shabadReader(shabadID: result.shabadID))
                    } label: {
                        shabadRowView(result: result)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    private var headerView: some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.sm) {
                Text(writerGurmukhi)
                    .font(.system(size: 28))
                    .foregroundStyle(AppTheme.Colors.primaryBurgundy)

                Text(writerName)
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text("\(uniqueShabads.count) shabads")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private func shabadRowView(result: SearchResult) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                // First line in Gurmukhi
                Text(result.gurmukhiUnicode)
                    .font(.system(size: 18))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .lineLimit(2)

                // Transliteration
                if let transliteration = result.transliteration {
                    Text(transliteration)
                        .font(.system(size: 14, design: .serif))
                        .italic()
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                // Metadata row
                HStack {
                    Label("Ang \(result.ang)", systemImage: "book")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(.tertiary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }

    private func loadShabads() async {
        isLoading = true
        error = nil

        do {
            shabads = try await GurbaniService.shared.searchByWriter(writerID: writerID)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        WriterShabadsView(
            writerID: 1,
            writerName: "Guru Nanak Dev Ji",
            writerGurmukhi: "ਮਹਲਾ ੧"
        )
    }
    .environment(AppRouter())
}

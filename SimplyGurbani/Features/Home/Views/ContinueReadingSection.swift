import SwiftUI
import SwiftData

struct ContinueReadingSection: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var recentItems: [ReadingPosition] = []

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Continue Reading")
                .font(AppTheme.Typography.title3)
                .padding(.horizontal)

            if recentItems.isEmpty {
                emptyStateView
            } else {
                ForEach(recentItems, id: \.contentKey) { item in
                    Button {
                        navigateToContent(item)
                    } label: {
                        ContinueReadingCard(item: item)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
        }
        .task {
            loadHistory()
        }
        .onChange(of: router.selectedTab) { _, newValue in
            // Refresh when returning to home tab
            if newValue == .home {
                loadHistory()
            }
        }
    }

    private var emptyStateView: some View {
        GlassCard {
            VStack(spacing: 8) {
                Image(systemName: "book.closed")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("No reading history yet")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.secondary)
                Text("Start reading to see your recent banis and shabads here")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
        }
        .padding(.horizontal)
    }

    private func loadHistory() {
        let service = ReadingPositionService(modelContext: modelContext)
        recentItems = service.getRecentHistory(limit: 3)
    }

    private func navigateToContent(_ item: ReadingPosition) {
        switch item.contentType {
        case "shabad":
            router.homePath.append(.shabadReader(shabadID: item.contentID))
        case "bani":
            router.navigateToBani(item.contentID)
        case "ang":
            router.homePath.append(.angReader(ang: item.contentID, sourceID: item.sourceID))
        default:
            break
        }
    }
}

struct ContinueReadingCard: View {
    let item: ReadingPosition

    var body: some View {
        GlassCard {
            HStack(spacing: AppTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: 6) {
                    // Title
                    Text(item.displayName)
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(AppTheme.Colors.accentDarkBlue)

                    // Gurmukhi preview
                    Text(item.gurmukhiPreview)
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .foregroundStyle(.primary)

                    // Transliteration or progress indicator
                    if let translit = item.transliterationPreview {
                        Text(translit)
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    // Last read timestamp
                    Text(timeAgoString(from: item.lastReadAt))
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)

        if let day = components.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else {
            return "Just now"
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            ContinueReadingSection()
        }
    }
    .environment(AppRouter())
    .modelContainer(for: ReadingPosition.self, inMemory: true)
}

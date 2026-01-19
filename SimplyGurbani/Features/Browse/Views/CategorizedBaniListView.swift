import SwiftUI

struct CategorizedBaniListView: View {
    @Environment(AppRouter.self) private var router
    @State private var allBanis: [Bani] = []
    @State private var isLoading = true
    @State private var error: Error?

    // Group banis by category
    private var categorizedBanis: [(category: BaniCategory, banis: [Bani])] {
        BaniCategory.allCases.compactMap { category in
            let banisInCategory = allBanis.filter { category.contains(baniID: $0.id) }
            if banisInCategory.isEmpty {
                return nil
            }
            return (category: category, banis: banisInCategory)
        }
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading Banis...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error {
                errorView(error: error)
            } else {
                categorizedListContent
            }
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("All Banis")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadBanis()
        }
    }

    private func errorView(error: Error) -> some View {
        ContentUnavailableView {
            Label("Unable to Load", systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.localizedDescription)
        } actions: {
            Button("Try Again") {
                Task { await loadBanis() }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.Colors.primaryBurgundy)
        }
    }

    private var categorizedListContent: some View {
        List {
            ForEach(categorizedBanis, id: \.category.id) { item in
                Section {
                    ForEach(item.banis) { bani in
                        Button {
                            router.browsePath.append(Route.baniReader(baniID: bani.id))
                        } label: {
                            baniRowView(bani: bani)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                    }
                } header: {
                    categoryHeader(category: item.category, count: item.banis.count)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
    }

    private func categoryHeader(category: BaniCategory, count: Int) -> some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: category.icon)
                .foregroundStyle(AppTheme.Colors.primaryBurgundy)
            Text(category.displayName)
            Spacer()
            Text("\(count)")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.tertiary)
        }
    }

    private func baniRowView(bani: Bani) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(bani.gurmukhiUnicode)
                    .font(.system(size: 18))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text(bani.displayName)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private func loadBanis() async {
        isLoading = true
        error = nil
        do {
            allBanis = try await GurbaniService.shared.fetchBaniList()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        CategorizedBaniListView()
    }
    .environment(AppRouter())
}

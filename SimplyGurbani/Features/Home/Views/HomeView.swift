import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Hukamnama Card
                HukamnamaCard()
                    .padding(.horizontal)

                // Quick Access Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Quick Access")
                        .font(AppTheme.Typography.title3)
                        .padding(.horizontal)

                    QuickAccessGrid()
                }

                // Recent Activity
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Continue Reading")
                        .font(AppTheme.Typography.title3)
                        .padding(.horizontal)

                    // Placeholder for recent items
                    GlassCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Japji Sahib")
                                    .font(AppTheme.Typography.headline)
                                Text("Pauri 15")
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Simply Gurbani")
    }
}

struct HukamnamaCard: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        Button {
            router.homePath.append(.hukamnamaReader())
        } label: {
            GlassCard {
                VStack(spacing: AppTheme.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Hukamnama")
                                .font(AppTheme.Typography.headline)
                            Text("Sri Harmandir Sahib")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "sun.max.fill")
                            .font(.title2)
                            .foregroundStyle(AppTheme.Colors.goldFallback)
                    }

                    Divider()

                    // Placeholder Gurmukhi text
                    Text("Loading Hukamnama...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.lg)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct QuickAccessGrid: View {
    @Environment(AppRouter.self) private var router

    let banis: [(id: Int, name: String, icon: String)] = [
        (1, "Japji Sahib", "sunrise"),
        (2, "Rehras Sahib", "sunset"),
        (3, "Kirtan Sohila", "moon.stars"),
        (20, "Sukhmani Sahib", "heart.circle"),
        (21, "Anand Sahib", "sparkles"),
        (22, "Asa di Var", "music.note")
    ]

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: AppTheme.Spacing.md) {
            ForEach(banis, id: \.id) { bani in
                Button {
                    router.navigateToBani(bani.id)
                } label: {
                    GlassCard(padding: AppTheme.Spacing.md) {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Image(systemName: bani.icon)
                                .font(.title2)
                                .foregroundStyle(AppTheme.Colors.saffronFallback)

                            Text(bani.name)
                                .font(AppTheme.Typography.caption)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppRouter())
}

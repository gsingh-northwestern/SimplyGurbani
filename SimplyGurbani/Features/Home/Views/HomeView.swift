import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Hukamnama Card
                HukamnamaCard(viewModel: viewModel)
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

                    Button {
                        router.navigateToBani(WellKnownBani.japjiSahib.rawValue)
                    } label: {
                        GlassCard {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Japji Sahib")
                                        .font(AppTheme.Typography.headline)
                                    Text("Start reading")
                                        .font(AppTheme.Typography.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Simply Gurbani")
        .task {
            await viewModel.loadHukamnama()
        }
    }
}

struct HukamnamaCard: View {
    @Environment(AppRouter.self) private var router
    let viewModel: HomeViewModel

    var body: some View {
        Button {
            if let shabadID = viewModel.hukamnama?.shabadID {
                router.homePath.append(.shabadReader(shabadID: shabadID))
            } else {
                router.homePath.append(.hukamnamaReader())
            }
        } label: {
            GlassCard {
                VStack(spacing: AppTheme.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Hukamnama")
                                .font(AppTheme.Typography.headline)
                            HStack(spacing: 4) {
                                Text("Sri Harmandir Sahib")
                                if let ang = viewModel.hukamnama?.ang {
                                    Text("• Ang \(ang)")
                                }
                            }
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "sun.max.fill")
                            .font(.title2)
                            .foregroundStyle(AppTheme.Colors.goldFallback)
                    }

                    Divider()

                    // Hukamnama content
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.lg)
                    } else if let hukamnama = viewModel.hukamnama {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Text(hukamnama.gurmukhi)
                                .font(.system(size: 18))
                                .lineLimit(3)
                                .multilineTextAlignment(.center)

                            if let transliteration = hukamnama.transliteration {
                                Text(transliteration)
                                    .font(AppTheme.Typography.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                    } else if viewModel.error != nil {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.secondary)
                            Text("Unable to load Hukamnama")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct QuickAccessGrid: View {
    @Environment(AppRouter.self) private var router

    let banis: [WellKnownBani] = [
        .japjiSahib,
        .rehrasSahib,
        .kirtanSohila,
        .sukhmaniSahib,
        .anandSahib,
        .asaDiVar
    ]

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: AppTheme.Spacing.md) {
            ForEach(banis, id: \.rawValue) { bani in
                Button {
                    router.navigateToBani(bani.rawValue)
                } label: {
                    Text(bani.displayName)
                        .font(AppTheme.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 40)
                        .padding(AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                                .fill(AppTheme.Colors.accentDarkBlue)
                        )
                        .shadow(
                            color: AppTheme.Colors.accentDarkBlue.opacity(0.2),
                            radius: 6,
                            x: 0,
                            y: 3
                        )
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

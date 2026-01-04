import SwiftUI

struct ReaderView: View {
    let shabadID: Int
    @Environment(AppRouter.self) private var router
    @AppStorage("showGurmukhi") private var showGurmukhi = true
    @AppStorage("showTransliteration") private var showTransliteration = true
    @AppStorage("showEnglish") private var showEnglish = true
    @AppStorage("gurmukhiFontSize") private var gurmukhiFontSize = 24.0

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.lg) {
                // Placeholder content
                ForEach(0..<5, id: \.self) { index in
                    VerseCardView(
                        gurmukhi: "ਸਤਿ ਨਾਮੁ ਕਰਤਾ ਪੁਰਖੁ ਨਿਰਭਉ ਨਿਰਵੈਰੁ",
                        transliteration: "Sat Naam Kartaa Purakh Nirbhau Nirvair",
                        translation: "True is His Name, Creative His Personality, without fear, without enmity.",
                        showGurmukhi: showGurmukhi,
                        showTransliteration: showTransliteration,
                        showTranslation: showEnglish,
                        gurmukhiFontSize: gurmukhiFontSize
                    )
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Shabad \(shabadID)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Toggle("Gurmukhi", isOn: $showGurmukhi)
                    Toggle("Transliteration", isOn: $showTransliteration)
                    Toggle("English", isOn: $showEnglish)

                    Divider()

                    Button {
                        // Share action
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }

                    Button {
                        // Bookmark action
                    } label: {
                        Label("Bookmark", systemImage: "bookmark")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

struct VerseCardView: View {
    let gurmukhi: String
    let transliteration: String
    let translation: String
    let showGurmukhi: Bool
    let showTransliteration: Bool
    let showTranslation: Bool
    let gurmukhiFontSize: CGFloat

    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.md) {
                if showGurmukhi {
                    Text(gurmukhi)
                        .gurmukhiStyle(size: gurmukhiFontSize)
                }

                if showTransliteration {
                    Text(transliteration)
                        .transliterationStyle()
                }

                if showTranslation {
                    Text(translation)
                        .translationStyle()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct BaniReaderView: View {
    let baniID: Int

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                Text("Loading Bani \(baniID)...")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Bani")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HukamnamaDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Header
                GlassCard {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("Today's Hukamnama")
                            .font(AppTheme.Typography.title2)

                        Text(Date.now.formatted(date: .complete, time: .omitted))
                            .font(AppTheme.Typography.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Sri Harmandir Sahib, Amritsar")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                // Placeholder content
                GlassCard {
                    Text("Loading Hukamnama...")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.xxxl)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hukamnama")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ReaderView(shabadID: 1)
    }
    .environment(AppRouter())
}

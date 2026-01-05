import SwiftUI

struct SettingsView: View {
    @Environment(AppRouter.self) private var router

    // Display settings
    @AppStorage("showGurmukhi") private var showGurmukhi = true
    @AppStorage("showTransliteration") private var showTransliteration = true
    @AppStorage("showEnglish") private var showEnglish = true
    @AppStorage("useLarivaar") private var useLarivaar = false

    // Typography settings
    @AppStorage("gurmukhiFontSize") private var gurmukhiFontSize = 24.0
    @AppStorage("translitFontSize") private var translitFontSize = 16.0
    @AppStorage("translationFontSize") private var translationFontSize = 15.0

    // Search settings
    @AppStorage("defaultSearchType") private var defaultSearchType = "firstLetter"

    // Theme settings
    @AppStorage("prefersDarkMode") private var prefersDarkMode: Bool?

    var body: some View {
        List {
            displaySection
            typographySection
            searchSection
            cacheSection
            aboutSection
            versionSection
        }
        .navigationTitle("Settings")
    }

    private var displaySection: some View {
        Section {
            Toggle("Gurmukhi", isOn: $showGurmukhi)
            Toggle("Transliteration", isOn: $showTransliteration)
            Toggle("English Translation", isOn: $showEnglish)
            Toggle("Larivaar", isOn: $useLarivaar)
        } header: {
            Text("Display Options")
        } footer: {
            Text("Larivaar displays Gurmukhi without spaces, the traditional manuscript format.")
        }
    }

    private var typographySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Gurmukhi Size")
                    Spacer()
                    Text("\(Int(gurmukhiFontSize))")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $gurmukhiFontSize, in: 16...48, step: 2)

                // Preview
                Text("ੴ ਸਤਿ ਨਾਮੁ")
                    .font(.system(size: gurmukhiFontSize))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Transliteration Size")
                    Spacer()
                    Text("\(Int(translitFontSize))")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $translitFontSize, in: 12...24, step: 1)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Translation Size")
                    Spacer()
                    Text("\(Int(translationFontSize))")
                        .foregroundStyle(.secondary)
                }
                Slider(value: $translationFontSize, in: 12...22, step: 1)
            }

            Button("Reset to Defaults") {
                gurmukhiFontSize = 24.0
                translitFontSize = 16.0
                translationFontSize = 15.0
            }
            .foregroundStyle(AppTheme.Colors.saffronFallback)
        } header: {
            Text("Typography")
        }
    }

    private var searchSection: some View {
        Section {
            Picker("Default Search Mode", selection: $defaultSearchType) {
                Text("First Letter").tag("firstLetter")
                Text("Full Word").tag("fullWord")
                Text("Gurmukhi").tag("gurmukhi")
            }
        } header: {
            Text("Search")
        } footer: {
            Text("First Letter search matches the first letters of each word (e.g., 'sngkdjm' finds 'satnam waheguru').")
        }
    }

    private var cacheSection: some View {
        Section {
            Button("Clear Search History") {
                UserDefaults.standard.removeObject(forKey: "searchHistory")
            }

            Button("Clear Cached Content") {
                GurbaniService.shared.clearCache()
            }
            .foregroundStyle(.red)

            if let stats = GurbaniService.shared.cacheStats {
                HStack {
                    Text("Cached Items")
                    Spacer()
                    Text("\(stats.shabads) shabads, \(stats.banis) banis")
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("Data")
        }
    }

    private var aboutSection: some View {
        Section {
            NavigationLink(value: Route.about) {
                Label("About Simply Gurbani", systemImage: "info.circle")
            }

            Link(destination: URL(string: "https://banidb.com")!) {
                HStack {
                    Label("BaniDB API", systemImage: "link")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)

            Link(destination: URL(string: "https://github.com/KhsalakFoundation/banidb")!) {
                HStack {
                    Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        } header: {
            Text("About")
        }
    }

    private var versionSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Build")
                Spacer()
                Text("1")
                    .foregroundStyle(.secondary)
            }
        } footer: {
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Built with love for the Sangat")
                    .font(AppTheme.Typography.caption)
                Image(systemName: "heart.fill")
                    .foregroundStyle(AppTheme.Colors.saffronFallback)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, AppTheme.Spacing.lg)
        }
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: AppTheme.Spacing.lg) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(AppTheme.Colors.saffronFallback)

                    Text("Simply Gurbani")
                        .font(AppTheme.Typography.title)

                    Text("An accessible, beautiful way to read and explore Gurbani.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.xl)
            }

            Section {
                Text("Simply Gurbani provides access to Sri Guru Granth Sahib Ji, Nitnem banis, and other sacred Sikh scriptures. All content is served via the BaniDB API.")
                    .font(AppTheme.Typography.subheadline)
            } header: {
                Text("About")
            }

            Section {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    acknowledgementRow(name: "BaniDB", description: "Open-source Gurbani database")
                    acknowledgementRow(name: "GurbaniNow", description: "Gurbani search and display")
                    acknowledgementRow(name: "Khalis Foundation", description: "Sikh technology nonprofit")
                }
            } header: {
                Text("Acknowledgements")
            }

            Section {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Content Sources")
                        .font(AppTheme.Typography.headline)
                    Text("• Sri Guru Granth Sahib Ji")
                    Text("• Sri Dasam Granth Sahib")
                    Text("• Bhai Gurdas Vaaran")
                    Text("• Bhai Nand Lal Bani")
                }
                .font(AppTheme.Typography.subheadline)
            } header: {
                Text("Scriptures")
            }
        }
        .navigationTitle("About")
    }

    private func acknowledgementRow(name: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(AppTheme.Typography.headline)
            Text(description)
                .font(AppTheme.Typography.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppRouter())
}

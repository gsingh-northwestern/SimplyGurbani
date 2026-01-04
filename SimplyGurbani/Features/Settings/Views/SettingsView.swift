import SwiftUI

struct SettingsView: View {
    @Environment(AppRouter.self) private var router
    @AppStorage("showGurmukhi") private var showGurmukhi = true
    @AppStorage("showTransliteration") private var showTransliteration = true
    @AppStorage("showEnglish") private var showEnglish = true
    @AppStorage("useLarivaar") private var useLarivaar = false
    @AppStorage("gurmukhiFontSize") private var gurmukhiFontSize = 24.0

    var body: some View {
        List {
            Section {
                Toggle("Gurmukhi", isOn: $showGurmukhi)
                Toggle("Transliteration", isOn: $showTransliteration)
                Toggle("English Translation", isOn: $showEnglish)
                Toggle("Larivaar", isOn: $useLarivaar)
            } header: {
                Text("Display Options")
            } footer: {
                Text("Larivaar displays Gurmukhi without spaces, the traditional format.")
            }

            Section {
                VStack(alignment: .leading) {
                    Text("Gurmukhi Font Size: \(Int(gurmukhiFontSize))")
                    Slider(value: $gurmukhiFontSize, in: 16...40, step: 2)
                }
            } header: {
                Text("Typography")
            }

            Section {
                NavigationLink(value: Route.about) {
                    Label("About", systemImage: "info.circle")
                }

                Link(destination: URL(string: "https://banidb.com")!) {
                    Label("BaniDB API", systemImage: "link")
                }
            } header: {
                Text("About")
            }

            Section {
                Text("Version 1.0.0")
                    .foregroundStyle(.secondary)
            } footer: {
                Text("Built with love for the Sangat")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Settings")
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
                Text("Simply Gurbani provides access to Sri Guru Granth Sahib Ji, Nitnem banis, and other sacred Sikh scriptures. Content is provided via the BaniDB API.")
                    .font(AppTheme.Typography.subheadline)
            } header: {
                Text("About")
            }

            Section {
                Text("BaniDB")
                Text("GurbaniNow")
                Text("Khalis Foundation")
            } header: {
                Text("Acknowledgements")
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppRouter())
}

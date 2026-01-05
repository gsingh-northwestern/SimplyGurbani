import SwiftUI

struct BrowseView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Scriptures Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Scriptures")
                        .font(AppTheme.Typography.title3)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .padding(.horizontal)

                    GlassCard(padding: 0) {
                        VStack(spacing: 0) {
                            BrowseRowLink(
                                title: "Nitnem Banis",
                                icon: "book.closed",
                                destination: Route.baniList
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Sri Guru Granth Sahib Ji",
                                icon: "book",
                                destination: Route.angPicker(sourceID: "G")
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Browse by Raag",
                                icon: "music.note.list",
                                destination: Route.raagList
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Browse by Writer",
                                icon: "person.2",
                                destination: Route.writerList
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // Popular Banis Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Popular Banis")
                        .font(AppTheme.Typography.title3)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .padding(.horizontal)

                    GlassCard(padding: 0) {
                        VStack(spacing: 0) {
                            BrowseRowLink(
                                title: "Japji Sahib",
                                icon: "sunrise",
                                destination: Route.baniReader(baniID: WellKnownBani.japjiSahib.rawValue)
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Rehras Sahib",
                                icon: "sunset",
                                destination: Route.baniReader(baniID: WellKnownBani.rehrasSahib.rawValue)
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Kirtan Sohila",
                                icon: "moon.stars",
                                destination: Route.baniReader(baniID: WellKnownBani.kirtanSohila.rawValue)
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Sukhmani Sahib",
                                icon: "heart.circle",
                                destination: Route.baniReader(baniID: WellKnownBani.sukhmaniSahib.rawValue)
                            )
                            Divider().padding(.leading, 52)
                            BrowseRowLink(
                                title: "Anand Sahib",
                                icon: "sparkles",
                                destination: Route.baniReader(baniID: WellKnownBani.anandSahib.rawValue)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Browse")
    }
}

/// Reusable row component for browse navigation
struct BrowseRowLink: View {
    @Environment(AppRouter.self) private var router
    let title: String
    let icon: String
    let destination: Route

    var body: some View {
        Button {
            router.browsePath.append(destination)
        } label: {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(AppTheme.Colors.primaryBurgundy)
                    .frame(width: 28)

                Text(title)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct BaniRowView: View {
    let name: String
    let icon: String

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppTheme.Colors.saffronFallback)
                .frame(width: 32)

            Text(name)
        }
    }
}

// MARK: - Bani List View

struct BaniListView: View {
    @Environment(AppRouter.self) private var router
    @State private var banis: [Bani] = []
    @State private var isLoading = true
    @State private var error: Error?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading Banis...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error {
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Try Again") {
                        Task { await loadBanis() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.Colors.saffronFallback)
                }
            } else {
                List(banis) { bani in
                    NavigationLink(value: Route.baniReader(baniID: bani.id)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bani.gurmukhiUnicode)
                                .font(.system(size: 18))
                            if let transliteration = bani.transliteration {
                                Text(transliteration)
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(AppTheme.Colors.cardBackground)
                }
                .scrollContentBackground(.hidden)
                .background(AppTheme.Colors.backgroundBeige)
            }
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("All Banis")
        .task {
            await loadBanis()
        }
    }

    private func loadBanis() async {
        isLoading = true
        error = nil
        do {
            banis = try await GurbaniService.shared.fetchBaniList()
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

// MARK: - Ang Picker View

struct AngPickerView: View {
    @Environment(AppRouter.self) private var router
    let sourceID: String

    @State private var selectedAng: Int = 1

    private let maxAng: Int = 1430

    var body: some View {
        List {
            Section {
                VStack(spacing: AppTheme.Spacing.lg) {
                    Text("Select an Ang (Page)")
                        .font(AppTheme.Typography.headline)

                    HStack {
                        TextField("Ang", value: $selectedAng, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.center)

                        Stepper("", value: $selectedAng, in: 1...maxAng)
                            .labelsHidden()
                    }
                    .padding(.horizontal)

                    Slider(value: Binding(
                        get: { Double(selectedAng) },
                        set: { selectedAng = Int($0) }
                    ), in: 1...Double(maxAng), step: 1)

                    Button {
                        router.browsePath.append(Route.angReader(ang: selectedAng, sourceID: sourceID))
                    } label: {
                        Label("Go to Ang \(selectedAng)", systemImage: "arrow.right.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.Colors.saffronFallback)
                }
                .padding(.vertical)
                .listRowBackground(AppTheme.Colors.cardBackground)
            }

            Section {
                Button {
                    selectedAng = 1
                    router.browsePath.append(Route.angReader(ang: 1, sourceID: sourceID))
                } label: {
                    Label("Mool Mantar (Ang 1)", systemImage: "sunrise")
                }
                .listRowBackground(AppTheme.Colors.cardBackground)

                Button {
                    selectedAng = 1
                    router.browsePath.append(Route.baniReader(baniID: 1))
                } label: {
                    Label("Japji Sahib (Ang 1-8)", systemImage: "book")
                }
                .listRowBackground(AppTheme.Colors.cardBackground)

                Button {
                    selectedAng = 718
                    router.browsePath.append(Route.angReader(ang: 718, sourceID: sourceID))
                } label: {
                    Label("Middle (Ang 718)", systemImage: "arrow.left.and.right")
                }
                .listRowBackground(AppTheme.Colors.cardBackground)

                Button {
                    selectedAng = 1430
                    router.browsePath.append(Route.angReader(ang: 1430, sourceID: sourceID))
                } label: {
                    Label("Mundavani (Ang 1429-1430)", systemImage: "sunset")
                }
                .listRowBackground(AppTheme.Colors.cardBackground)
            } header: {
                Text("Quick Jump")
            }

            Section {
                Text("Sri Guru Granth Sahib Ji contains 1430 angs (pages), from Mool Mantar to Mundavani and Ragmala.")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.secondary)
                    .listRowBackground(AppTheme.Colors.cardBackground)
            } header: {
                Text("About")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Select Ang")
    }
}

// MARK: - Raag List View

struct RaagListView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        List(GurbaniRaag.allCases) { raag in
            Button {
                router.browsePath.append(Route.angReader(ang: raag.startAng, sourceID: "G"))
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(raag.gurmukhiName)
                            .font(.system(size: 18))
                        Text(raag.englishName)
                            .font(AppTheme.Typography.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Ang \(raag.startAng)-\(raag.endAng)")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.vertical, 4)
            }
            .foregroundStyle(.primary)
            .listRowBackground(AppTheme.Colors.cardBackground)
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Raags")
    }
}

/// All 31 Raags in Sri Guru Granth Sahib Ji with their ang ranges
enum GurbaniRaag: String, CaseIterable, Identifiable {
    case sriRaag = "Sri Raag"
    case majh = "Majh"
    case gauri = "Gauri"
    case asa = "Asa"
    case gujri = "Gujri"
    case devGandhari = "Devgandhari"
    case bihagra = "Bihagra"
    case vadhans = "Vadhans"
    case sorath = "Sorath"
    case dhanasri = "Dhanasri"
    case jaitsri = "Jaitsri"
    case todi = "Todi"
    case bairari = "Bairari"
    case tilang = "Tilang"
    case suhi = "Suhi"
    case bilaval = "Bilaval"
    case gaund = "Gaund"
    case ramkali = "Ramkali"
    case natNarain = "Nat Narain"
    case maliGaura = "Mali Gaura"
    case maru = "Maru"
    case tukhari = "Tukhari"
    case kedara = "Kedara"
    case bhairav = "Bhairav"
    case basant = "Basant"
    case sarang = "Sarang"
    case malar = "Malar"
    case kanra = "Kanra"
    case kalyan = "Kalyan"
    case prabhati = "Prabhati"
    case jaijawanti = "Jaijawanti"

    var id: String { rawValue }

    var englishName: String { rawValue }

    var gurmukhiName: String {
        switch self {
        case .sriRaag: return "ਸਿਰੀ ਰਾਗੁ"
        case .majh: return "ਮਾਝ"
        case .gauri: return "ਗਉੜੀ"
        case .asa: return "ਆਸਾ"
        case .gujri: return "ਗੂਜਰੀ"
        case .devGandhari: return "ਦੇਵਗੰਧਾਰੀ"
        case .bihagra: return "ਬਿਹਾਗੜਾ"
        case .vadhans: return "ਵਡਹੰਸੁ"
        case .sorath: return "ਸੋਰਠਿ"
        case .dhanasri: return "ਧਨਾਸਰੀ"
        case .jaitsri: return "ਜੈਤਸਰੀ"
        case .todi: return "ਟੋਡੀ"
        case .bairari: return "ਬੈਰਾੜੀ"
        case .tilang: return "ਤਿਲੰਗ"
        case .suhi: return "ਸੂਹੀ"
        case .bilaval: return "ਬਿਲਾਵਲੁ"
        case .gaund: return "ਗੋਂਡ"
        case .ramkali: return "ਰਾਮਕਲੀ"
        case .natNarain: return "ਨਟ ਨਾਰਾਇਨ"
        case .maliGaura: return "ਮਾਲੀ ਗਉੜਾ"
        case .maru: return "ਮਾਰੂ"
        case .tukhari: return "ਤੁਖਾਰੀ"
        case .kedara: return "ਕੇਦਾਰਾ"
        case .bhairav: return "ਭੈਰਉ"
        case .basant: return "ਬਸੰਤੁ"
        case .sarang: return "ਸਾਰੰਗ"
        case .malar: return "ਮਲਾਰ"
        case .kanra: return "ਕਾਨੜਾ"
        case .kalyan: return "ਕਲਿਆਨ"
        case .prabhati: return "ਪ੍ਰਭਾਤੀ"
        case .jaijawanti: return "ਜੈਜਾਵੰਤੀ"
        }
    }

    var startAng: Int {
        switch self {
        case .sriRaag: return 14
        case .majh: return 94
        case .gauri: return 151
        case .asa: return 347
        case .gujri: return 489
        case .devGandhari: return 527
        case .bihagra: return 537
        case .vadhans: return 557
        case .sorath: return 595
        case .dhanasri: return 660
        case .jaitsri: return 696
        case .todi: return 711
        case .bairari: return 719
        case .tilang: return 721
        case .suhi: return 728
        case .bilaval: return 795
        case .gaund: return 858
        case .ramkali: return 876
        case .natNarain: return 975
        case .maliGaura: return 984
        case .maru: return 989
        case .tukhari: return 1107
        case .kedara: return 1118
        case .bhairav: return 1125
        case .basant: return 1168
        case .sarang: return 1197
        case .malar: return 1254
        case .kanra: return 1294
        case .kalyan: return 1319
        case .prabhati: return 1327
        case .jaijawanti: return 1352
        }
    }

    var endAng: Int {
        switch self {
        case .sriRaag: return 93
        case .majh: return 150
        case .gauri: return 346
        case .asa: return 488
        case .gujri: return 526
        case .devGandhari: return 536
        case .bihagra: return 556
        case .vadhans: return 594
        case .sorath: return 659
        case .dhanasri: return 695
        case .jaitsri: return 710
        case .todi: return 718
        case .bairari: return 720
        case .tilang: return 727
        case .suhi: return 794
        case .bilaval: return 857
        case .gaund: return 875
        case .ramkali: return 974
        case .natNarain: return 983
        case .maliGaura: return 988
        case .maru: return 1106
        case .tukhari: return 1117
        case .kedara: return 1124
        case .bhairav: return 1167
        case .basant: return 1196
        case .sarang: return 1253
        case .malar: return 1293
        case .kanra: return 1318
        case .kalyan: return 1326
        case .prabhati: return 1351
        case .jaijawanti: return 1353
        }
    }
}

// MARK: - Writer List View

struct WriterListView: View {
    var body: some View {
        List {
            Section {
                ForEach(GurbaniWriter.gurus) { writer in
                    WriterRowView(writer: writer)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                }
            } header: {
                Text("Sikh Gurus")
            }

            Section {
                ForEach(GurbaniWriter.bhagats) { writer in
                    WriterRowView(writer: writer)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                }
            } header: {
                Text("Bhagats")
            }

            Section {
                ForEach(GurbaniWriter.others) { writer in
                    WriterRowView(writer: writer)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                }
            } header: {
                Text("Others")
            }

            Section {
                Text("Sri Guru Granth Sahib Ji contains the writings of 6 Sikh Gurus, 15 Bhagats, 11 Bhatts, and other contributors.")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.secondary)
                    .listRowBackground(AppTheme.Colors.cardBackground)
            } header: {
                Text("About")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle("Writers")
    }
}

struct WriterRowView: View {
    let writer: GurbaniWriter

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(writer.gurmukhiName)
                    .font(.system(size: 18))
                Text(writer.englishName)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let shabadCount = writer.shabadCount {
                Text("\(shabadCount) shabads")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

/// Writers in Sri Guru Granth Sahib Ji
struct GurbaniWriter: Identifiable {
    let id: Int
    let gurmukhiName: String
    let englishName: String
    let shabadCount: Int?

    static let gurus: [GurbaniWriter] = [
        GurbaniWriter(id: 1, gurmukhiName: "ਮਹਲਾ ੧", englishName: "Guru Nanak Dev Ji", shabadCount: 974),
        GurbaniWriter(id: 2, gurmukhiName: "ਮਹਲਾ ੨", englishName: "Guru Angad Dev Ji", shabadCount: 62),
        GurbaniWriter(id: 3, gurmukhiName: "ਮਹਲਾ ੩", englishName: "Guru Amar Das Ji", shabadCount: 907),
        GurbaniWriter(id: 4, gurmukhiName: "ਮਹਲਾ ੪", englishName: "Guru Ram Das Ji", shabadCount: 679),
        GurbaniWriter(id: 5, gurmukhiName: "ਮਹਲਾ ੫", englishName: "Guru Arjan Dev Ji", shabadCount: 2218),
        GurbaniWriter(id: 6, gurmukhiName: "ਮਹਲਾ ੯", englishName: "Guru Tegh Bahadur Ji", shabadCount: 115)
    ]

    static let bhagats: [GurbaniWriter] = [
        GurbaniWriter(id: 10, gurmukhiName: "ਭਗਤ ਕਬੀਰ ਜੀ", englishName: "Bhagat Kabir Ji", shabadCount: 541),
        GurbaniWriter(id: 11, gurmukhiName: "ਭਗਤ ਨਾਮਦੇਵ ਜੀ", englishName: "Bhagat Namdev Ji", shabadCount: 60),
        GurbaniWriter(id: 12, gurmukhiName: "ਭਗਤ ਰਵਿਦਾਸ ਜੀ", englishName: "Bhagat Ravidas Ji", shabadCount: 41),
        GurbaniWriter(id: 13, gurmukhiName: "ਸ਼ੇਖ ਫ਼ਰੀਦ ਜੀ", englishName: "Sheikh Farid Ji", shabadCount: 134),
        GurbaniWriter(id: 14, gurmukhiName: "ਭਗਤ ਤ੍ਰਿਲੋਚਨ ਜੀ", englishName: "Bhagat Trilochan Ji", shabadCount: 4),
        GurbaniWriter(id: 15, gurmukhiName: "ਭਗਤ ਧੰਨਾ ਜੀ", englishName: "Bhagat Dhanna Ji", shabadCount: 4),
        GurbaniWriter(id: 16, gurmukhiName: "ਭਗਤ ਬੇਣੀ ਜੀ", englishName: "Bhagat Beni Ji", shabadCount: 3),
        GurbaniWriter(id: 17, gurmukhiName: "ਭਗਤ ਸੈਣ ਜੀ", englishName: "Bhagat Sain Ji", shabadCount: 1),
        GurbaniWriter(id: 18, gurmukhiName: "ਭਗਤ ਪੀਪਾ ਜੀ", englishName: "Bhagat Pipa Ji", shabadCount: 1),
        GurbaniWriter(id: 19, gurmukhiName: "ਭਗਤ ਸਧਨਾ ਜੀ", englishName: "Bhagat Sadhna Ji", shabadCount: 1),
        GurbaniWriter(id: 20, gurmukhiName: "ਭਗਤ ਰਾਮਾਨੰਦ ਜੀ", englishName: "Bhagat Ramanand Ji", shabadCount: 1),
        GurbaniWriter(id: 21, gurmukhiName: "ਭਗਤ ਪਰਮਾਨੰਦ ਜੀ", englishName: "Bhagat Parmanand Ji", shabadCount: 1),
        GurbaniWriter(id: 22, gurmukhiName: "ਭਗਤ ਸੂਰਦਾਸ ਜੀ", englishName: "Bhagat Surdas Ji", shabadCount: 1),
        GurbaniWriter(id: 23, gurmukhiName: "ਭਗਤ ਜੈਦੇਵ ਜੀ", englishName: "Bhagat Jaidev Ji", shabadCount: 2),
        GurbaniWriter(id: 24, gurmukhiName: "ਭਗਤ ਭੀਖਨ ਜੀ", englishName: "Bhagat Bhikhan Ji", shabadCount: 2)
    ]

    static let others: [GurbaniWriter] = [
        GurbaniWriter(id: 30, gurmukhiName: "ਭਾਈ ਮਰਦਾਨਾ ਜੀ", englishName: "Bhai Mardana Ji", shabadCount: 3),
        GurbaniWriter(id: 31, gurmukhiName: "ਭਾਈ ਸੱਤਾ ਤੇ ਬਲਵੰਡ", englishName: "Bhai Satta & Balwand", shabadCount: 1),
        GurbaniWriter(id: 32, gurmukhiName: "ਭੱਟ", englishName: "Bhatts (11 poets)", shabadCount: 123),
        GurbaniWriter(id: 33, gurmukhiName: "ਭਾਈ ਸੁੰਦਰ ਜੀ", englishName: "Bhai Sundar Ji", shabadCount: 6)
    ]
}

#Preview {
    NavigationStack {
        BrowseView()
    }
    .environment(AppRouter())
}

import Foundation

/// Represents a navigable section within a bani
struct BaniSection: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let gurmukhiName: String
    let startVerseID: Int
    let sectionNumber: Int?  // e.g., pauri number

    init(id: String? = nil, name: String, gurmukhiName: String, startVerseID: Int, sectionNumber: Int? = nil) {
        self.id = id ?? "\(startVerseID)"
        self.name = name
        self.gurmukhiName = gurmukhiName
        self.startVerseID = startVerseID
        self.sectionNumber = sectionNumber
    }
}

/// Provides section mappings for known banis
enum BaniSectionData {

    /// Get sections for a bani by ID
    static func sections(for baniID: Int) -> [BaniSection]? {
        switch baniID {
        case 2:
            return japjiSahibSections
        case 4:
            return jaapSahibSections
        case 6:
            return tavPrasadSvaiyeSections
        case 9:
            return chaupaiSahibSections
        case 10:
            return anandSahibSections
        case 21:
            return rehrasSahibSections
        case 23:
            return kirtanSohilaSections
        case 31:
            return sukhmaniSahibSections
        case 90:
            return asaDiVarSections
        default:
            return nil
        }
    }

    /// Check if a bani has section data available
    static func hasSections(for baniID: Int) -> Bool {
        sections(for: baniID) != nil
    }

    // MARK: - Japji Sahib (Bani ID: 2)
    // 38 Pauris + Mool Mantar + Saloks
    // Verse IDs verified from BaniDB API

    static let japjiSahibSections: [BaniSection] = [
        BaniSection(name: "Mool Mantar", gurmukhiName: "ੴ ਮੂਲ ਮੰਤਰ", startVerseID: 12, sectionNumber: nil),
        BaniSection(name: "Jap", gurmukhiName: "॥ ਜਪੁ ॥", startVerseID: 13, sectionNumber: nil),
        BaniSection(name: "Salok", gurmukhiName: "ਸਲੋਕੁ", startVerseID: 14, sectionNumber: nil),
        BaniSection(name: "Pauri 1", gurmukhiName: "ਪਉੜੀ ੧", startVerseID: 16, sectionNumber: 1),
        BaniSection(name: "Pauri 2", gurmukhiName: "ਪਉੜੀ ੨", startVerseID: 22, sectionNumber: 2),
        BaniSection(name: "Pauri 3", gurmukhiName: "ਪਉੜੀ ੩", startVerseID: 28, sectionNumber: 3),
        BaniSection(name: "Pauri 4", gurmukhiName: "ਪਉੜੀ ੪", startVerseID: 42, sectionNumber: 4),
        BaniSection(name: "Pauri 5", gurmukhiName: "ਪਉੜੀ ੫", startVerseID: 49, sectionNumber: 5),
        BaniSection(name: "Pauri 6", gurmukhiName: "ਪਉੜੀ ੬", startVerseID: 60, sectionNumber: 6),
        BaniSection(name: "Pauri 7", gurmukhiName: "ਪਉੜੀ ੭", startVerseID: 65, sectionNumber: 7),
        BaniSection(name: "Pauri 8", gurmukhiName: "ਪਉੜੀ ੮", startVerseID: 72, sectionNumber: 8),
        BaniSection(name: "Pauri 9", gurmukhiName: "ਪਉੜੀ ੯", startVerseID: 78, sectionNumber: 9),
        BaniSection(name: "Pauri 10", gurmukhiName: "ਪਉੜੀ ੧੦", startVerseID: 84, sectionNumber: 10),
        BaniSection(name: "Pauri 11", gurmukhiName: "ਪਉੜੀ ੧੧", startVerseID: 90, sectionNumber: 11),
        BaniSection(name: "Pauri 12", gurmukhiName: "ਪਉੜੀ ੧੨", startVerseID: 96, sectionNumber: 12),
        BaniSection(name: "Pauri 13", gurmukhiName: "ਪਉੜੀ ੧੩", startVerseID: 102, sectionNumber: 13),
        BaniSection(name: "Pauri 14", gurmukhiName: "ਪਉੜੀ ੧੪", startVerseID: 108, sectionNumber: 14),
        BaniSection(name: "Pauri 15", gurmukhiName: "ਪਉੜੀ ੧੫", startVerseID: 114, sectionNumber: 15),
        BaniSection(name: "Pauri 16", gurmukhiName: "ਪਉੜੀ ੧੬", startVerseID: 120, sectionNumber: 16),
        BaniSection(name: "Pauri 17", gurmukhiName: "ਪਉੜੀ ੧੭", startVerseID: 144, sectionNumber: 17),
        BaniSection(name: "Pauri 18", gurmukhiName: "ਪਉੜੀ ੧੮", startVerseID: 156, sectionNumber: 18),
        BaniSection(name: "Pauri 19", gurmukhiName: "ਪਉੜੀ ੧੯", startVerseID: 168, sectionNumber: 19),
        BaniSection(name: "Pauri 20", gurmukhiName: "ਪਉੜੀ ੨੦", startVerseID: 183, sectionNumber: 20),
        BaniSection(name: "Pauri 21", gurmukhiName: "ਪਉੜੀ ੨੧", startVerseID: 193, sectionNumber: 21),
        BaniSection(name: "Pauri 22", gurmukhiName: "ਪਉੜੀ ੨੨", startVerseID: 211, sectionNumber: 22),
        BaniSection(name: "Pauri 23", gurmukhiName: "ਪਉੜੀ ੨੩", startVerseID: 216, sectionNumber: 23),
        BaniSection(name: "Pauri 24", gurmukhiName: "ਪਉੜੀ ੨੪", startVerseID: 220, sectionNumber: 24),
        BaniSection(name: "Pauri 25", gurmukhiName: "ਪਉੜੀ ੨੫", startVerseID: 236, sectionNumber: 25),
        BaniSection(name: "Pauri 26", gurmukhiName: "ਪਉੜੀ ੨੬", startVerseID: 253, sectionNumber: 26),
        BaniSection(name: "Pauri 27", gurmukhiName: "ਪਉੜੀ ੨੭", startVerseID: 279, sectionNumber: 27),
        BaniSection(name: "Pauri 28", gurmukhiName: "ਪਉੜੀ ੨੮", startVerseID: 301, sectionNumber: 28),
        BaniSection(name: "Pauri 29", gurmukhiName: "ਪਉੜੀ ੨੯", startVerseID: 306, sectionNumber: 29),
        BaniSection(name: "Pauri 30", gurmukhiName: "ਪਉੜੀ ੩੦", startVerseID: 311, sectionNumber: 30),
        BaniSection(name: "Pauri 31", gurmukhiName: "ਪਉੜੀ ੩੧", startVerseID: 317, sectionNumber: 31),
        BaniSection(name: "Pauri 32", gurmukhiName: "ਪਉੜੀ ੩੨", startVerseID: 323, sectionNumber: 32),
        BaniSection(name: "Pauri 33", gurmukhiName: "ਪਉੜੀ ੩੩", startVerseID: 328, sectionNumber: 33),
        BaniSection(name: "Pauri 34", gurmukhiName: "ਪਉੜੀ ੩੪", startVerseID: 336, sectionNumber: 34),
        BaniSection(name: "Pauri 35", gurmukhiName: "ਪਉੜੀ ੩੫", startVerseID: 347, sectionNumber: 35),
        BaniSection(name: "Pauri 36", gurmukhiName: "ਪਉੜੀ ੩੬", startVerseID: 357, sectionNumber: 36),
        BaniSection(name: "Pauri 37", gurmukhiName: "ਪਉੜੀ ੩੭", startVerseID: 365, sectionNumber: 37),
        BaniSection(name: "Pauri 38", gurmukhiName: "ਪਉੜੀ ੩੮", startVerseID: 383, sectionNumber: 38),
        BaniSection(name: "Salok (Closing)", gurmukhiName: "ਸਲੋਕੁ", startVerseID: 390, sectionNumber: nil),
    ]

    // MARK: - Jaap Sahib (Bani ID: 4)
    // Organized by Chhand types
    // Verse IDs verified from BaniDB API

    static let jaapSahibSections: [BaniSection] = [
        BaniSection(name: "Opening", gurmukhiName: "ੴ ਸਤਿਗੁਰ ਪ੍ਰਸਾਦਿ", startVerseID: 504, sectionNumber: nil),
        BaniSection(name: "Chhapai Chhand", gurmukhiName: "ਛਪੈ ਛੰਦ", startVerseID: 508, sectionNumber: 1),
        BaniSection(name: "Bhujang Prayaat 1", gurmukhiName: "ਭੁਜੰਗ ਪ੍ਰਯਾਤ ਛੰਦ", startVerseID: 515, sectionNumber: 2),
        BaniSection(name: "Chachri 1", gurmukhiName: "ਚਾਚਰੀ ਛੰਦ", startVerseID: 624, sectionNumber: 3),
        BaniSection(name: "Bhujang Prayaat 2", gurmukhiName: "ਭੁਜੰਗ ਪ੍ਰਯਾਤ ਛੰਦ", startVerseID: 685, sectionNumber: 4),
        BaniSection(name: "Chachri 2", gurmukhiName: "ਚਾਚਰੀ ਛੰਦ", startVerseID: 743, sectionNumber: 5),
        BaniSection(name: "Bhujang Prayaat 3", gurmukhiName: "ਭੁਜੰਗ ਪ੍ਰਯਾਤ ਛੰਦ", startVerseID: 752, sectionNumber: 6),
        BaniSection(name: "Charpat Chhand 1", gurmukhiName: "ਚਰਪਟ ਛੰਦ", startVerseID: 792, sectionNumber: 7),
        BaniSection(name: "Rooaal Chhand", gurmukhiName: "ਰੂਆਲ ਛੰਦ", startVerseID: 813, sectionNumber: 8),
        BaniSection(name: "Madhubhar 1", gurmukhiName: "ਮਧੁਭਾਰ ਛੰਦ", startVerseID: 846, sectionNumber: 9),
        BaniSection(name: "Chachri 3", gurmukhiName: "ਚਾਚਰੀ ਛੰਦ", startVerseID: 875, sectionNumber: 10),
        BaniSection(name: "Bhujang Prayaat 4", gurmukhiName: "ਭੁਜੰਗ ਪ੍ਰਯਾਤ ਛੰਦ", startVerseID: 884, sectionNumber: 11),
        BaniSection(name: "Chachri 4", gurmukhiName: "ਚਾਚਰੀ ਛੰਦ", startVerseID: 897, sectionNumber: 12),
        BaniSection(name: "Bhagwati Chhand 1", gurmukhiName: "ਭਗਵਤੀ ਛੰਦ", startVerseID: 914, sectionNumber: 13),
        BaniSection(name: "Chachri 5", gurmukhiName: "ਚਾਚਰੀ ਛੰਦ", startVerseID: 1035, sectionNumber: 14),
        BaniSection(name: "Charpat Chhand 2", gurmukhiName: "ਚਰਪਟ ਛੰਦ", startVerseID: 1072, sectionNumber: 15),
        BaniSection(name: "Rasaval Chhand", gurmukhiName: "ਰਸਾਵਲ ਛੰਦ", startVerseID: 1085, sectionNumber: 16),
        BaniSection(name: "Bhagwati Chhand 2", gurmukhiName: "ਭਗਵਤੀ ਛੰਦ", startVerseID: 1106, sectionNumber: 17),
        BaniSection(name: "Madhubhar 2", gurmukhiName: "ਮਧੁਭਾਰ ਛੰਦ", startVerseID: 1151, sectionNumber: 18),
        BaniSection(name: "Haribolmana Chhand", gurmukhiName: "ਹਰਿਬੋਲਮਨਾ ਛੰਦ", startVerseID: 1192, sectionNumber: 19),
        BaniSection(name: "Bhujang Prayaat 5", gurmukhiName: "ਭੁਜੰਗ ਪ੍ਰਯਾਤ ਛੰਦ", startVerseID: 1249, sectionNumber: 20),
        BaniSection(name: "Ek Achari Chhand", gurmukhiName: "ਏਕ ਅਛਰੀ ਛੰਦ", startVerseID: 1266, sectionNumber: 21),
        BaniSection(name: "Bhujang Prayaat 6", gurmukhiName: "ਭੁਜੰਗ ਪ੍ਰਯਾਤ ਛੰਦ", startVerseID: 1299, sectionNumber: 22),
    ]

    // MARK: - Tav Prasad Svaiye (Bani ID: 6)
    // 10 Svaiye from Dasam Granth
    // Verse IDs verified from BaniDB API

    static let tavPrasadSvaiyeSections: [BaniSection] = [
        BaniSection(name: "Opening", gurmukhiName: "ੴ ਸਤਿਗੁਰ ਪ੍ਰਸਾਦਿ", startVerseID: 1402, sectionNumber: nil),
        BaniSection(name: "Svaiye 1", gurmukhiName: "ਸਵੱਯਾ ੧", startVerseID: 1405, sectionNumber: 1),
        BaniSection(name: "Svaiye 2", gurmukhiName: "ਸਵੱਯਾ ੨", startVerseID: 1409, sectionNumber: 2),
        BaniSection(name: "Svaiye 3", gurmukhiName: "ਸਵੱਯਾ ੩", startVerseID: 1413, sectionNumber: 3),
        BaniSection(name: "Svaiye 4", gurmukhiName: "ਸਵੱਯਾ ੪", startVerseID: 1417, sectionNumber: 4),
        BaniSection(name: "Svaiye 5", gurmukhiName: "ਸਵੱਯਾ ੫", startVerseID: 1421, sectionNumber: 5),
        BaniSection(name: "Svaiye 6", gurmukhiName: "ਸਵੱਯਾ ੬", startVerseID: 1425, sectionNumber: 6),
        BaniSection(name: "Svaiye 7", gurmukhiName: "ਸਵੱਯਾ ੭", startVerseID: 1429, sectionNumber: 7),
        BaniSection(name: "Svaiye 8", gurmukhiName: "ਸਵੱਯਾ ੮", startVerseID: 1433, sectionNumber: 8),
        BaniSection(name: "Svaiye 9", gurmukhiName: "ਸਵੱਯਾ ੯", startVerseID: 1437, sectionNumber: 9),
        BaniSection(name: "Svaiye 10", gurmukhiName: "ਸਵੱਯਾ ੧੦", startVerseID: 1441, sectionNumber: 10),
    ]

    // MARK: - Chaupai Sahib (Bani ID: 9)
    // Benti Chaupai from Dasam Granth
    // Verse IDs verified from BaniDB API

    static let chaupaiSahibSections: [BaniSection] = [
        BaniSection(name: "Dohra (Opening)", gurmukhiName: "ਦੋਹਰਾ", startVerseID: 1581, sectionNumber: nil),
        BaniSection(name: "Chaupai", gurmukhiName: "ਚੌਪਈ", startVerseID: 1586, sectionNumber: 1),
        BaniSection(name: "Arril", gurmukhiName: "ਅੜਿੱਲ", startVerseID: 1625, sectionNumber: 2),
        BaniSection(name: "Chaupai (Continued)", gurmukhiName: "ਚੌਪਈ", startVerseID: 1629, sectionNumber: 3),
        BaniSection(name: "Dohra (Closing)", gurmukhiName: "ਦੋਹਰਾ", startVerseID: 1745, sectionNumber: nil),
    ]

    // MARK: - Anand Sahib (Bani ID: 10)
    // 40 Pauris by Guru Amar Das Ji
    // Verse IDs verified from BaniDB API

    static let anandSahibSections: [BaniSection] = [
        BaniSection(name: "Pauri 1", gurmukhiName: "ਪਉੜੀ ੧", startVerseID: 1786, sectionNumber: 1),
        BaniSection(name: "Pauri 2", gurmukhiName: "ਪਉੜੀ ੨", startVerseID: 1791, sectionNumber: 2),
        BaniSection(name: "Pauri 3", gurmukhiName: "ਪਉੜੀ ੩", startVerseID: 1796, sectionNumber: 3),
        BaniSection(name: "Pauri 4", gurmukhiName: "ਪਉੜੀ ੪", startVerseID: 1801, sectionNumber: 4),
        BaniSection(name: "Pauri 5", gurmukhiName: "ਪਉੜੀ ੫", startVerseID: 1807, sectionNumber: 5),
        BaniSection(name: "Pauri 6", gurmukhiName: "ਪਉੜੀ ੬", startVerseID: 1812, sectionNumber: 6),
        BaniSection(name: "Pauri 7", gurmukhiName: "ਪਉੜੀ ੭", startVerseID: 1817, sectionNumber: 7),
        BaniSection(name: "Pauri 8", gurmukhiName: "ਪਉੜੀ ੮", startVerseID: 1822, sectionNumber: 8),
        BaniSection(name: "Pauri 9", gurmukhiName: "ਪਉੜੀ ੯", startVerseID: 1827, sectionNumber: 9),
        BaniSection(name: "Pauri 10", gurmukhiName: "ਪਉੜੀ ੧੦", startVerseID: 1832, sectionNumber: 10),
        BaniSection(name: "Pauri 11", gurmukhiName: "ਪਉੜੀ ੧੧", startVerseID: 1838, sectionNumber: 11),
        BaniSection(name: "Pauri 12", gurmukhiName: "ਪਉੜੀ ੧੨", startVerseID: 1844, sectionNumber: 12),
        BaniSection(name: "Pauri 13", gurmukhiName: "ਪਉੜੀ ੧੩", startVerseID: 1849, sectionNumber: 13),
        BaniSection(name: "Pauri 14", gurmukhiName: "ਪਉੜੀ ੧੪", startVerseID: 1854, sectionNumber: 14),
        BaniSection(name: "Pauri 15", gurmukhiName: "ਪਉੜੀ ੧੫", startVerseID: 1860, sectionNumber: 15),
        BaniSection(name: "Pauri 16", gurmukhiName: "ਪਉੜੀ ੧੬", startVerseID: 1865, sectionNumber: 16),
        BaniSection(name: "Pauri 17", gurmukhiName: "ਪਉੜੀ ੧੭", startVerseID: 1870, sectionNumber: 17),
        BaniSection(name: "Pauri 18", gurmukhiName: "ਪਉੜੀ ੧੮", startVerseID: 1875, sectionNumber: 18),
        BaniSection(name: "Pauri 19", gurmukhiName: "ਪਉੜੀ ੧੯", startVerseID: 1880, sectionNumber: 19),
        BaniSection(name: "Pauri 20", gurmukhiName: "ਪਉੜੀ ੨੦", startVerseID: 1885, sectionNumber: 20),
        BaniSection(name: "Pauri 21", gurmukhiName: "ਪਉੜੀ ੨੧", startVerseID: 1890, sectionNumber: 21),
        BaniSection(name: "Pauri 22", gurmukhiName: "ਪਉੜੀ ੨੨", startVerseID: 1895, sectionNumber: 22),
        BaniSection(name: "Pauri 23", gurmukhiName: "ਪਉੜੀ ੨੩", startVerseID: 1900, sectionNumber: 23),
        BaniSection(name: "Pauri 24", gurmukhiName: "ਪਉੜੀ ੨੪", startVerseID: 1905, sectionNumber: 24),
        BaniSection(name: "Pauri 25", gurmukhiName: "ਪਉੜੀ ੨੫", startVerseID: 1911, sectionNumber: 25),
        BaniSection(name: "Pauri 26", gurmukhiName: "ਪਉੜੀ ੨੬", startVerseID: 1916, sectionNumber: 26),
        BaniSection(name: "Pauri 27", gurmukhiName: "ਪਉੜੀ ੨੭", startVerseID: 1921, sectionNumber: 27),
        BaniSection(name: "Pauri 28", gurmukhiName: "ਪਉੜੀ ੨੮", startVerseID: 1926, sectionNumber: 28),
        BaniSection(name: "Pauri 29", gurmukhiName: "ਪਉੜੀ ੨੯", startVerseID: 1931, sectionNumber: 29),
        BaniSection(name: "Pauri 30", gurmukhiName: "ਪਉੜੀ ੩੦", startVerseID: 1937, sectionNumber: 30),
        BaniSection(name: "Pauri 31", gurmukhiName: "ਪਉੜੀ ੩੧", startVerseID: 1942, sectionNumber: 31),
        BaniSection(name: "Pauri 32", gurmukhiName: "ਪਉੜੀ ੩੨", startVerseID: 1947, sectionNumber: 32),
        BaniSection(name: "Pauri 33", gurmukhiName: "ਪਉੜੀ ੩੩", startVerseID: 1952, sectionNumber: 33),
        BaniSection(name: "Pauri 34", gurmukhiName: "ਪਉੜੀ ੩੪", startVerseID: 1957, sectionNumber: 34),
        BaniSection(name: "Pauri 35", gurmukhiName: "ਪਉੜੀ ੩੫", startVerseID: 1963, sectionNumber: 35),
        BaniSection(name: "Pauri 36", gurmukhiName: "ਪਉੜੀ ੩੬", startVerseID: 1968, sectionNumber: 36),
        BaniSection(name: "Pauri 37", gurmukhiName: "ਪਉੜੀ ੩੭", startVerseID: 1973, sectionNumber: 37),
        BaniSection(name: "Pauri 38", gurmukhiName: "ਪਉੜੀ ੩੮", startVerseID: 1978, sectionNumber: 38),
        BaniSection(name: "Pauri 39", gurmukhiName: "ਪਉੜੀ ੩੯", startVerseID: 1983, sectionNumber: 39),
        BaniSection(name: "Pauri 40", gurmukhiName: "ਪਉੜੀ ੪੦", startVerseID: 1988, sectionNumber: 40),
    ]

    // MARK: - Rehras Sahib (Bani ID: 21)
    // Evening prayer combining multiple shabads
    // Verse IDs verified from BaniDB API

    static let rehrasSahibSections: [BaniSection] = [
        BaniSection(name: "So Dar", gurmukhiName: "ਸੋ ਦਰੁ", startVerseID: 2648, sectionNumber: 1),
        BaniSection(name: "So Dar - Asa M:1", gurmukhiName: "ਆਸਾ ਮਹਲਾ ੧", startVerseID: 2672, sectionNumber: 2),
        BaniSection(name: "So Dar - Asa M:1", gurmukhiName: "ਆਸਾ ਮਹਲਾ ੧", startVerseID: 2691, sectionNumber: 3),
        BaniSection(name: "Gujri M:4", gurmukhiName: "ਗੂਜਰੀ ਮਹਲਾ ੪", startVerseID: 2710, sectionNumber: 4),
        BaniSection(name: "Gujri M:5", gurmukhiName: "ਗੂਜਰੀ ਮਹਲਾ ੫", startVerseID: 2721, sectionNumber: 5),
        BaniSection(name: "So Purakh", gurmukhiName: "ਸੋ ਪੁਰਖੁ", startVerseID: 2733, sectionNumber: 6),
        BaniSection(name: "Asa M:4", gurmukhiName: "ਆਸਾ ਮਹਲਾ ੪", startVerseID: 2760, sectionNumber: 7),
        BaniSection(name: "Asa M:1", gurmukhiName: "ਆਸਾ ਮਹਲਾ ੧", startVerseID: 2779, sectionNumber: 8),
        BaniSection(name: "Asa M:5", gurmukhiName: "ਆਸਾ ਮਹਲਾ ੫", startVerseID: 2786, sectionNumber: 9),
        BaniSection(name: "Chaupai Sahib", gurmukhiName: "ਚੌਪਈ ਸਾਹਿਬ", startVerseID: 2797, sectionNumber: 10),
        BaniSection(name: "Anand Sahib (6 Pauris)", gurmukhiName: "ਅਨੰਦੁ ਸਾਹਿਬ", startVerseID: 3097, sectionNumber: 11),
        BaniSection(name: "Mundavani", gurmukhiName: "ਮੁੰਦਾਵਣੀ", startVerseID: 3138, sectionNumber: 12),
        BaniSection(name: "Salok M:5", gurmukhiName: "ਸਲੋਕ ਮਃ ੫", startVerseID: 3153, sectionNumber: 13),
        BaniSection(name: "Dohras", gurmukhiName: "ਦੋਹਰੇ", startVerseID: 3176, sectionNumber: 14),
    ]

    // MARK: - Kirtan Sohila (Bani ID: 23)
    // 5 Shabads - bedtime prayer
    // Verse IDs verified from BaniDB API

    static let kirtanSohilaSections: [BaniSection] = [
        BaniSection(name: "Gauri Deepaki M:1", gurmukhiName: "ਗਉੜੀ ਦੀਪਕੀ ਮਹਲਾ ੧", startVerseID: 3594, sectionNumber: 1),
        BaniSection(name: "Asa M:1", gurmukhiName: "ਆਸਾ ਮਹਲਾ ੧", startVerseID: 3606, sectionNumber: 2),
        BaniSection(name: "Dhanasari M:1 (Aarti)", gurmukhiName: "ਧਨਾਸਰੀ ਮਹਲਾ ੧", startVerseID: 3614, sectionNumber: 3),
        BaniSection(name: "Gauri Poorbi M:4", gurmukhiName: "ਗਉੜੀ ਪੂਰਬੀ ਮਹਲਾ ੪", startVerseID: 3627, sectionNumber: 4),
        BaniSection(name: "Gauri Poorbi M:5", gurmukhiName: "ਗਉੜੀ ਪੂਰਬੀ ਮਹਲਾ ੫", startVerseID: 3638, sectionNumber: 5),
    ]

    // MARK: - Sukhmani Sahib (Bani ID: 31)
    // 24 Ashtpadis by Guru Arjan Dev Ji
    // Verse IDs verified from BaniDB API

    static let sukhmaniSahibSections: [BaniSection] = [
        BaniSection(name: "Salok & Ashtpadi 1", gurmukhiName: "ਅਸਟਪਦੀ ੧", startVerseID: 5232, sectionNumber: 1),
        BaniSection(name: "Salok & Ashtpadi 2", gurmukhiName: "ਅਸਟਪਦੀ ੨", startVerseID: 5321, sectionNumber: 2),
        BaniSection(name: "Salok & Ashtpadi 3", gurmukhiName: "ਅਸਟਪਦੀ ੩", startVerseID: 5405, sectionNumber: 3),
        BaniSection(name: "Salok & Ashtpadi 4", gurmukhiName: "ਅਸਟਪਦੀ ੪", startVerseID: 5489, sectionNumber: 4),
        BaniSection(name: "Salok & Ashtpadi 5", gurmukhiName: "ਅਸਟਪਦੀ ੫", startVerseID: 5572, sectionNumber: 5),
        BaniSection(name: "Salok & Ashtpadi 6", gurmukhiName: "ਅਸਟਪਦੀ ੬", startVerseID: 5655, sectionNumber: 6),
        BaniSection(name: "Salok & Ashtpadi 7", gurmukhiName: "ਅਸਟਪਦੀ ੭", startVerseID: 5739, sectionNumber: 7),
        BaniSection(name: "Salok & Ashtpadi 8", gurmukhiName: "ਅਸਟਪਦੀ ੮", startVerseID: 5824, sectionNumber: 8),
        BaniSection(name: "Salok & Ashtpadi 9", gurmukhiName: "ਅਸਟਪਦੀ ੯", startVerseID: 5909, sectionNumber: 9),
        BaniSection(name: "Salok & Ashtpadi 10", gurmukhiName: "ਅਸਟਪਦੀ ੧੦", startVerseID: 5995, sectionNumber: 10),
        BaniSection(name: "Salok & Ashtpadi 11", gurmukhiName: "ਅਸਟਪਦੀ ੧੧", startVerseID: 6079, sectionNumber: 11),
        BaniSection(name: "Salok & Ashtpadi 12", gurmukhiName: "ਅਸਟਪਦੀ ੧੨", startVerseID: 6163, sectionNumber: 12),
        BaniSection(name: "Salok & Ashtpadi 13", gurmukhiName: "ਅਸਟਪਦੀ ੧੩", startVerseID: 6247, sectionNumber: 13),
        BaniSection(name: "Salok & Ashtpadi 14", gurmukhiName: "ਅਸਟਪਦੀ ੧੪", startVerseID: 6331, sectionNumber: 14),
        BaniSection(name: "Salok & Ashtpadi 15", gurmukhiName: "ਅਸਟਪਦੀ ੧੫", startVerseID: 6415, sectionNumber: 15),
        BaniSection(name: "Salok & Ashtpadi 16", gurmukhiName: "ਅਸਟਪਦੀ ੧੬", startVerseID: 6497, sectionNumber: 16),
        BaniSection(name: "Salok & Ashtpadi 17", gurmukhiName: "ਅਸਟਪਦੀ ੧੭", startVerseID: 6580, sectionNumber: 17),
        BaniSection(name: "Salok & Ashtpadi 18", gurmukhiName: "ਅਸਟਪਦੀ ੧੮", startVerseID: 6664, sectionNumber: 18),
        BaniSection(name: "Salok & Ashtpadi 19", gurmukhiName: "ਅਸਟਪਦੀ ੧੯", startVerseID: 6746, sectionNumber: 19),
        BaniSection(name: "Salok & Ashtpadi 20", gurmukhiName: "ਅਸਟਪਦੀ ੨੦", startVerseID: 6830, sectionNumber: 20),
        BaniSection(name: "Salok & Ashtpadi 21", gurmukhiName: "ਅਸਟਪਦੀ ੨੧", startVerseID: 6914, sectionNumber: 21),
        BaniSection(name: "Salok & Ashtpadi 22", gurmukhiName: "ਅਸਟਪਦੀ ੨੨", startVerseID: 6998, sectionNumber: 22),
        BaniSection(name: "Salok & Ashtpadi 23", gurmukhiName: "ਅਸਟਪਦੀ ੨੩", startVerseID: 7082, sectionNumber: 23),
        BaniSection(name: "Salok & Ashtpadi 24", gurmukhiName: "ਅਸਟਪਦੀ ੨੪", startVerseID: 7166, sectionNumber: 24),
    ]

    // MARK: - Asa Di Var (Bani ID: 90)
    // 24 Pauris by Guru Nanak Dev Ji
    // Verse IDs verified from BaniDB API

    static let asaDiVarSections: [BaniSection] = [
        BaniSection(name: "Pauri 1", gurmukhiName: "ਪਉੜੀ ੧", startVerseID: 24920, sectionNumber: 1),
        BaniSection(name: "Pauri 2", gurmukhiName: "ਪਉੜੀ ੨", startVerseID: 24974, sectionNumber: 2),
        BaniSection(name: "Pauri 3", gurmukhiName: "ਪਉੜੀ ੩", startVerseID: 25026, sectionNumber: 3),
        BaniSection(name: "Pauri 4", gurmukhiName: "ਪਉੜੀ ੪", startVerseID: 25062, sectionNumber: 4),
        BaniSection(name: "Pauri 5", gurmukhiName: "ਪਉੜੀ ੫", startVerseID: 25119, sectionNumber: 5),
        BaniSection(name: "Pauri 6", gurmukhiName: "ਪਉੜੀ ੬", startVerseID: 25163, sectionNumber: 6),
        BaniSection(name: "Pauri 7", gurmukhiName: "ਪਉੜੀ ੭", startVerseID: 25205, sectionNumber: 7),
        BaniSection(name: "Pauri 8", gurmukhiName: "ਪਉੜੀ ੮", startVerseID: 25233, sectionNumber: 8),
        BaniSection(name: "Pauri 9", gurmukhiName: "ਪਉੜੀ ੯", startVerseID: 25287, sectionNumber: 9),
        BaniSection(name: "Pauri 10", gurmukhiName: "ਪਉੜੀ ੧੦", startVerseID: 25334, sectionNumber: 10),
        BaniSection(name: "Pauri 11", gurmukhiName: "ਪਉੜੀ ੧੧", startVerseID: 25381, sectionNumber: 11),
        BaniSection(name: "Pauri 12", gurmukhiName: "ਪਉੜੀ ੧੨", startVerseID: 25410, sectionNumber: 12),
        BaniSection(name: "Pauri 13", gurmukhiName: "ਪਉੜੀ ੧੩", startVerseID: 25443, sectionNumber: 13),
        BaniSection(name: "Pauri 14", gurmukhiName: "ਪਉੜੀ ੧੪", startVerseID: 25480, sectionNumber: 14),
        BaniSection(name: "Pauri 15", gurmukhiName: "ਪਉੜੀ ੧੫", startVerseID: 25524, sectionNumber: 15),
        BaniSection(name: "Pauri 16", gurmukhiName: "ਪਉੜੀ ੧੬", startVerseID: 25563, sectionNumber: 16),
        BaniSection(name: "Pauri 17", gurmukhiName: "ਪਉੜੀ ੧੭", startVerseID: 25585, sectionNumber: 17),
        BaniSection(name: "Pauri 18", gurmukhiName: "ਪਉੜੀ ੧੮", startVerseID: 25613, sectionNumber: 18),
        BaniSection(name: "Pauri 19", gurmukhiName: "ਪਉੜੀ ੧੯", startVerseID: 25643, sectionNumber: 19),
        BaniSection(name: "Pauri 20", gurmukhiName: "ਪਉੜੀ ੨੦", startVerseID: 25669, sectionNumber: 20),
        BaniSection(name: "Pauri 21", gurmukhiName: "ਪਉੜੀ ੨੧", startVerseID: 25689, sectionNumber: 21),
        BaniSection(name: "Pauri 22", gurmukhiName: "ਪਉੜੀ ੨੨", startVerseID: 25720, sectionNumber: 22),
        BaniSection(name: "Pauri 23", gurmukhiName: "ਪਉੜੀ ੨੩", startVerseID: 25741, sectionNumber: 23),
        BaniSection(name: "Pauri 24", gurmukhiName: "ਪਉੜੀ ੨੪", startVerseID: 26081, sectionNumber: 24),
    ]
}

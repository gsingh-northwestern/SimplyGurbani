import Foundation

/// Categories for organizing Banis
enum BaniCategory: String, CaseIterable, Identifiable {
    case nitnem = "Nitnem"
    case majorWorks = "Major Works"
    case ceremonial = "Ceremonial"
    case other = "Other"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var description: String {
        switch self {
        case .nitnem:
            return "Daily prayers recited by Sikhs"
        case .majorWorks:
            return "Extended compositions for deep meditation"
        case .ceremonial:
            return "Prayers for special occasions"
        case .other:
            return "Additional sacred compositions"
        }
    }

    var icon: String {
        switch self {
        case .nitnem:
            return "sun.max"
        case .majorWorks:
            return "book.closed"
        case .ceremonial:
            return "sparkles"
        case .other:
            return "text.book.closed"
        }
    }

    /// Known bani IDs for each category (from BaniDB)
    var baniIDs: Set<Int> {
        switch self {
        case .nitnem:
            // Japji Sahib, Jaap Sahib, Tav Prasad Svaiye, Chaupai, Anand Sahib, Rehras, Sohila
            return [2, 4, 6, 9, 10, 21, 23]
        case .majorWorks:
            // Sukhmani Sahib, Asa di Var, Shabadh Hazare
            return [31, 90, 3]
        case .ceremonial:
            // Lavaan, Ardas
            return [11, 24]
        case .other:
            // Everything else
            return []
        }
    }

    /// Check if a bani belongs to this category
    func contains(baniID: Int) -> Bool {
        if self == .other {
            // Other category contains all banis not in the predefined categories
            let allPredefinedIDs = BaniCategory.allCases
                .filter { $0 != .other }
                .flatMap { $0.baniIDs }
            return !Set(allPredefinedIDs).contains(baniID)
        }
        return baniIDs.contains(baniID)
    }

    /// Get the category for a given bani ID
    static func category(for baniID: Int) -> BaniCategory {
        for category in BaniCategory.allCases where category != .other {
            if category.baniIDs.contains(baniID) {
                return category
            }
        }
        return .other
    }
}

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class ReadingPositionService {
    private let modelContext: ModelContext

    // Constants
    private let maxHistoryItems = 20  // Keep last 20 items
    private let continueReadingLimit = 3  // Show top 3

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Recording History

    /// Record or update reading session
    func savePosition(
        contentType: String,
        contentID: Int,
        sourceID: String = "G",
        topVisibleVerseID: Int,
        displayName: String,
        gurmukhiPreview: String,
        transliterationPreview: String? = nil
    ) {
        let key = "\(contentType)-\(contentID)-\(sourceID)"

        // Check if exists
        let descriptor = FetchDescriptor<ReadingPosition>(
            predicate: #Predicate { $0.contentKey == key }
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            // Update existing
            existing.update(
                topVisibleVerseID: topVisibleVerseID,
                displayName: displayName,
                gurmukhiPreview: gurmukhiPreview,
                transliterationPreview: transliterationPreview
            )
        } else {
            // Create new
            let position = ReadingPosition(
                contentType: contentType,
                contentID: contentID,
                sourceID: sourceID,
                topVisibleVerseID: topVisibleVerseID,
                displayName: displayName,
                gurmukhiPreview: gurmukhiPreview,
                transliterationPreview: transliterationPreview
            )
            modelContext.insert(position)

            // Cleanup old items if exceeds max
            cleanupOldHistory()
        }

        try? modelContext.save()
    }

    /// Update only the scroll position for existing item
    func updatePosition(
        contentType: String,
        contentID: Int,
        sourceID: String = "G",
        topVisibleVerseID: Int
    ) {
        let key = "\(contentType)-\(contentID)-\(sourceID)"
        let descriptor = FetchDescriptor<ReadingPosition>(
            predicate: #Predicate { $0.contentKey == key }
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            existing.topVisibleVerseID = topVisibleVerseID
            existing.lastReadAt = Date()
            try? modelContext.save()
        }
    }

    // MARK: - Fetching History

    /// Get recent items for "Continue Reading" (top 3)
    func getRecentHistory(limit: Int = 3) -> [ReadingPosition] {
        var descriptor = FetchDescriptor<ReadingPosition>(
            sortBy: [SortDescriptor(\.lastReadAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Get all history
    func getAllHistory() -> [ReadingPosition] {
        let descriptor = FetchDescriptor<ReadingPosition>(
            sortBy: [SortDescriptor(\.lastReadAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Get position for specific content
    func getPosition(
        contentType: String,
        contentID: Int,
        sourceID: String = "G"
    ) -> ReadingPosition? {
        let key = "\(contentType)-\(contentID)-\(sourceID)"
        let descriptor = FetchDescriptor<ReadingPosition>(
            predicate: #Predicate { $0.contentKey == key }
        )

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Cleanup

    /// Remove items beyond maxHistoryItems limit
    private func cleanupOldHistory() {
        let descriptor = FetchDescriptor<ReadingPosition>(
            sortBy: [SortDescriptor(\.lastReadAt, order: .reverse)]
        )

        guard let allItems = try? modelContext.fetch(descriptor) else { return }

        // Delete items beyond limit
        if allItems.count > maxHistoryItems {
            for item in allItems.dropFirst(maxHistoryItems) {
                modelContext.delete(item)
            }
            try? modelContext.save()
        }
    }

    /// Clear all history
    func clearHistory() {
        let descriptor = FetchDescriptor<ReadingPosition>()
        if let items = try? modelContext.fetch(descriptor) {
            items.forEach { modelContext.delete($0) }
            try? modelContext.save()
        }
    }

    /// Delete specific item
    func deleteItem(contentKey: String) {
        let descriptor = FetchDescriptor<ReadingPosition>(
            predicate: #Predicate { $0.contentKey == contentKey }
        )
        if let item = try? modelContext.fetch(descriptor).first {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
}

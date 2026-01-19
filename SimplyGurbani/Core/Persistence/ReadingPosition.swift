import Foundation
import SwiftData

/// A reading position stored in SwiftData for "Continue Reading" functionality
@Model
final class ReadingPosition {
    @Attribute(.unique) var contentKey: String

    var contentType: String  // "shabad", "bani", "ang"
    var contentID: Int
    var sourceID: String  // "G" for SGGS, "D" for Dasam, etc.

    // Position tracking
    var topVisibleVerseID: Int  // The verse ID that was at the top of viewport

    // Display information for Continue Reading card
    var displayName: String  // "Japji Sahib", "Ang 5", etc.
    var gurmukhiPreview: String  // First line of content for display
    var transliterationPreview: String?

    // Metadata
    var lastReadAt: Date

    init(
        contentType: String,
        contentID: Int,
        sourceID: String = "G",
        topVisibleVerseID: Int,
        displayName: String,
        gurmukhiPreview: String,
        transliterationPreview: String? = nil
    ) {
        self.contentKey = "\(contentType)-\(contentID)-\(sourceID)"
        self.contentType = contentType
        self.contentID = contentID
        self.sourceID = sourceID
        self.topVisibleVerseID = topVisibleVerseID
        self.displayName = displayName
        self.gurmukhiPreview = gurmukhiPreview
        self.transliterationPreview = transliterationPreview
        self.lastReadAt = Date()
    }

    /// Update this reading position with new data
    func update(
        topVisibleVerseID: Int,
        displayName: String? = nil,
        gurmukhiPreview: String? = nil,
        transliterationPreview: String? = nil
    ) {
        self.topVisibleVerseID = topVisibleVerseID
        if let displayName = displayName {
            self.displayName = displayName
        }
        if let gurmukhiPreview = gurmukhiPreview {
            self.gurmukhiPreview = gurmukhiPreview
        }
        if let transliterationPreview = transliterationPreview {
            self.transliterationPreview = transliterationPreview
        }
        self.lastReadAt = Date()
    }
}

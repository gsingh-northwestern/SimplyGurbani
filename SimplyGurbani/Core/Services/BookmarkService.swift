import Foundation
import SwiftData
import Observation

/// Service for managing bookmarks with SwiftData
@Observable
@MainActor
final class BookmarkService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Bookmarks

    /// Add a verse to bookmarks
    func bookmarkVerse(_ verse: Verse, folderName: String? = nil, notes: String? = nil) {
        let bookmark = BookmarkedVerse(
            verseID: verse.id,
            shabadID: verse.shabadID,
            gurmukhiUnicode: verse.gurmukhiUnicode,
            transliteration: verse.transliteration,
            translation: verse.translation,
            ang: verse.ang,
            sourceID: verse.sourceID,
            folderName: folderName,
            notes: notes
        )
        modelContext.insert(bookmark)
        try? modelContext.save()
    }

    /// Remove a verse from bookmarks
    func removeBookmark(verseID: Int) {
        let descriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.verseID == verseID }
        )
        if let bookmarks = try? modelContext.fetch(descriptor),
           let bookmark = bookmarks.first {
            modelContext.delete(bookmark)
            try? modelContext.save()
        }
    }

    /// Check if a verse is bookmarked
    func isBookmarked(verseID: Int) -> Bool {
        let descriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.verseID == verseID }
        )
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        return count > 0
    }

    /// Get all bookmarks
    func getAllBookmarks() -> [BookmarkedVerse] {
        let descriptor = FetchDescriptor<BookmarkedVerse>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Get bookmarks in a specific folder
    func getBookmarks(in folderName: String?) -> [BookmarkedVerse] {
        let descriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.folderName == folderName },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Move bookmark to a folder
    func moveBookmark(verseID: Int, to folderName: String?) {
        let descriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.verseID == verseID }
        )
        if let bookmarks = try? modelContext.fetch(descriptor),
           let bookmark = bookmarks.first {
            bookmark.folderName = folderName
            try? modelContext.save()
        }
    }

    /// Update notes for a bookmark
    func updateNotes(verseID: Int, notes: String?) {
        let descriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.verseID == verseID }
        )
        if let bookmarks = try? modelContext.fetch(descriptor),
           let bookmark = bookmarks.first {
            bookmark.notes = notes
            try? modelContext.save()
        }
    }

    // MARK: - Folders

    /// Create a new folder
    func createFolder(name: String, colorHex: String? = nil) {
        let folder = BookmarkFolder(name: name, colorHex: colorHex)
        modelContext.insert(folder)
        try? modelContext.save()
    }

    /// Delete a folder (moves bookmarks to unfiled)
    func deleteFolder(name: String) {
        // Move all bookmarks in folder to unfiled
        let bookmarkDescriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.folderName == name }
        )
        if let bookmarks = try? modelContext.fetch(bookmarkDescriptor) {
            for bookmark in bookmarks {
                bookmark.folderName = nil
            }
        }

        // Delete the folder
        let folderDescriptor = FetchDescriptor<BookmarkFolder>(
            predicate: #Predicate { $0.name == name }
        )
        if let folders = try? modelContext.fetch(folderDescriptor),
           let folder = folders.first {
            modelContext.delete(folder)
        }
        try? modelContext.save()
    }

    /// Get all folders
    func getAllFolders() -> [BookmarkFolder] {
        let descriptor = FetchDescriptor<BookmarkFolder>(
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Rename a folder
    func renameFolder(oldName: String, newName: String) {
        // Update folder
        let folderDescriptor = FetchDescriptor<BookmarkFolder>(
            predicate: #Predicate { $0.name == oldName }
        )
        if let folders = try? modelContext.fetch(folderDescriptor),
           let folder = folders.first {
            folder.name = newName
        }

        // Update bookmarks in folder
        let bookmarkDescriptor = FetchDescriptor<BookmarkedVerse>(
            predicate: #Predicate { $0.folderName == oldName }
        )
        if let bookmarks = try? modelContext.fetch(bookmarkDescriptor) {
            for bookmark in bookmarks {
                bookmark.folderName = newName
            }
        }
        try? modelContext.save()
    }

    // MARK: - Statistics

    /// Get bookmark count
    var bookmarkCount: Int {
        let descriptor = FetchDescriptor<BookmarkedVerse>()
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    /// Get folder count
    var folderCount: Int {
        let descriptor = FetchDescriptor<BookmarkFolder>()
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
}

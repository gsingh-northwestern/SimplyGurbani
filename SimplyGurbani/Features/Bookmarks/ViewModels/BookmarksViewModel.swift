import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class BookmarksViewModel {
    private var bookmarkService: BookmarkService?

    // State
    private(set) var bookmarks: [BookmarkedVerse] = []
    private(set) var folders: [BookmarkFolder] = []
    private(set) var selectedFolder: String?
    var isShowingNewFolderSheet = false
    var newFolderName = ""

    init() {}

    func configure(with modelContext: ModelContext) {
        self.bookmarkService = BookmarkService(modelContext: modelContext)
        loadBookmarks()
        loadFolders()
    }

    // MARK: - Loading

    func loadBookmarks() {
        guard let service = bookmarkService else { return }
        bookmarks = service.getBookmarks(in: selectedFolder)
    }

    func loadFolders() {
        guard let service = bookmarkService else { return }
        folders = service.getAllFolders()
    }

    func refresh() {
        loadBookmarks()
        loadFolders()
    }

    // MARK: - Folder Selection

    func selectFolder(_ folderName: String?) {
        selectedFolder = folderName
        loadBookmarks()
    }

    // MARK: - Bookmark Actions

    func deleteBookmark(_ bookmark: BookmarkedVerse) {
        bookmarkService?.removeBookmark(verseID: bookmark.verseID)
        loadBookmarks()
    }

    func moveBookmark(_ bookmark: BookmarkedVerse, to folderName: String?) {
        bookmarkService?.moveBookmark(verseID: bookmark.verseID, to: folderName)
        loadBookmarks()
    }

    // MARK: - Folder Actions

    func createFolder() {
        guard !newFolderName.isEmpty else { return }
        bookmarkService?.createFolder(name: newFolderName)
        newFolderName = ""
        isShowingNewFolderSheet = false
        loadFolders()
    }

    func deleteFolder(_ folder: BookmarkFolder) {
        bookmarkService?.deleteFolder(name: folder.name)
        if selectedFolder == folder.name {
            selectedFolder = nil
        }
        loadFolders()
        loadBookmarks()
    }

    // MARK: - Computed Properties

    var displayTitle: String {
        selectedFolder ?? "All Bookmarks"
    }

    var isEmpty: Bool {
        bookmarks.isEmpty
    }

    var bookmarkCount: Int {
        bookmarkService?.bookmarkCount ?? 0
    }

    /// Bookmarks that are not in any folder
    var unfiledBookmarks: [BookmarkedVerse] {
        guard let service = bookmarkService else { return [] }
        return service.getBookmarks(in: nil)
    }
}

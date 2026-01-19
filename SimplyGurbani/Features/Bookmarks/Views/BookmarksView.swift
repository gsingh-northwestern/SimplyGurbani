import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BookmarksViewModel()

    var body: some View {
        Group {
            if viewModel.isEmpty && viewModel.folders.isEmpty {
                emptyStateView
            } else {
                bookmarksList
            }
        }
        .background(AppTheme.Colors.backgroundBeige)
        .navigationTitle(viewModel.displayTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        viewModel.isShowingNewFolderSheet = true
                    } label: {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }

                    if viewModel.selectedFolder != nil {
                        Button {
                            viewModel.selectFolder(nil)
                        } label: {
                            Label("All Bookmarks", systemImage: "bookmark")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingNewFolderSheet) {
            newFolderSheet
        }
        .onAppear {
            viewModel.configure(with: modelContext)
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Bookmarks", systemImage: "bookmark")
        } description: {
            Text("Save your favorite shabads and verses to access them quickly.")
        } actions: {
            Button("Browse Gurbani") {
                router.selectedTab = .browse
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.Colors.saffronFallback)
        }
    }

    private var bookmarksList: some View {
        List {
            // Folders section
            if !viewModel.folders.isEmpty {
                Section("Folders") {
                    ForEach(viewModel.folders, id: \.name) { folder in
                        Button {
                            viewModel.selectFolder(folder.name)
                        } label: {
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundStyle(AppTheme.Colors.goldFallback)
                                Text(folder.name)
                                Spacer()
                                if viewModel.selectedFolder == folder.name {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(AppTheme.Colors.saffronFallback)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                viewModel.deleteFolder(folder)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            // Bookmarks section
            if !viewModel.bookmarks.isEmpty {
                Section(viewModel.selectedFolder ?? "Saved Verses") {
                    ForEach(viewModel.bookmarks, id: \.verseID) { bookmark in
                        Button {
                            // Navigate to bani if baniID exists, otherwise to shabad
                            if let baniID = bookmark.baniID {
                                router.bookmarksPath.append(.baniReader(baniID: baniID, scrollToVerseID: bookmark.verseID))
                            } else if bookmark.shabadID > 0 {
                                router.bookmarksPath.append(.shabadReader(shabadID: bookmark.shabadID, scrollToVerseID: bookmark.verseID))
                            }
                        } label: {
                            BookmarkRow(bookmark: bookmark)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteBookmark(bookmark)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            if !viewModel.folders.isEmpty {
                                Menu {
                                    Button {
                                        viewModel.moveBookmark(bookmark, to: nil)
                                    } label: {
                                        Text("Unfiled")
                                    }
                                    ForEach(viewModel.folders, id: \.name) { folder in
                                        Button {
                                            viewModel.moveBookmark(bookmark, to: folder.name)
                                        } label: {
                                            Text(folder.name)
                                        }
                                    }
                                } label: {
                                    Label("Move", systemImage: "folder")
                                }
                                .tint(AppTheme.Colors.goldFallback)
                            }
                        }
                    }
                }
            } else if viewModel.selectedFolder != nil {
                Section {
                    Text("No bookmarks in this folder")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .listRowBackground(AppTheme.Colors.cardBackground)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.Colors.backgroundBeige)
    }

    private var newFolderSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Folder Name", text: $viewModel.newFolderName)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.Colors.backgroundBeige)
            .navigationTitle("New Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.newFolderName = ""
                        viewModel.isShowingNewFolderSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createFolder()
                    }
                    .disabled(viewModel.newFolderName.isEmpty)
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}

struct BookmarkRow: View {
    let bookmark: BookmarkedVerse

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bookmark.gurmukhiUnicode)
                .font(.system(size: 18))
                .lineLimit(2)

            if let translit = bookmark.transliteration {
                Text(translit)
                    .font(.system(size: 14, design: .serif))
                    .italic()
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            HStack {
                // Show bani name if from a bani, otherwise show ang
                if let baniID = bookmark.baniID,
                   let baniName = WellKnownBani(rawValue: baniID)?.displayName {
                    Text(baniName)
                } else if bookmark.ang > 0 {
                    Text("Ang \(bookmark.ang)")
                } else {
                    Text("Bookmark")
                }
                Spacer()
                if let folder = bookmark.folderName {
                    Label(folder, systemImage: "folder")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.goldFallback)
                }
                Text(bookmark.createdAt, style: .date)
            }
            .font(AppTheme.Typography.caption)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        BookmarksView()
    }
    .environment(AppRouter())
    .modelContainer(for: [BookmarkedVerse.self, BookmarkFolder.self], inMemory: true)
}

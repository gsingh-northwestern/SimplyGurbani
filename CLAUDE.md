# Project: Simply Gurbani

## Quick Reference
- **Platform**: iOS 17+
- **Language**: Swift 6.0
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with @Observable
- **Minimum Deployment**: iOS 17.0
- **Package Manager**: Swift Package Manager + XcodeGen

## XcodeBuildMCP Integration
**IMPORTANT**: This project uses XcodeBuildMCP for all Xcode operations.
- Build: `mcp__xcodebuildmcp__build_sim_name_proj`
- Test: `mcp__xcodebuildmcp__test_sim_name_proj`
- Clean: `mcp__xcodebuildmcp__clean`
- Run xcodegen after project.yml changes: `xcodegen generate`

## Project Structure
```
SimplyGurbani/
├── App/                    # App entry point (SimplyGurbaniApp.swift, ContentView.swift)
├── Features/               # Feature modules
│   ├── Home/              # Hukamnama card, quick access grid
│   ├── Browse/            # Scripture, Bani, Raag lists
│   ├── Reader/            # Shabad/Bani reader views
│   ├── Search/            # Search and results
│   ├── Bookmarks/         # Saved verses
│   └── Settings/          # Preferences
├── Core/
│   ├── Models/            # Domain models (Verse, Shabad, Bani, etc.)
│   ├── Networking/        # APIClient, Endpoints
│   ├── Persistence/       # SwiftData caching
│   └── Services/          # GurbaniService, BookmarkService
├── DesignSystem/
│   ├── Theme/             # AppTheme (Colors, Typography, Spacing)
│   ├── Components/        # GlassCard, GlassButton
│   └── Modifiers/         # GlassBackground, GurmukhiText
├── Navigation/            # AppRouter, Route, TabRoute
└── Resources/             # Assets, Fonts
```

## Coding Standards

### Swift Style
- Use Swift 6 strict concurrency
- Prefer `@Observable` over `ObservableObject`
- Use `async/await` for all async operations
- Follow Apple's Swift API Design Guidelines
- Use `guard` for early exits
- All models conform to `Sendable`

### SwiftUI Patterns
- Extract views when they exceed 80 lines
- Use `@State` for local view state only
- Use `@Environment` for dependency injection
- Use `NavigationStack` with type-safe `Route` enum
- Use `@Bindable` for bindings to @Observable objects
- Implement liquid glass design using `.glassBackground()` modifier

### Navigation Pattern
```swift
NavigationStack(path: $router.browsePath) {
    BrowseView()
        .navigationDestination(for: Route.self) { route in
            destinationView(for: route)
        }
}
```

### Bookmark System
- `BookmarkedVerse` model stores verse data, shabadID, optional baniID, and folder
- `BookmarkService` manages CRUD operations for bookmarks
- Bookmarks from banis include `baniID` for proper navigation
- Navigation routes include optional `scrollToVerseID` for scroll-to-verse
- Bookmark navigation prioritizes scroll position over saved reading position

### Reading Position Tracking
- `ReadingPosition` model tracks scroll position for shabads, banis, and angs
- `ReadingPositionService` manages reading history (max 20 items)
- iOS 17's `scrollPosition(id:)` API for automatic position tracking
- Continue Reading section shows last 3 reading sessions
- Position restored on navigation: bookmark position > saved position > top

## API Integration
- Base URL: `https://api.banidb.com/v2`
- Key endpoints:
  - `/shabads/:id` - Get shabad by ID
  - `/banis` - List all banis
  - `/banis/:id` - Get bani content
  - `/search/:query` - Search Gurbani
  - `/hukamnama/today` - Today's hukamnama
  - `/angs/:number` - Get ang/page
- All network calls go through `APIClient` actor
- Responses cached using SwiftData for offline access

## Design System

### Color Palette
| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| Light Beige | #FDF0D5 | (0.992, 0.941, 0.835) | App background |
| Dark Blue | #003049 | (0.0, 0.188, 0.286) | Primary text, headers, Quick Access tiles |
| Light Blue | #669BBC | (0.4, 0.608, 0.737) | Secondary accents, icons |
| Burgundy Red | #AB364D | (0.671, 0.212, 0.302) | Primary accent, buttons, highlights |
| Warm Ivory | #FFFEF7 | (1.0, 0.995, 0.97) | Card backgrounds |

### Components
- `GlassCard` - Card component with warm ivory background, subtle border, and shadow
- `GlassButtonStyle` - Button styles (`.glass` and `.glassProminent`)
- Use `GlassCard` for consistent card styling across all screens
- Gurmukhi fonts: GurbaniAkhar, AnmolLipi (register in Info.plist)

## Key Files
- `SimplyGurbani/App/SimplyGurbaniApp.swift` - App entry point with SwiftData container
- `SimplyGurbani/App/ContentView.swift` - Main TabView with navigation
- `SimplyGurbani/Navigation/AppRouter.swift` - Navigation state management
- `SimplyGurbani/Navigation/Route.swift` - Type-safe navigation routes
- `SimplyGurbani/Core/Services/BookmarkService.swift` - Bookmark management
- `SimplyGurbani/Core/Services/ReadingPositionService.swift` - Reading progress tracking
- `SimplyGurbani/Core/Persistence/BookmarkedVerse.swift` - Bookmark SwiftData model
- `SimplyGurbani/Core/Persistence/ReadingPosition.swift` - Reading position SwiftData model
- `SimplyGurbani/Features/Reader/ViewModels/ReaderViewModel.swift` - Reader business logic
- `SimplyGurbani/Features/Reader/Views/ReaderView.swift` - Shabad/Bani reader UI
- `SimplyGurbani/DesignSystem/Theme/AppTheme.swift` - Design tokens
- `SimplyGurbani/DesignSystem/Components/GlassCard.swift` - Glass components
- `project.yml` - XcodeGen configuration

## Testing Requirements
- Unit tests for all ViewModels
- Use Swift Testing framework (`@Test`, `#expect`)
- Mock API responses using `MockAPIClient`

## DO NOT
- Use deprecated APIs
- Force unwrap (`!`) without justification
- Ignore Swift 6 concurrency warnings
- Use UIKit unless absolutely necessary
- Hardcode strings (use localization)
- Modify files without reading them first

## Current Status
- [x] Project structure created
- [x] Design system implemented
- [x] Navigation setup complete
- [x] Placeholder views for all features
- [x] API client implementation (APIClient actor)
- [x] Data models (Verse, Shabad, Bani, Raag, Writer, Source, Hukamnama, SearchResult)
- [x] GurbaniService for business logic
- [x] ViewModels for Home, Reader, Search features
- [x] Real Hukamnama from Sri Harmandir Sahib on Home screen
- [x] Shabad/Bani reader with API integration
- [x] Search functionality with history and multiple search types
- [x] SwiftData persistence models (BookmarkedVerse, CachedShabad, etc.)
- [x] Bookmarks feature with folders
- [x] Enhanced Settings with typography controls
- [x] Offline caching with cache-first strategy
- [x] Unit tests (34 tests passing)
- [x] New color palette implemented (beige, dark blue, light blue, burgundy)
- [x] Consistent card styling with GlassCard throughout app
- [x] Browse feature fully functional (SGGS, Raags, Writers, Banis)
- [x] Dasam Granth bani category
- [x] Quick Access icons on Home screen
- [x] Full-width cards throughout app
- [x] Bookmark system fully functional (navigation + scroll-to-verse)
- [x] Reading position tracking and continue reading feature
- [ ] Additional UI/UX polish

## Recent Changes (v0.8.1)
- **Settings Data Section**: Fully functional cache and history management
  - Clear Search History button now shows confirmation alert
  - Clear Cached Content button clears cache, reading history, and shows confirmation alert
  - Cache stats display now refreshes immediately after clearing
  - Added SwiftData integration to SettingsView for reading position access

## Recent Changes (v0.8.0)
- **Bookmark System Fixes**: Complete overhaul of bookmark navigation for bani verses
  - Added `baniID: Int?` field to `BookmarkedVerse` model to track verses from banis
  - Updated `BookmarkService.bookmarkVerse()` to accept and save baniID parameter
  - Updated `ReaderViewModel` to pass baniID when bookmarking from a bani
  - Fixed navigation logic in `BookmarksView` to handle both shabads and banis correctly
  - `BookmarkRow` now displays bani name instead of "Ang 0" for bani verses
- **Scroll-to-Verse Navigation**: Bookmarks now open to exact verse position
  - Added `scrollToVerseID: Int?` parameter to `shabadReader` and `baniReader` routes
  - Updated `ReaderView` and `BaniReaderView` to accept and prioritize scrollToVerseID
  - Bookmark navigation takes precedence over saved reading position
  - Clicking a bookmark now scrolls directly to the bookmarked verse
- **Tab Navigation Fix**: Browse Gurbani button now works correctly
  - Added `selection: $router.selectedTab` binding to `TabView` in `ContentView.legacyTabView()`
  - Fixed programmatic tab switching for all empty state "Browse" buttons
- **Reading Position Tracking**: Automatic scroll position saving and restoration
  - Created `ReadingPosition` SwiftData model for tracking reading progress
  - Created `ReadingPositionService` for managing reading history
  - Updated all reader views to save and restore scroll positions
  - Continue Reading section on Home screen shows last 3 reading sessions

## Recent Changes (v0.7.0)
- **Browse Navigation Fixed**: Browse by Raag and Browse by Writer now work (was showing "Coming Soon")
  - Added `raagList` and `writerList` cases to ContentView's navigation switch
- **Dasam Granth Category**: New bani category for Dasam Granth compositions
  - Jaap Sahib, Tav Prasad Svaiye, Chaupai Sahib moved from Nitnem to Dasam Granth
  - Nitnem now only contains SGGS banis (Japji, Anand, Rehras, Sohila)
  - New icon: `shield.lefthalf.filled`
- **Quick Access Improvements**:
  - Added SF Symbol icons to Quick Access tiles (sunrise, sunset, moon.stars, etc.)
  - Replaced Asa Di Var with Chaupai Sahib
  - Synced with Popular Banis section (both now have 6 banis including Chaupai Sahib)
- **API Decoding Fixes**:
  - Created `AngResponse` model for `/angs/:number` endpoint (was using wrong `ShabadResponse`)
  - Fixed `SearchResponse.SearchVerse` to handle nested `source`, `writer`, `raag` objects
- **Full-Width Cards**: All header cards now take full screen width
  - Added `.frame(maxWidth: .infinity)` to VStacks in WriterShabadsView, AngReaderView, ReaderView

## Recent Changes (v0.6.0)
- **Browse Feature Complete**: All 4 browse sections now fully functional
  - **Sri Guru Granth Sahib Ji**: Browse by ang (page 1-1430) with prev/next pagination
  - **Browse by Raag**: Navigate to specific angs for each raag
  - **Browse by Writer**: View list of shabads by each writer
  - **All Banis**: Categorized list (Nitnem, Major Works, Ceremonial, Other)
- **New Files**:
  - `AngReaderView.swift` - Display SGGS content by ang with pagination
  - `WriterShabadsView.swift` - Show shabads by selected writer
  - `CategorizedBaniListView.swift` - All banis organized by category
  - `BaniCategory.swift` - Enum for bani categorization
- **New Routes**: `angReader`, `writerShabads`, `categorizedBaniList`
- **API Fixes**:
  - Fixed Bani model decoding (`gurmukhiUni` vs `unicode`, nested `transliterations`)
  - Added `searchByWriter()` endpoint
- **UI Improvements**: Header cards now full-width in reader views

## Recent Changes (v0.5.0)
- Implemented new color palette:
  - Light Beige (#FDF0D5) - app background
  - Dark Blue (#003049) - text, headers, Quick Access tiles
  - Light Blue (#669BBC) - secondary accents
  - Burgundy Red (#AB364D) - primary accent, buttons
  - Warm Ivory (#FFFEF7) - card backgrounds
- Updated GlassCard component with warm ivory background, subtle border, shadow
- Converted BrowseView from List to ScrollView + GlassCard for visual consistency
- Quick Access tiles now use dark blue background with white text
- Simplified Quick Access grid to text-only (no icons)
- Updated tab bar and navigation bar appearances to match new palette
- Applied consistent card styling across all screens

## Recent Changes (v0.4.0)
- Added CacheService for SwiftData-based offline caching
- Implemented cache-first loading strategy in GurbaniService
- Background refresh keeps cached content up-to-date
- Offline mode detection with fallback to expired cache
- Cache stats display in Settings
- Added comprehensive unit tests for ViewModels and Services

## Recent Changes (v0.3.0)
- Added SwiftData container with persistence models
- Implemented bookmarks feature with folder support
- Added bookmark button to Reader views
- Enhanced Settings with typography sliders and preview
- Added cache management options

## Recent Changes (v0.2.0)
- Added BaniDB API integration
- Home screen now displays real daily Hukamnama
- Reader views fetch actual shabad/bani content
- Search implemented with first-letter and full-word modes
- All data models created matching BaniDB API structure

## Next Steps
- Convert remaining List views (Settings, Search, Bookmarks) to GlassCard style if desired
- Add dark mode support
- Test on various device sizes
- Add localization support
- Consider adding audio playback for shabads/banis
- Add sharing functionality improvements

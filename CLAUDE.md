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
- `SimplyGurbani/App/SimplyGurbaniApp.swift` - App entry point
- `SimplyGurbani/App/ContentView.swift` - Main TabView
- `SimplyGurbani/Navigation/AppRouter.swift` - Navigation state
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
- [ ] Additional UI/UX polish

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

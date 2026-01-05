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
- **Primary**: Saffron (#FF6B00)
- **Secondary**: Gold (#D4AF37)
- **Accent**: Cardinal Red (#C41E3A)
- Use `.glassBackground()` modifier for iOS 18 liquid glass effect
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
- [ ] Offline caching implementation
- [ ] Unit tests

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

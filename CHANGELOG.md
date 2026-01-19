# Changelog

All notable changes to Simply Gurbani will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.1] - 2026-01-19

### Added
- Confirmation alerts for Settings data management actions
- Cache stats UI refresh after clearing cached content

### Fixed
- Cache stats not updating after clearing cached content
- No user feedback when clearing search history or cache

### Changed
- "Clear Cached Content" now also clears reading history (Continue Reading section)
- Settings Data section fully functional with proper user feedback

## [0.8.0] - 2026-01-18

### Added
- Reading position tracking with `ReadingPosition` SwiftData model
- `ReadingPositionService` for managing reading history (max 20 items)
- Continue Reading section on Home screen showing last 3 reading sessions
- Automatic scroll position saving and restoration using iOS 17's `scrollPosition(id:)` API
- `scrollToVerseID` parameter to navigation routes for precise scroll positioning
- `baniID` field to `BookmarkedVerse` model for tracking verses from banis

### Fixed
- **Critical**: Bookmark navigation error when clicking verses from banis
  - Previously showed "Resource not found" error and "Ang 0" display
  - Now correctly navigates to the bani containing the verse
- **Critical**: Bookmarks not scrolling to the bookmarked verse
  - Bookmarks now scroll directly to the exact verse that was bookmarked
  - Priority: bookmark position > saved reading position > top
- **Critical**: "Browse Gurbani" button not working in empty states
  - Added missing TabView selection binding in ContentView
  - All programmatic tab switching now works correctly

### Changed
- BookmarkRow now displays bani name instead of "Ang 0" for verses from banis
- Updated navigation routes (`shabadReader`, `baniReader`) to accept optional `scrollToVerseID`
- Reader views prioritize bookmark scroll position over saved reading position
- All reader views (ReaderView, BaniReaderView, AngReaderView) now track scroll position

## [0.7.0] - 2026-01-15

### Added
- Dasam Granth bani category with `shield.lefthalf.filled` icon
- SF Symbol icons to Quick Access tiles (sunrise, sunset, moon.stars, etc.)
- Full-width header cards in all reader views

### Fixed
- Browse by Raag and Browse by Writer navigation (was showing "Coming Soon")
- API decoding for `/angs/:number` endpoint with new `AngResponse` model
- SearchResponse.SearchVerse decoding for nested `source`, `writer`, `raag` objects

### Changed
- Reorganized banis: moved Jaap Sahib, Tav Prasad Svaiye, Chaupai Sahib to Dasam Granth category
- Nitnem now only contains SGGS banis (Japji, Anand, Rehras, Sohila)
- Replaced Asa Di Var with Chaupai Sahib in Quick Access
- Synced Quick Access and Popular Banis sections (both have 6 banis)

## [0.6.0] - 2026-01-10

### Added
- Complete Browse feature implementation
  - Sri Guru Granth Sahib Ji: Browse by ang (pages 1-1430) with pagination
  - Browse by Raag: Navigate to specific angs for each raag
  - Browse by Writer: View list of shabads by each writer
  - All Banis: Categorized list (Nitnem, Major Works, Ceremonial, Other)
- New views: `AngReaderView`, `WriterShabadsView`, `CategorizedBaniListView`
- New routes: `angReader`, `writerShabads`, `categorizedBaniList`
- `BaniCategory` enum for bani categorization
- `searchByWriter()` API endpoint

### Fixed
- Bani model decoding issues (`gurmukhiUni` vs `unicode`, nested `transliterations`)

## [0.5.0] - 2026-01-05

### Added
- New color palette implementation
  - Light Beige (#FDF0D5) - app background
  - Dark Blue (#003049) - text, headers, Quick Access tiles
  - Light Blue (#669BBC) - secondary accents
  - Burgundy Red (#AB364D) - primary accent, buttons
  - Warm Ivory (#FFFEF7) - card backgrounds
- Updated GlassCard component with warm ivory background, subtle border, shadow
- Consistent card styling across all screens

### Changed
- Converted BrowseView from List to ScrollView + GlassCard
- Quick Access tiles now use dark blue background with white text
- Simplified Quick Access grid to text-only (no icons in this version)
- Updated tab bar and navigation bar appearances to match new palette

## [0.4.0] - 2026-01-03

### Added
- SwiftData-based offline caching with `CacheService`
- Cache-first loading strategy in `GurbaniService`
- Background refresh to keep cached content up-to-date
- Offline mode detection with fallback to expired cache
- Cache statistics display in Settings
- Comprehensive unit tests for ViewModels and Services (34 tests passing)

## [0.3.0] - 2025-12-28

### Added
- SwiftData persistence container
- Bookmarks feature with folder organization
- `BookmarkedVerse` and `BookmarkFolder` models
- Bookmark button in Reader views
- Enhanced Settings with typography controls (Gurmukhi font size slider)
- Typography preview in Settings
- Cache management options in Settings

## [0.2.0] - 2025-12-20

### Added
- BaniDB API integration with `APIClient` actor
- Real daily Hukamnama from Sri Harmandir Sahib on Home screen
- API-powered Shabad/Bani reader views
- Search functionality with first-letter and full-word modes
- Search history tracking
- Complete data models matching BaniDB API structure
  - Verse, Shabad, Bani, Raag, Writer, Source, Hukamnama, SearchResult

## [0.1.0] - 2025-12-15

### Added
- Initial project structure with MVVM architecture
- Design system with `AppTheme`, `GlassCard`, `GlassButton`
- Navigation system with `AppRouter` and type-safe routes
- Tab-based navigation (Home, Browse, Search, Bookmarks, Settings)
- Placeholder views for all features
- Swift 6 strict concurrency support
- XcodeGen configuration
- Unit testing framework setup with Swift Testing

---

## Legend

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

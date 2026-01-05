import SwiftUI

/// Central theme configuration for Simply Gurbani
enum AppTheme {

    // MARK: - Colors

    // New Color Palette:
    // #FDF0D5 - Light Beige (Background)
    // #003049 - Dark Blue (Text, Headers)
    // #669BBC - Light Blue (Secondary accents, Icons)
    // #AB364D - Burgundy Red (Primary accent, Buttons)

    enum Colors {
        // Primary palette - Burgundy Red (#AB364D)
        static let primaryBurgundy = Color(red: 0.671, green: 0.212, blue: 0.302)
        static let primaryBurgundyLight = Color(red: 0.75, green: 0.35, blue: 0.42)
        static let primaryBurgundyDark = Color(red: 0.55, green: 0.15, blue: 0.25)

        // Legacy aliases for compatibility
        static let primarySaffron = primaryBurgundy
        static let primarySaffronLight = primaryBurgundyLight
        static let primarySaffronDark = primaryBurgundyDark

        // Secondary palette - Light Blue (#669BBC)
        static let secondaryBlue = Color(red: 0.4, green: 0.608, blue: 0.737)
        static let secondaryBlueLight = Color(red: 0.5, green: 0.7, blue: 0.82)
        static let secondaryBlueDark = Color(red: 0.3, green: 0.5, blue: 0.65)

        // Legacy aliases for compatibility
        static let secondaryGold = secondaryBlue
        static let secondaryGoldLight = secondaryBlueLight
        static let secondaryGoldDark = secondaryBlueDark

        // Accent palette - Dark Blue (#003049)
        static let accentDarkBlue = Color(red: 0.0, green: 0.188, blue: 0.286)
        static let accentDarkBlueLight = Color(red: 0.1, green: 0.28, blue: 0.38)
        static let accentDarkBlueDark = Color(red: 0.0, green: 0.12, blue: 0.2)

        // Legacy aliases for compatibility
        static let accentRed = primaryBurgundy
        static let accentRedLight = primaryBurgundyLight
        static let accentRedDark = primaryBurgundyDark

        // Backgrounds - Light Beige (#FDF0D5)
        static let backgroundBeige = Color(red: 0.992, green: 0.941, blue: 0.835)
        static let backgroundPrimary = backgroundBeige
        static let backgroundSecondary = Color(red: 0.98, green: 0.92, blue: 0.8)
        static let backgroundCream = backgroundBeige

        // Card/Surface background - Warm Ivory (#FFFEF7)
        static let cardBackground = Color(red: 1.0, green: 0.995, blue: 0.97)

        // Text colors
        static let textPrimary = accentDarkBlue
        static let textSecondary = Color(red: 0.1, green: 0.3, blue: 0.4)
        static let textTertiary = Color(red: 0.3, green: 0.45, blue: 0.55)
        static let textOnPrimary = Color.white

        // Glass colors (adjusted for beige background)
        static let glassBackground = Color.white.opacity(0.6)
        static let glassBorder = Color.white.opacity(0.8)
        static let glassShadow = accentDarkBlue.opacity(0.1)

        // Fallback colors (primary colors used throughout app)
        static let saffronFallback = primaryBurgundy  // Burgundy #AB364D
        static let goldFallback = secondaryBlue       // Light Blue #669BBC
        static let redFallback = primaryBurgundy      // Burgundy #AB364D
        static let darkBlueFallback = accentDarkBlue  // Dark Blue #003049
    }

    // MARK: - Gradients

    enum Gradients {
        // Primary gradient - Burgundy to Light Blue
        static let primaryGradient = LinearGradient(
            colors: [Colors.primaryBurgundy, Colors.secondaryBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        // Legacy alias
        static let saffronGradient = primaryGradient

        // Secondary gradient - Light Blue shades
        static let secondaryGradient = LinearGradient(
            colors: [Colors.secondaryBlue.opacity(0.8), Colors.secondaryBlue],
            startPoint: .top,
            endPoint: .bottom
        )

        // Legacy alias
        static let goldenGradient = secondaryGradient

        // Glass gradient for cards
        static let glassGradient = LinearGradient(
            colors: [
                Color.white.opacity(0.7),
                Color.white.opacity(0.4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Typography

    enum Typography {
        // Gurmukhi fonts
        static func gurmukhi(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .custom("GurbaniAkhar", size: size).weight(weight)
        }

        static func gurmukhiUnicode(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .custom("AnmolLipi", size: size).weight(weight)
        }

        // System fonts
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
        static let title = Font.system(.title, design: .rounded, weight: .semibold)
        static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
        static let title3 = Font.system(.title3, design: .rounded, weight: .medium)
        static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
        static let body = Font.system(.body, design: .default, weight: .regular)
        static let callout = Font.system(.callout, design: .default, weight: .regular)
        static let subheadline = Font.system(.subheadline, design: .default, weight: .regular)
        static let footnote = Font.system(.footnote, design: .default, weight: .regular)
        static let caption = Font.system(.caption, design: .default, weight: .regular)
    }

    // MARK: - Spacing

    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
        static let pill: CGFloat = 100
    }

    // MARK: - Animation

    enum Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6)
    }
}

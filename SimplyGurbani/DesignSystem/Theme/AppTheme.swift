import SwiftUI

/// Central theme configuration for Simply Gurbani
enum AppTheme {

    // MARK: - Colors

    enum Colors {
        // Primary palette - Saffron/Kesari
        static let primarySaffron = Color("PrimarySaffron")
        static let primarySaffronLight = Color("PrimarySaffronLight")
        static let primarySaffronDark = Color("PrimarySaffronDark")

        // Secondary palette - Gold
        static let secondaryGold = Color("SecondaryGold")
        static let secondaryGoldLight = Color("SecondaryGoldLight")
        static let secondaryGoldDark = Color("SecondaryGoldDark")

        // Accent palette - Royal Red
        static let accentRed = Color("AccentRed")
        static let accentRedLight = Color("AccentRedLight")
        static let accentRedDark = Color("AccentRedDark")

        // Backgrounds
        static let backgroundPrimary = Color("BackgroundPrimary")
        static let backgroundSecondary = Color("BackgroundSecondary")
        static let backgroundCream = Color("BackgroundCream")

        // Text colors
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
        static let textTertiary = Color("TextTertiary")
        static let textOnPrimary = Color.white

        // Glass colors
        static let glassBackground = Color.white.opacity(0.15)
        static let glassBorder = Color.white.opacity(0.3)
        static let glassShadow = Color.black.opacity(0.1)

        // Fallback colors (used when assets not loaded)
        static let saffronFallback = Color(red: 1.0, green: 0.42, blue: 0.0)
        static let goldFallback = Color(red: 0.83, green: 0.69, blue: 0.22)
        static let redFallback = Color(red: 0.77, green: 0.12, blue: 0.23)
    }

    // MARK: - Gradients

    enum Gradients {
        static let saffronGradient = LinearGradient(
            colors: [Colors.saffronFallback, Colors.goldFallback],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let goldenGradient = LinearGradient(
            colors: [Colors.goldFallback.opacity(0.8), Colors.goldFallback],
            startPoint: .top,
            endPoint: .bottom
        )

        static let glassGradient = LinearGradient(
            colors: [
                Color.white.opacity(0.25),
                Color.white.opacity(0.1)
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

import SwiftUI

/// Styled Gurmukhi text modifier
struct GurmukhiTextModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    let color: Color
    let larivaar: Bool

    init(
        size: CGFloat = 24,
        weight: Font.Weight = .regular,
        color: Color = .primary,
        larivaar: Bool = false
    ) {
        self.size = size
        self.weight = weight
        self.color = color
        self.larivaar = larivaar
    }

    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.gurmukhiUnicode(size: size, weight: weight))
            .foregroundStyle(color)
            .lineSpacing(size * 0.4)
            .tracking(larivaar ? 0 : 1)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func gurmukhiStyle(
        size: CGFloat = 24,
        weight: Font.Weight = .regular,
        color: Color = .primary,
        larivaar: Bool = false
    ) -> some View {
        modifier(GurmukhiTextModifier(
            size: size,
            weight: weight,
            color: color,
            larivaar: larivaar
        ))
    }
}

/// Transliteration text style modifier
struct TransliterationTextModifier: ViewModifier {
    let size: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .regular, design: .serif))
            .italic()
            .foregroundStyle(color)
            .lineSpacing(size * 0.3)
    }
}

extension View {
    func transliterationStyle(
        size: CGFloat = 16,
        color: Color = .secondary
    ) -> some View {
        modifier(TransliterationTextModifier(size: size, color: color))
    }
}

/// Translation text style modifier
struct TranslationTextModifier: ViewModifier {
    let size: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .regular, design: .default))
            .foregroundStyle(color)
            .lineSpacing(size * 0.25)
    }
}

extension View {
    func translationStyle(
        size: CGFloat = 15,
        color: Color = .secondary
    ) -> some View {
        modifier(TranslationTextModifier(size: size, color: color))
    }
}

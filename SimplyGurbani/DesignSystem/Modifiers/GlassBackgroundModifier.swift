import SwiftUI

/// View modifier for applying glass background effect
struct GlassBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    let opacity: Double
    let borderWidth: CGFloat

    init(
        cornerRadius: CGFloat = AppTheme.CornerRadius.large,
        opacity: Double = 0.15,
        borderWidth: CGFloat = 0.5
    ) {
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.borderWidth = borderWidth
    }

    func body(content: Content) -> some View {
        content
            .background {
                GlassBackground(
                    cornerRadius: cornerRadius,
                    opacity: opacity,
                    borderWidth: borderWidth
                )
            }
    }
}

extension View {
    func glassBackground(
        cornerRadius: CGFloat = AppTheme.CornerRadius.large,
        opacity: Double = 0.15,
        borderWidth: CGFloat = 0.5
    ) -> some View {
        modifier(GlassBackgroundModifier(
            cornerRadius: cornerRadius,
            opacity: opacity,
            borderWidth: borderWidth
        ))
    }
}

import SwiftUI

/// Reusable glass card component with iOS 18 liquid glass aesthetic
struct GlassCard<Content: View>: View {
    let content: Content
    var padding: CGFloat
    var cornerRadius: CGFloat

    init(
        padding: CGFloat = AppTheme.Spacing.lg,
        cornerRadius: CGFloat = AppTheme.CornerRadius.large,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        content
            .padding(padding)
            .background {
                GlassBackground(cornerRadius: cornerRadius)
            }
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

/// Glass background with blur and gradient overlay
struct GlassBackground: View {
    let cornerRadius: CGFloat
    var opacity: Double = 0.15
    var borderWidth: CGFloat = 0.5

    var body: some View {
        ZStack {
            // Blur layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)

            // Gradient overlay for glass effect
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(opacity * 1.5),
                            Color.white.opacity(opacity * 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Inner highlight border
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: borderWidth
                )
        }
    }
}

/// Glass button style
struct GlassButtonStyle: ButtonStyle {
    let isProminent: Bool

    init(isProminent: Bool = false) {
        self.isProminent = isProminent
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background {
                if isProminent {
                    Capsule()
                        .fill(AppTheme.Gradients.saffronGradient)
                } else {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Capsule()
                                .strokeBorder(
                                    AppTheme.Colors.glassBorder,
                                    lineWidth: 0.5
                                )
                        }
                }
            }
            .foregroundStyle(isProminent ? .white : .primary)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(AppTheme.Animation.quick, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == GlassButtonStyle {
    static var glass: GlassButtonStyle { GlassButtonStyle() }
    static var glassProminent: GlassButtonStyle { GlassButtonStyle(isProminent: true) }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.orange, .red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Glass Card")
                        .font(.headline)
                    Text("This is a glass card with the liquid glass aesthetic.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()

            HStack(spacing: 16) {
                Button("Glass") {}
                    .buttonStyle(.glass)

                Button("Prominent") {}
                    .buttonStyle(.glassProminent)
            }
        }
    }
}

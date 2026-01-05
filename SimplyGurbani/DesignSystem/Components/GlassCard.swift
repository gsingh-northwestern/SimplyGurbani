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

    // Dark blue for shadow - ties into palette
    private let shadowColor = Color(red: 0.0, green: 0.188, blue: 0.286)

    var body: some View {
        content
            .padding(padding)
            .background {
                GlassBackground(cornerRadius: cornerRadius)
            }
            .shadow(
                color: shadowColor.opacity(0.08),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

/// Card background - warm white that complements beige palette
struct GlassBackground: View {
    let cornerRadius: CGFloat
    var opacity: Double = 0.15
    var borderWidth: CGFloat = 0.5

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(AppTheme.Colors.cardBackground)
            .overlay {
                // Subtle inner border for definition
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        AppTheme.Colors.accentDarkBlue.opacity(0.08),
                        lineWidth: borderWidth
                    )
            }
    }
}

/// Button style matching card aesthetic
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
                        .fill(AppTheme.Colors.primaryBurgundy)
                } else {
                    Capsule()
                        .fill(AppTheme.Colors.cardBackground)
                        .overlay {
                            Capsule()
                                .strokeBorder(
                                    AppTheme.Colors.accentDarkBlue.opacity(0.1),
                                    lineWidth: 0.5
                                )
                        }
                }
            }
            .foregroundStyle(isProminent ? .white : AppTheme.Colors.accentDarkBlue)
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

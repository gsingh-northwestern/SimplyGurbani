import SwiftUI

struct FeedbackCard: View {
    @Binding var showingFeedback: Bool

    var body: some View {
        Button {
            showingFeedback = true
        } label: {
            GlassCard {
                HStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "bubble.left.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.Colors.primaryBurgundy)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Send Feedback")
                            .font(AppTheme.Typography.headline)
                            .foregroundStyle(AppTheme.Colors.accentDarkBlue)

                        Text("Help improve Simply Gurbani")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        AppTheme.Colors.backgroundBeige
            .ignoresSafeArea()

        FeedbackCard(showingFeedback: .constant(false))
            .padding()
    }
}

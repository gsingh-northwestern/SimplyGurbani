import SwiftUI
import UIKit

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: FeedbackCategory = .general
    @State private var message: String = ""

    enum FeedbackCategory: String, CaseIterable {
        case bug = "Bug Report"
        case feature = "Feature Request"
        case general = "General Feedback"
        case other = "Other"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(FeedbackCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .listRowBackground(AppTheme.Colors.cardBackground)
                }

                Section("Message") {
                    TextEditor(text: $message)
                        .frame(minHeight: 150)
                        .listRowBackground(AppTheme.Colors.cardBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.Colors.backgroundBeige)
            .navigationTitle("Send Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        sendFeedback()
                    }
                    .disabled(message.isEmpty)
                }
            }
        }
    }

    private func sendFeedback() {
        let subject = "Simply Gurbani - \(selectedCategory.rawValue)"
        let body = message
        let recipient = "gsingh.honsla@gmail.com"

        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? body

        let mailto = "mailto:\(recipient)?subject=\(subjectEncoded)&body=\(bodyEncoded)"

        if let url = URL(string: mailto) {
            UIApplication.shared.open(url)
        }
        dismiss()
    }
}

#Preview {
    FeedbackView()
}

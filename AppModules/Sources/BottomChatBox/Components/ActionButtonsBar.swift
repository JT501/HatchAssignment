// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct ActionButtonsBar: View {
    var text: String = ""
    var onDidTapImageButton: (() -> Void)?
    var onDidTapSendButton: (() -> Void)?

    var body: some View {
        HStack {
            Button {
                onDidTapImageButton?()
            }
            label: {
                Image(systemName: "photo.circle")
                    .font(.system(size: 35))
            }
            .transaction { t in
                t.disablesAnimations = true
            }

            Spacer()

            Button {
                onDidTapSendButton?()
            }
            label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.system(size: 35))
            }
            .disabled(text.isEmpty)
            .animation(.easeInOut, value: text)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

#Preview {
    ActionButtonsBar()
}

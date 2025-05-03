// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppColors
import SwiftUI

struct ActionButtonsBar: View {
    var isSendButtonEnabled: Bool = true
    var onDidTapImageButton: (() -> Void)?
    var onDidTapSendButton: (() -> Void)?

    var body: some View {
        HStack {
            Button {
                onDidTapImageButton?()
            }
            label: {
                Image(systemName: "photo.circle")
                    .resizable()
                    .font(.system(size: 35))
                    .scaledToFit()
                    .frame(height: 35)
            }
            .tint(.secondaryColor)
            .transaction { t in
                t.disablesAnimations = true
            }
            .padding(.horizontal, 4)
            .accessibilityLabel("Photo Button")
            .accessibilityHint("Tap to pick a photo from your library")

            Spacer()

            Button {
                onDidTapSendButton?()
            }
            label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .font(.system(size: 35))
                    .frame(height: 35)
                    .scaledToFit()
                    .background(
                        isSendButtonEnabled ? .white : .clear,
                        in: .circle
                    )
                    .overlay {
                        isSendButtonEnabled ?
                            Circle()
                            .stroke(
                                .secondaryColor.opacity(0.8),
                                lineWidth: 1
                            )
                            : nil
                    }
            }
            .padding(.horizontal, 4)
            .tint(.secondaryColor)
            .disabled(!isSendButtonEnabled)
            .animation(.easeInOut, value: isSendButtonEnabled)
            .glowingShadow(
                colors: [
                    .secondaryColor,
                    .white,
                ],
                isActive: isSendButtonEnabled
            )
            .accessibilityLabel("Send Button")
            .accessibilityHint("Tap to send your message")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

#Preview {
    ActionButtonsBar(
        isSendButtonEnabled: false
    )
}

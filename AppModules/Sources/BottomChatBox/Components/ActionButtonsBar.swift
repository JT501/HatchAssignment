// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct ActionButtonsBar: View {
    var isSendButtonEnabled: Bool = false
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
                    .padding(-3)
                    .background(.white)
                    .clipShape(.circle)
            }
            .padding(3)
            .disabled(!isSendButtonEnabled)
            .animation(.easeInOut, value: isSendButtonEnabled)
            .glowingShadow(isActive: isSendButtonEnabled)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

#Preview {
    ActionButtonsBar()
}

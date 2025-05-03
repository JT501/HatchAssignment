// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI
import AppColors

struct TopBar: View {
    var body: some View {
        HStack {
            Button {}
                label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .bold()
                        .tint(.primaryColor)
                        .padding(.horizontal)
                }
                .accessibilityLabel("Close Button")
                .accessibilityHint("Close the current chat")

            Spacer()

            Text("Some Text")
                .bold()
                .accessibilityLabel("Chat Title")

            Spacer()

            Button {}
                label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .tint(.black)
                        .padding(.horizontal)
                }
                .hidden()
                .accessibilityHidden(true)
                
        }
        .padding(.vertical, 4)
    }
}

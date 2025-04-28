// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct ResizeButton: View {
    var isExpanded: Bool = false
    var onDidTapButton: (() -> Void)?
    
    var body: some View {
        Button {
            onDidTapButton?()
        } label: {
            ZStack {
                Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                    .imageScale(.medium)
                    .padding(.horizontal, 8)
                    .tint(.black)
                    .opacity(isExpanded ? 0 : 1)

                Image(systemName: "arrow.down.forward.and.arrow.up.backward")
                    .imageScale(.medium)
                    .padding(.horizontal, 8)
                    .tint(.black)
                    .opacity(isExpanded ? 1 : 0)
            }
        }
    }
}

#Preview {
    ResizeButton()
}

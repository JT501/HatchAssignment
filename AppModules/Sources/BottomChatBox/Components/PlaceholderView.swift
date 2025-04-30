// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct PlaceholderView: View {
    var placeholder: String = "Start Typing..."
    
    var body: some View {
        Text(placeholder)
            .font(.system(size: 18))
            .foregroundStyle(.placeholder)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
    }
}

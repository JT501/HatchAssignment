// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct TextChipScrollView: View {
    var textChips: [TextChip]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(textChips) {
                    TextChipView(chip: $0)
                }
            }
        }
        .contentMargins(12, for: .scrollContent)
        .padding(.vertical, 5)
        .frame(height: 80)
    }
}

#Preview {
    TextChipScrollView(textChips: .mock)
        .background(.gray)
}

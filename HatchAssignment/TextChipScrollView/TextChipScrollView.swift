// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct TextChipScrollView: View {
    var textChips: [TextChip]
    var onDidSelect: ((TextChip) -> Void)?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(textChips) { textChip in
                    TextChipView(chip: textChip)
                        .onTapGesture {
                            onDidSelect?(textChip)
                        }
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

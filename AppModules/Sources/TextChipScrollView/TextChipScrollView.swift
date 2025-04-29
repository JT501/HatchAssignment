// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI
import AppModels

public struct TextChipScrollView: View {
    public var textChips: [TextChip]
    public var onDidSelect: ((TextChip) -> Void)?
    
    public init(
        textChips: [TextChip],
        onDidSelect: ((TextChip) -> Void)? = nil
    ) {
        self.textChips = textChips
        self.onDidSelect = onDidSelect
    }

    public var body: some View {
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

// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI
import AppModels
import AppColors

public struct TextChipView: View {
    @State public var chip: TextChip
    
    public init(chip: TextChip) {
        self.chip = chip
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(chip.title)
                .bold()
            
            Text(chip.text)
                .fontWeight(.light)
                .lineLimit(1)
        }
        .font(.system(size: 14))
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(.overlay)
        .clipShape(Capsule())
    }
}

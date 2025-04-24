// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct TextChipView: View {
    @State var chip: TextChip
    
    init(chip: TextChip) {
        self.chip = chip
    }
    
    var body: some View {
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
        .background(.white)
        .clipShape(Capsule())
    }
}

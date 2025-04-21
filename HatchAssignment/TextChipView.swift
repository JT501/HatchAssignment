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
                .lineLimit(1)
        }
        .font(.system(size: 14))
        .padding()
        .background(.white)
        .clipShape(Capsule())
    }
}

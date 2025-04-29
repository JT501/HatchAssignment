// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct SheetBackgroundEffect: ViewModifier {
    var trigger: Bool

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: trigger ? 15 : 0))
            .scaleEffect(trigger ? 0.9 : 1)
            .brightness(trigger ? -0.2 : 0)
            .animation(.bouncy, value: trigger)
    }
}

extension View {
    func sheetBackgroundEffect(trigger: Bool) -> some View {
        modifier(SheetBackgroundEffect(trigger: trigger))
    }
}

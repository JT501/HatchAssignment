// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct SheetBackgroundEffect: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    var trigger: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                Color.gray.opacity(trigger ? 0.25 : 0)
            }
            .clipShape(RoundedRectangle(cornerRadius: trigger ? 15 : 0))
            .scaleEffect(trigger ? 0.9 : 1)
            .animation(.bouncy, value: trigger)
    }
}

extension View {
    func sheetBackgroundEffect(trigger: Bool) -> some View {
        modifier(SheetBackgroundEffect(trigger: trigger))
    }
}

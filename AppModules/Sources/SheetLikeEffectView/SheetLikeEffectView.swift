// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppHelpers
import SwiftUI

public struct SheetLikeEffectView<Content: View, Overlay: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    public var trigger: Bool

    let content: Content
    let overlay: Overlay

    public init(
        trigger: Bool,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlay: () -> Overlay
    ) {
        self.trigger = trigger
        self.content = content()
        self.overlay = overlay()
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()

            ZStack(alignment: .bottom) {
                content
                    .sheetBackgroundEffect(trigger: trigger)

                overlay
            }
            .ignoresSafeArea(.all)
        }
    }
}

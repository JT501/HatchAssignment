// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppHelpers
import SwiftUI

public struct SheetLikeEffectView<Content: View, Overlay: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    public var trigger: Bool
    public var topPadding: CGFloat?

    let content: Content
    let overlay: Overlay

    public init(
        trigger: Bool,
        topPadding: CGFloat? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder overlay: () -> Overlay
    ) {
        self.trigger = trigger
        self.topPadding = topPadding
        self.content = content()
        self.overlay = overlay()
    }

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)

            ZStack(alignment: .bottom) {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .sheetBackgroundEffect(trigger: trigger)

                overlay
                    .padding(
                        .top,
                        trigger ? (topPadding ?? safeAreaInsets.top) : 0
                    )
            }
            .ignoresSafeArea(.all)
        }
    }
}

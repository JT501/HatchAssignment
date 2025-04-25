// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct SheetLikeEffectView<Content: View, Overlay: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var trigger: Bool
    var topPadding: CGFloat?

    @ViewBuilder var content: () -> Content
    @ViewBuilder var overlay: () -> Overlay

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)

            ZStack(alignment: .bottom) {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .sheetBackgroundEffect(trigger: trigger)

                overlay()
                    .padding(
                        .top,
                        trigger ? (topPadding ?? safeAreaInsets.top) : 0
                    )
            }
            .ignoresSafeArea(.all)
        }
    }
}

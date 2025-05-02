// Created for AppModules in 2025
// Using Swift 6.0

import Foundation
import SwiftUI

public extension View {
    func glowingShadow(
        shape: some Shape = Circle(),
        height: CGFloat = 35,
        width: CGFloat = 35,
        colors: [Color] = [.blue, .yellow],
        isActive: Bool = false
    ) -> some View {
        modifier(
            GlowingShadow(
                shape: shape,
                height: height,
                width: width,
                colors: colors,
                isActive: isActive
            )
        )
    }
}

struct GlowingShadow<S: Shape>: ViewModifier {
    let shape: S
    let height: CGFloat, width: CGFloat
    let colors: [Color]
    var isActive: Bool

    init(
        shape: S = Circle(),
        height: CGFloat = 35,
        width: CGFloat = 35,
        colors: [Color] = [.blue, .yellow],
        isActive: Bool
    ) {
        precondition(
            !colors.isEmpty,
            "Should be at least one color"
        )

        self.shape = shape
        self.height = height
        self.width = width
        self.colors = colors
        self.isActive = isActive
    }

    @State var rotating: Bool = false
    @State var breathing: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            shape
                .fill(
                    AngularGradient(
                        colors: colors + [colors.first!],
                        center: .center,
                        angle: .degrees(rotating ? 360 : 0)
                    )
                )
                .frame(width: width, height: height)
                .scaleEffect(breathing ? 1.15 : 1.05)
                .blur(radius: breathing ? 10 : 5)
                .opacity(isActive ? 1 : 0)

            content
                .scaleEffect(isActive ? 1.05 : 1)
        }
        .onChange(of: isActive) { old, new in
            guard new != old else { return }

            withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)) {
                rotating = new
            }
            withAnimation(.easeInOut(duration: 3.5).repeatForever()) {
                breathing = new
            }
        }
    }
}

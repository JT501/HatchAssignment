// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

public extension ShapeStyle where Self == Color {
    static var backgroundPrimary: Self { .name("BackgroundPrimary") }
    static var primaryColor: Self { .name("Primary")}
    static var secondaryColor: Self { .name("Secondary")}
    static var overlay: Self { .name("Overlay") }
    static var overlay2: Self { .name("Overlay2") }
}

extension Color {
    static func name(_ name: String) -> Self {
        .init(name, bundle: .module)
    }
}

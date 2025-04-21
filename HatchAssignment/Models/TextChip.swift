// Created for HatchAssignment in 2025
// Using Swift 6.0

import Foundation

public struct TextChip: Identifiable {
    public var id: UUID
    public var title: String
    public var text: String

    public init(
        id: UUID = UUID(),
        title: String,
        text: String
    ) {
        self.id = id
        self.title = title
        self.text = text
    }
}

public extension TextChip {
    static var mock: Self {
        .init(
            title: "Some Text",
            text: "Some more text"
        )
    }
}

public extension [TextChip] {
    static var mock: Self {
        [
            .init(title: "Some Text", text: "Some more text"),
            .init(title: "Some Text", text: "Some more text"),
            .init(title: "Some Text", text: "Some more text"),
            .init(title: "Some Text", text: "Some more text"),
            .init(title: "Some Text", text: "Some more text"),
        ]
    }
}

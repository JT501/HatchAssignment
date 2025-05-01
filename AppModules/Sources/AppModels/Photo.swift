// Created for AppModules in 2025
// Using Swift 6.0

import AppHelpers
import Foundation
import SwiftUI

public struct Photo: Identifiable, Equatable {
    public let id: UUID
    public var color: Color

    public init(
        id: UUID = UUID(),
        color: Color = .random
    ) {
        self.id = id
        self.color = color
    }
}

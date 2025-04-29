// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct ObserveKeyboard: ViewModifier {
    @Binding var isKeyboardShow: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardWillShowNotification
                )
                .receive(on: RunLoop.main),
                perform: { _ in
                    isKeyboardShow = true
                }
            )
            .onReceive(
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardWillHideNotification
                )
                .receive(on: RunLoop.main),
                perform: { _ in
                    isKeyboardShow = false
                }
            )
    }
}

public extension View {
    func observeKeyboard(_ isKeyboardShow: Binding<Bool>) -> some View {
        modifier(ObserveKeyboard(isKeyboardShow: isKeyboardShow))
    }
}

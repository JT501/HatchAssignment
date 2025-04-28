// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

@Observable
class BottomChatBoxViewModel {
    let selectedImageScrollViewHeight: CGFloat = 60

    enum Destination {
        case inputText
        case inputTextFull
        case imagePicker
    }

    // Cannot use @Environment outside of SwifUI View :(
    var safeAreaInsets = UIApplication
        .shared
        .keyWindow?
        .safeAreaInsets
        .swiftUiInsets ?? EdgeInsets()

    var text: String
    var selectedImage: [Color] = []
    var destination: Destination?
    var isImagePickerExpanded: Bool = false
    var isKeyboardShown: Bool = false

    var resizeButtonOpacity: Double {
        !text.isEmpty ||
            destination == .inputTextFull ? 1 : 0
    }

    var expandTextInput: Bool {
        destination == .inputTextFull
    }

    var showImagePicker: Bool {
        destination == .imagePicker
    }

    var showSelectedImages: Bool {
        !selectedImage.isEmpty
    }

    var bottomPadding: CGFloat {
        switch destination {
            case .inputText, .inputTextFull:
                isKeyboardShown ?
                    12 : safeAreaInsets.bottom

            case .imagePicker:
                if !isImagePickerExpanded {
                    PhotoPickerView.viewHeight + 8
                } else {
                    0 - (showSelectedImages ? selectedImageScrollViewHeight : 0)
                        - (isKeyboardShown ? 12 : 0)
                }

            case nil:
                safeAreaInsets.bottom
        }
    }

    init(
        text: String = "",
        destination: Destination? = nil,
    ) {
        self.text = text
        self.destination = destination
    }

    func onTextInputDidTap() {
        guard destination != .inputText, destination != .inputTextFull else { return }

        withAnimation(.easeInOut(duration: 0.5)) {
            destination = .inputText
        }
    }

    func onDidTapResizeButton() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if destination == .inputTextFull {
                destination = .inputText
            } else {
                destination = .inputTextFull
            }
        }
    }

    func onIsKeyboardShownDidChange(_ isShown: Bool) {
        if !isShown, destination == .inputText {
            withAnimation(.easeOut(duration: 0.5)) {
                destination = nil
            }
        }
    }

    func onDidTapImagePickerButton() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if destination == .imagePicker {
                destination = nil
            } else {
                destination = .imagePicker
            }
        }
    }

    func onDidSelectedImage(_ color: Color) {
        withAnimation(.easeInOut(duration: 0.5)) {
            destination = nil
            selectedImage.append(color)
        }
    }
}

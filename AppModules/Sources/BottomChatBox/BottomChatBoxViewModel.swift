// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI
import PhotoPickerView
import AppHelpers

@MainActor
@Observable
public class BottomChatBoxViewModel {
    let selectedImageScrollViewHeight: CGFloat = 60

    public enum Destination {
        case inputText
        case inputTextFull
        case imagePicker
    }

    // Cannot use @Environment outside of SwifUI View :(
    var safeAreaInsets = UIApplication
        .shared
        .newKeyWindow?
        .safeAreaInsets
        .swiftUiInsets ?? EdgeInsets()

    public var text: String
    public var selectedImage: [Color] = []
    public var destination: Destination?
    public var isImagePickerExpanded: Bool = false
    public var isKeyboardShown: Bool = false

    public var resizeButtonOpacity: Double {
        !text.isEmpty ||
            destination == .inputTextFull ? 1 : 0
    }

    public var expandTextInput: Bool {
        destination == .inputTextFull
    }

    public var showImagePicker: Bool {
        destination == .imagePicker
    }

    public var showSelectedImages: Bool {
        !selectedImage.isEmpty
    }

    public var bottomPadding: CGFloat {
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

    public init(
        text: String = "",
        destination: Destination? = nil,
    ) {
        self.text = text
        self.destination = destination
    }

    public func onTextInputDidTap() {
        guard destination != .inputText, destination != .inputTextFull else { return }

        withAnimation(.easeInOut(duration: 0.5)) {
            destination = .inputText
        }
    }

    public func onDidTapResizeButton() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if destination == .inputTextFull {
                destination = .inputText
            } else {
                destination = .inputTextFull
            }
        }
    }

    public func onIsKeyboardShownDidChange(_ isShown: Bool) {
        if !isShown, destination == .inputText {
            withAnimation(.easeOut(duration: 0.5)) {
                destination = nil
            }
        }
    }

    public func onDidTapImagePickerButton() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if destination == .imagePicker {
                destination = nil
            } else {
                destination = .imagePicker
            }
        }
    }

    public func onDidSelectedImage(_ color: Color) {
        withAnimation(.easeInOut(duration: 0.5)) {
            destination = nil
            selectedImage.append(color)
        }
    }
}

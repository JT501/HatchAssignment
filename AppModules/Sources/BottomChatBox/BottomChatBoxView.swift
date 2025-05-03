// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppColors
import Observation
import PhotoPickerView
import SelectedImagesScrollView
import SwiftUI

public struct BottomChatBoxView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    private let dragThreshold: CGFloat = 75

    @State var viewModel: BottomChatBoxViewModel
    var expandHeight: CGFloat?
    @State private var imageButtonOnTap: Bool = false

    // Callback functions
    var onDidResize: ((Bool) -> Void)?

    @FocusState var isTextFieldFocused: Bool
    @GestureState var dragState = CGFloat.zero

    var dragDown: some Gesture {
        DragGesture(coordinateSpace: .global)
            .updating($dragState) { drag, state, _ in
                state = drag.translation.height

                if drag.translation.height > dragThreshold {
                    isTextFieldFocused = false
                    withAnimation {
                        if viewModel.destination != .inputTextFull {
                            viewModel.destination = nil
                        }
                    }
                }
            }
    }

    public init(
        viewModel: BottomChatBoxViewModel,
        expandHeight: CGFloat? = nil,
        onDidResize: ((Bool) -> Void)? = nil,
    ) {
        self.viewModel = viewModel
        self.expandHeight = expandHeight
        self.onDidResize = onDidResize
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack(alignment: .top) {
                    Group {
                        AutoFontSizeTextEditor(
                            text: $viewModel.text,
                            placeHolder: "Start Typing...",
                            overrideFontSize: viewModel.expandTextInput,
                            isTextFieldFocused: _isTextFieldFocused
                        )
                        .onChange(of: isTextFieldFocused) { _, new in
                            if new {
                                viewModel.onTextInputDidTap()
                            }
                        }

                        ResizeButton(isExpanded: viewModel.expandTextInput) {
                            viewModel.onDidTapResizeButton()
                            onDidResize?(viewModel.expandTextInput)
                        }
                        .opacity(viewModel.resizeButtonOpacity)
                        .disabled(viewModel.resizeButtonOpacity == 0)
                        .animation(
                            .easeInOut(duration: 0.25),
                            value: viewModel.resizeButtonOpacity
                        )
                        .sensoryFeedback(
                            .impact,
                            trigger: viewModel.expandTextInput
                        )
                    }
                }
                .frame(height: viewModel.expandTextInput ? nil : 90)
                .contentShape(Rectangle())
                .padding(.horizontal)

                if viewModel.showSelectedImages {
                    SelectedImageScrollView(
                        selectedImage: $viewModel.selectedImage
                    )
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        )
                    )
                }

                ActionButtonsBar(
                    isSendButtonEnabled: !viewModel.text.isEmpty || !viewModel.selectedImage.isEmpty,
                    onDidTapImageButton: {
                        isTextFieldFocused = false
                        onDidResize?(false)
                        imageButtonOnTap.toggle()
                        viewModel.onDidTapImagePickerButton()
                    }
                )
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.top, 20)
            .padding(.bottom, viewModel.bottomPadding)
            .background(.overlay)
            // Only top corners have radius
            .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
            .shadow(radius: 5, x: 0, y: 2)
            // Mask the bottom shadow
            .mask {
                Rectangle().padding(.top, -10)
            }
            .animation(
                .linear(duration: 0.5),
                value: viewModel.showSelectedImages
            )
            .animation(
                .linear(duration: 0.25),
                value: viewModel.isKeyboardShown
            )
            .animation(
                .bouncy(duration: 0.5),
                value: viewModel.expandTextInput
            )
            .animation(
                .easeInOut(duration: 0.5),
                value: viewModel.bottomPadding
            )
            .zIndex(0)

            if viewModel.showImagePicker {
                PhotoPickerView(
                    expandHeight: expandHeight,
                    onWillResize: { isExpanded in
                        viewModel.isImagePickerExpanded = isExpanded
                        onDidResize?(isExpanded)
                    }, onSelected: {
                        viewModel.isImagePickerExpanded = false
                        onDidResize?(false)
                        viewModel.onDidSelectedImage($0)
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .frame(maxHeight: viewModel.expandTextInput ? expandHeight : nil)
        .animation(
            .easeInOut(duration: 0.5),
            value: viewModel.showImagePicker
        )
        .observeKeyboard($viewModel.isKeyboardShown)
        .onChange(of: viewModel.isKeyboardShown) {
            viewModel.onIsKeyboardShownDidChange($1)
        }
        .gesture(
            dragDown,
            isEnabled: !viewModel.isImagePickerExpanded
        )
        .sensoryFeedback(
            .impact(weight: .medium, intensity: 1.0),
            trigger: imageButtonOnTap
        )
    }
}

#Preview {
    ZStack {
        Color.backgroundPrimary
            .ignoresSafeArea()

        BottomChatBoxView(
            viewModel: .init(text: "Hello World")
        )
    }
}

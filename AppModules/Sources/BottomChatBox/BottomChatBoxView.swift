// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppConstants
import Observation
import PhotoPickerView
import SelectedImagesScrollView
import SwiftUI

public struct BottomChatBoxView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @State var viewModel: BottomChatBoxViewModel

    // Callback functions
    var onDidResize: ((Bool) -> Void)?

    @FocusState var isTextFieldFocused: Bool
    @GestureState var dragState = CGFloat.zero

    public init(
        viewModel: BottomChatBoxViewModel,
        onDidResize: ((Bool) -> Void)? = nil,
    ) {
        self.viewModel = viewModel
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
                        .animation(.easeInOut, value: viewModel.resizeButtonOpacity)
                        .sensoryFeedback(
                            .impact,
                            trigger: viewModel.expandTextInput
                        )
                    }
                    .frame(
                        height: viewModel.expandTextInput ? nil : 90,
                        alignment: .top
                    )
                }
                .contentShape(Rectangle())
                .padding(.horizontal)

                if viewModel.showSelectedImages {
                    SelectedImageScrollView(
                        selectedImage: $viewModel.selectedImage
                    )
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .leading)
                        )
                    )
                }

                ActionButtonsBar(
                    text: viewModel.text,
                    onDidTapImageButton: {
                        isTextFieldFocused = false
                        onDidResize?(false)
                        viewModel.onDidTapImagePickerButton()
                    }
                )
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, viewModel.bottomPadding)
            .background(.white)
            // Only top corners have radius
            .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
            .shadow(radius: 5, x: 0, y: 2)
            // Mask the bottom shadow
            .mask {
                Rectangle().padding(.top, -10)
            }
            .animation(.easeOut, value: viewModel.showSelectedImages)
            .animation(
                .easeIn(duration: 0.25),
                value: viewModel.isKeyboardShown
            )
            .zIndex(0)

            if viewModel.showImagePicker {
                PhotoPickerView(
                    onWillResize: { isExpanded in
                        viewModel.isImagePickerExpanded = isExpanded
                        onDidResize?(isExpanded)
                    }, onSelected: {
                        viewModel.isImagePickerExpanded = false
                        onDidResize?(false)
                        viewModel.onDidSelectedImage($0)
                    }
                )
                .ignoresSafeArea(.keyboard)
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .observeKeyboard($viewModel.isKeyboardShown)
        .onChange(of: viewModel.isKeyboardShown) {
            viewModel.onIsKeyboardShownDidChange($1)
        }
        .gesture(
            DragGesture(coordinateSpace: .global)
                .updating($dragState) { drag, state, _ in
                    state = drag.translation.height

                    if drag.translation.height > 75 {
                        isTextFieldFocused = false
                        withAnimation {
                            if viewModel.destination != .inputTextFull {
                                viewModel.destination = nil
                            }
                        }
                    }
                }
        )
    }
}

#Preview {
    ZStack {
        Color.bgLightGray
            .ignoresSafeArea()

        BottomChatBoxView(
            viewModel: .init(text: "Hello World")
        )
    }
}

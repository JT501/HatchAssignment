// Created for HatchAssignment in 2025
// Using Swift 6.0

import Foundation
import SwiftUI

struct ContentView: View {
    @State var text = ""
    @State var textChips: [TextChip] = .mock
    @State var expandButtonOpacity = 0.0
    @State var isEditing = false

    @FocusState var isTextFieldFocused: Bool
    @GestureState var dragState = DragState.inactive

    enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
                case .inactive:
                    .zero
                case let .dragging(translation: translation):
                    translation
            }
        }

        var isDragging: Bool {
            switch self {
                case .inactive:
                    false
                case .dragging:
                    true
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.yellow
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .padding()
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollDismissesKeyboard(.automatic)

            VStack {
                TextChipScrollView(textChips: textChips)

                VStack {
                    HStack(alignment: .top) {
                        Group {
                            if !isEditing && text.isEmpty {
                                Text("Start Typing...")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        isTextFieldFocused = true
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            isEditing = true
                                        }
                                    }
                                    .transition(.opacity)
                            } else {
                                TextInputView(
                                    text: $text,
                                    isTextFieldFocused: _isTextFieldFocused
                                )
                                .onChange(of: text) { _, newValue in
                                    withAnimation {
                                        expandButtonOpacity = newValue.isEmpty ? 0 : 1
                                    }
                                }
                                .transition(.opacity)
                            }
                        }
                        .frame(height: 90, alignment: .top)

                        Button {
                            isTextFieldFocused = false
                        } label: {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                                .imageScale(.medium)
                                .padding(.horizontal, 8)
                                .tint(.black)
                        }
                        .opacity(expandButtonOpacity)
                        .disabled(text.isEmpty)
                    }

                    HStack {
                        Button {}
                            label: {
                                Image(systemName: "photo.circle")
                                    .font(.system(size: 35))
                            }

                        Spacer()

                        Button {}
                            label: {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 35))
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
                .background(.white)
                .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
                .shadow(radius: 3, x: 0, y: -5)
            }
        }
        .ignoresSafeArea(.container)
        .gesture(
            DragGesture(coordinateSpace: .global)
                .updating($dragState) { drag, state, translation in
                    state = .dragging(translation: drag.translation)

                    if drag.translation.height > 50 {
                        isTextFieldFocused = false
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isEditing = false
                        }
                    }
                }
//                .onEnded { drag in
//                    if drag.translation.height > 20 {
//                        isTextFieldFocused = false
//                        isEditing = false
//                    }
//                }
        )
    }
}

#Preview {
    ContentView()
}

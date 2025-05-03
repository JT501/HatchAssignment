// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppColors
import AppHelpers
import AppModels
import BottomChatBox
import Foundation
import KeyboardAttachedView
import SheetLikeEffectView
import SwiftUI
import TextChipScrollView

struct ChatView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @State var textChips: [TextChip] = .mock
    @State private var isChatBoxExpanded: Bool = false
    @State private var showTextChips: Bool = true
    @State private var bottomChatBoxViewModel = BottomChatBoxViewModel()
    @State private var offset: CGFloat = 0

    private var chatBoxExpandHeight: CGFloat {
        UIScreen.main.bounds.height - abs(offset) - safeAreaInsets.top
    }

    var body: some View {
        SheetLikeEffectView(
            trigger: isChatBoxExpanded
        ) {
            VStack {
                TopBar()
                    .padding(.top, safeAreaInsets.top)

                ScrollView {
                    VStack {
                        EmptyView()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentMargins(.bottom, -offset, for: .scrollContent)
                .scrollDismissesKeyboard(.interactively)
            }
            .background {
                KeyboardAttachedView(offset: $offset)
                    .frame(height: 0)
                    .frame(maxHeight: UIScreen.main.bounds.height, alignment: .bottom)
            }
            .background(.backgroundPrimary)
        } overlay: {
            VStack {
                Spacer()

                if showTextChips {
                    TextChipScrollView(textChips: textChips) {
                        print("Selected Chip:", $0)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top),
                            removal: .identity
                        )
                    )
                }

                BottomChatBoxView(
                    viewModel: bottomChatBoxViewModel,
                    expandHeight: chatBoxExpandHeight
                ) { isExpanded in
                    isChatBoxExpanded = isExpanded

                    withAnimation(.bouncy(duration: 0.3).delay(0.2)) {
                        showTextChips = !isExpanded
                    }
                }
                .animation(nil, value: showTextChips)
            }
            .offset(y: offset + 2)
        }
    }
}

#Preview {
    ChatView()
}

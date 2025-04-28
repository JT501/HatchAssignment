// Created for HatchAssignment in 2025
// Using Swift 6.0

import Foundation
import SwiftUI

struct ContentView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets

    @State var textChips: [TextChip] = .mock
    @State private var isChatBoxExpanded: Bool = false
    @State private var showTextChips: Bool = true
    @State private var bottomChatBoxViewModel = BottomChatBoxViewModel()
    @State private var offset: CGFloat = 0

    var body: some View {
        SheetLikeEffectView(
            trigger: isChatBoxExpanded,
            topPadding: safeAreaInsets.top + abs(offset)
        ) {
            ZStack {
                Color.bgLightGray
                    .ignoresSafeArea()
                
                VStack {
                    TopBar()
                        .padding(.top, safeAreaInsets.top)
                    
                    ScrollView {
                        VStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Text("Hello, world!")
                        }
                        .padding()
                    }
                    .contentMargins(.bottom, -offset)
                    .scrollDismissesKeyboard(.interactively)
                }
            }
            .background {
                KeyboardAttachedView(offset: $offset)
                    .frame(height: 0)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        } overlay: {
            VStack {
                if showTextChips {
                    TextChipScrollView(textChips: textChips) {
                        print("Selected Chip:", $0)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top),
                            removal: .opacity
                        )
                    )
                }

                BottomChatBoxView(
                    viewModel: .init()
                ) { isExpanded in
                    isChatBoxExpanded = isExpanded

                    withAnimation(.bouncy(extraBounce: 0.2)) {
                        showTextChips = !isExpanded
                    }
                }
                .animation(nil, value: showTextChips)
            }
            .offset(y: offset)
        }
    }
}

#Preview {
    ContentView()
}

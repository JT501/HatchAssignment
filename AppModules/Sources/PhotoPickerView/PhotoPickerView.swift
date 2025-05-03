// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppHelpers
import AppColors
import AppModels
import SwiftUI
import SwiftUIIntrospect
import UIKit

public struct PhotoPickerView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    public static var shrinkHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    public static var dragThreshold: CGFloat = UIScreen.main.bounds.height * 0.35

    private var tabs: [String] = [
        "Photos",
        "Collections",
    ]

    var expandHeight: CGFloat?
    @State var searchText: String = ""
    @State var selectedTab = "Photos"
    @State var isExpanded: Bool = false
    @State var showNavigationBar: Bool = true
    @State var scrollToTop = false
    @State var photoIsSelected = false
    @State var isResizing = false
    @State var isSearching = false
    @State var currentOffset = CGFloat.zero
    @GestureState var dragState = CGFloat.zero

    // Callback functions
    var onWillResize: ((_ isExpanded: Bool) -> Void)?
    var onSelected: ((Photo) -> Void)?

    @State private var photos: [Photo] = [
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
        .init(), .init(), .init(),
    ]

    private var dragUp: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { drag in
                if drag.translation.height < -Self.dragThreshold {
                    expandView()
                }
            }
    }

    private var dragDown: some Gesture {
        DragGesture()
            .updating($dragState) { drag, state, _ in
                if isExpanded, drag.translation.height > 0 {
                    state = drag.translation.height

                    if drag.translation.height >= Self.dragThreshold {
                        withAnimation {
                            shrinkView()
                        }
                    }
                }
            }
            .onEnded { drag in
                guard drag.translation.height > 0 else { return }
                
                currentOffset = drag.translation.height
                if drag.translation.height > Self.dragThreshold {
                    shrinkView()
                } else {
                    withAnimation(.interactiveSpring) {
                        currentOffset = 0
                    }
                }
            }
    }

    public init(
        expandHeight: CGFloat? = nil,
        onWillResize: ((_ isExpanded: Bool) -> Void)? = nil,
        onSelected: ((Photo) -> Void)? = nil
    ) {
        self.expandHeight = expandHeight
        self.onWillResize = onWillResize
        self.onSelected = onSelected
    }

    public var body: some View {
        NavigationStack {
            PhotoScrollView(
                photos: photos,
                scrollToTop: scrollToTop
            ) { color in
                photoIsSelected = true
                onSelected?(color)
            }
            // Avoid unexpected multi-select
            .allowsHitTesting(!photoIsSelected)
            // Disable scrolling on shrink mode
            .scrollDisabled(!isExpanded)
            .scrollDismissesKeyboard(.interactively)
            .searchable(text: $searchText, prompt: "Search your library")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        shrinkView()
                    }
                    .allowsHitTesting(!isResizing)
                    .accessibilityLabel("Cancel Button")
                    .accessibilityHint("Tap to cancel")
                }

                ToolbarItem(placement: .principal) {
                    Picker("Tab", selection: $selectedTab) {
                        ForEach(tabs, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Dummy Button for even spacing
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {}
                        .hidden()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(showNavigationBar ? .visible : .hidden, for: .navigationBar)
            .background(.overlay2)
            .toolbarBackground(.overlay2, for: .navigationBar)
        }
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: isExpanded ? 15 : 0,
                topTrailingRadius: isExpanded ? 15 : 0
            )
        )
        // Give a short time for introspecting search bar before it is hidden
        .task {
            try? await Task.sleep(for: .milliseconds(10))
            showNavigationBar = false
        }
        .introspect(.searchField, on: .iOS(.v17, .v18)) { searchBar in
            let searchTextField = searchBar.searchTextField
            let micIcon = UIImage(systemName: "microphone.fill")
            let micIconImageView = UIImageView(image: micIcon)
            micIconImageView.tintColor = .gray
            searchTextField.rightView = micIconImageView
            searchTextField.rightViewMode = .always
        }
        .offset(y: currentOffset + dragState)
        // Drag up gesture
        .gesture(
            dragUp,
            isEnabled: !isExpanded
        )
        // Drag up gesture
        .gesture(
            dragDown,
            isEnabled: isExpanded
        )
        .frame(height: isExpanded ? nil : Self.shrinkHeight, alignment: .top)
        .frame(maxHeight: isExpanded ? expandHeight : nil)
        .shadow(radius: isExpanded ? 5 : 0, x: 0, y: 2)
        .animation(.bouncy, value: dragState)
        .sensoryFeedback(
            .impact,
            trigger: isExpanded
        ) { $1 }
        .sensoryFeedback(
            .decrease,
            trigger: isExpanded
        ) { !$1 }
    }

    private func expandView() {
        onWillResize?(true)
        scrollToTop.toggle()
        isResizing = true

        withAnimation(.smooth) {
            isExpanded = true
        } completion: {
            isResizing = false
        }

        withAnimation(.smooth.delay(0.5)) {
            showNavigationBar = true
        } completion: {
            isResizing = false
        }
    }

    private func shrinkView() {
        onWillResize?(false)
        scrollToTop.toggle()
        isResizing = true

        withAnimation(.easeOut(duration: 0.5)) {
            isExpanded = false
            currentOffset = 0
        } completion: {
            isResizing = false
        }

        showNavigationBar = false
    }
}

#Preview {
    PhotoPickerView()
}

// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI
import SwiftUIIntrospect
import UIKit

struct PhotoPickerView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    static var viewHeight: CGFloat = 350
    static var dragThreshold: CGFloat = 150
    private static let topId = "top"

    private var columns: [GridItem] = [
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
    ]

    private var tabs: [String] = [
        "Photos",
        "Collections",
    ]

    @State var searchText: String = ""
    @State var selectedTab = "Photos"
    @State var isExpanded: Bool = false
    @State var showNavigationBar: Bool = true
    @State var currentOffset = CGFloat.zero
    @State var shouldScrollToTop = false
    @State var photoIsSelected = false
    @State var isResizing = false
    @State var isSearching = false
    @GestureState var dragState = CGFloat.zero

    // Callback functions
    var onWillResize: ((_ isExpanded: Bool) -> Void)?
    var onSelected: ((Color) -> Void)?

    @State private var photos: [Color] = [
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
        .random, .random, .random,
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
                }
            }
            .onEnded { drag in
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

    init(
        onWillResize: ((_ isExpanded: Bool) -> Void)? = nil,
        onSelected: ((Color) -> Void)? = nil
    ) {
        self.onWillResize = onWillResize
        self.onSelected = onSelected
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { reader in
                ScrollView {
                    // An empty view for scroll to top action
                    EmptyView()
                        .id(Self.topId)
                        .onChange(of: shouldScrollToTop) {
                            withAnimation {
                                reader.scrollTo(Self.topId, anchor: .top)
                            }
                        }

                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(photos, id: \.self) { color in
                            color.aspectRatio(contentMode: .fill)
                                .onTapGesture { _ in
                                    onSelected?(color)
                                }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            // Avoid unexpected multi-select
            .allowsHitTesting(!photoIsSelected)
            .scrollDisabled(!isExpanded)
            .scrollDismissesKeyboard(.interactively)
            .searchable(text: $searchText, prompt: "Search your library")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        shrinkView()
                    }
                    .allowsHitTesting(!isResizing)
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
            .toolbarVisibility(showNavigationBar ? .visible : .hidden, for: .navigationBar)
        }
        .cornerRadius(isExpanded ? 20 : 0)
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
        .frame(height: isExpanded ? nil : Self.viewHeight, alignment: .top)
        .shadow(radius: isExpanded ? 5 : 0, x: 0, y: 2)
        .sensoryFeedback(
            .impact,
            trigger: isExpanded
        ) { $1 }
    }

    private func expandView() {
        onWillResize?(true)
        shouldScrollToTop = false
        isResizing = true

        withAnimation(.smooth) {
            isExpanded = true
        } completion: {
            isResizing = false
        }

        withAnimation(.smooth.delay(0.5)) {
            showNavigationBar = true
        }
    }

    private func shrinkView() {
        onWillResize?(false)
        shouldScrollToTop = true
        isResizing = true

        withAnimation(.easeOut) {
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

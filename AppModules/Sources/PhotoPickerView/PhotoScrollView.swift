// Created for AppModules in 2025
// Using Swift 6.0

import SwiftUI

public struct PhotoScrollView: View {
    private static let TopId = "top"
    
    @State var photos: [Color]
    @State private var scrollToTop: Bool = false
    
    private var columns: [GridItem] = [
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
    ]
    
    // Callback function
    var onSelected: ((Color) -> Void)?
    
    public init(
        photos: [Color],
        scrollToTop: Bool = false,
        onSelected: ((Color) -> Void)? = nil
    ) {
        self.photos = photos
        self.scrollToTop = scrollToTop
        self.onSelected = onSelected
    }
    
    public var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                // An empty view for scroll to top action
                EmptyView()
                    .id(Self.TopId)
                    .onChange(of: scrollToTop) {
                        withAnimation(.easeIn(duration: 0.5)) {
                            reader.scrollTo(Self.TopId, anchor: .top)
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
    }
}

#Preview {
    PhotoScrollView(
        photos: [.random, .random, .random]
    )
}

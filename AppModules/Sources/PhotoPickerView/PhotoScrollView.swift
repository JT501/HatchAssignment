// Created for AppModules in 2025
// Using Swift 6.0

import AppModels
import SwiftUI

public struct PhotoScrollView: View {
    private static let TopId = "top"

    @State var photos: [Photo]
    private var scrollToTop: Bool = false

    private var columns: [GridItem] = [
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
    ]

    // Callback function
    var onSelected: ((Photo) -> Void)?

    public init(
        photos: [Photo],
        scrollToTop: Bool = false,
        onSelected: ((Photo) -> Void)? = nil
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
                    ForEach(photos) { photo in
                        photo.color.aspectRatio(contentMode: .fill)
                            .onTapGesture { _ in
                                onSelected?(photo)
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
        photos: [.init(), .init(), .init()]
    )
}

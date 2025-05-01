// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

public struct SelectedImageScrollView: View {
    private static let BottomId = "bottom"

    @Binding var selectedImage: [Color]
    @State var shouldScrollToTrail = false

    public init(selectedImage: Binding<[Color]>) {
        _selectedImage = selectedImage
    }

    public var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedImage, id: \.self) { image in
                        ThumbnailView(image: image) {
                            selectedImage.removeAll(where: { $0 == image })
                        }
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .opacity
                            )
                        )
                    }

                    // An invisible spacer for scroll to trailing action
                    Spacer()
                        .frame(width: 4)
                        .id(Self.BottomId)
                        .onChange(of: shouldScrollToTrail) {
                            withAnimation(.bouncy(extraBounce: 0.2)) {
                                reader.scrollTo(Self.bottomId, anchor: .trailing)
                            }
                        }
                }
                .animation(.bouncy, value: selectedImage)
            }
            .scrollIndicators(.hidden)
            .contentMargins(.horizontal, 8, for: .scrollContent)
        }
        .onChange(of: selectedImage) { old, new in
            if new.count > old.count {
                Task {
                    try? await Task.sleep(for: .milliseconds(300))
                    shouldScrollToTrail.toggle()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedImage: [Color] = [.black, .red, .yellow, .green]

    SelectedImageScrollView(
        selectedImage: $selectedImage
    )
}

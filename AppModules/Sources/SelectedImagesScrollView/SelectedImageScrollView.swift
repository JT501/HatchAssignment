// Created for HatchAssignment in 2025
// Using Swift 6.0

import AppModels
import SwiftUI

public struct SelectedImageScrollView: View {
    private static let TrailingId = "trailing"

    @Binding var selectedImage: [Photo]
    @State var shouldScrollToTrail = false

    public init(selectedImage: Binding<[Photo]>) {
        _selectedImage = selectedImage
    }

    public var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(selectedImage) { image in
                        ThumbnailView(image: image) {
                            selectedImage.removeAll(where: { $0.id == image.id })
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
                        .id(Self.TrailingId)
                        .onChange(of: shouldScrollToTrail) {
                            withAnimation(.bouncy(extraBounce: 0.2)) {
                                reader.scrollTo(Self.TrailingId, anchor: .trailing)
                            }
                        }
                }
                .animation(
                    .bouncy(duration: 1).speed(2),
                    value: selectedImage
                )
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

import AppHelpers

#Preview {
    @Previewable @State var selectedImage: [Photo] = [.init(), .init(), .init(), .init()]

    VStack {
        Button {
            selectedImage.append(.init())
        } label: {
            Text("Add Image")
        }

        SelectedImageScrollView(
            selectedImage: $selectedImage
        )
    }
}

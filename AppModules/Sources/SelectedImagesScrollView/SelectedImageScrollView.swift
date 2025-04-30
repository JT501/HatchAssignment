// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

public struct SelectedImageScrollView: View {
    @Binding var selectedImage: [Color]

    public init(selectedImage: Binding<[Color]>) {
        _selectedImage = selectedImage
    }

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                ForEach(selectedImage, id: \.self) { image in
                    ThumbnailView(image: image) {
                        selectedImage.removeAll(where: { $0 == image })
                    }
                }
            }
        }
        .contentMargins(.leading, 8, for: .scrollContent)
    }
}

#Preview {
    @Previewable @State var selectedImage: [Color] = [.black, .red, .yellow, .green]

    SelectedImageScrollView(
        selectedImage: $selectedImage
    )
}

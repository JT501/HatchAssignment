// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct SelectedImageScrollView: View {
    @Binding var selectedImage: [Color]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                ForEach(selectedImage, id: \.self) { image in
                    ThumbnailView(image: image) {
                        selectedImage.removeAll(where: { $0 == image })
                    }
                }
            }
        }
    }
}

struct ThumbnailView: View {
    var image: Color
    var onDidTapDelete: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            image.frame(width: 50, height: 50)
                .cornerRadius(5)
                .padding(8)

            Image(systemName: "x.circle.fill")
                .frame(width: 15, height: 15)
                .padding(1)
                .background(
                    Circle().fill(.white)
                )
                .overlay(
                    Circle().stroke(.white, lineWidth: 2)
                )
                .shadow(radius: 1)
                .offset(y: 2)
                .onTapGesture {
                    onDidTapDelete?()
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

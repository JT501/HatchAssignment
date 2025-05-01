// Created for AppModules in 2025
// Using Swift 6.0

import SwiftUI
import AppModels

struct ThumbnailView: View {
    var image: Photo
    var onDidTapDelete: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            image.color.frame(width: 50, height: 50)
                .cornerRadius(5)

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
                .alignmentGuide(.top, computeValue: { $0.height / 2 })
                .alignmentGuide(.trailing, computeValue: { $0.width / 2 })
                .onTapGesture {
                    onDidTapDelete?()
                }
        }
    }
}

#Preview {
    ThumbnailView(
        image: .init(color: .yellow)
    )
}

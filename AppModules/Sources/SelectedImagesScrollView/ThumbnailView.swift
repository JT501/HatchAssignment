// Created for AppModules in 2025
// Using Swift 6.0

import AppModels
import SwiftUI

struct ThumbnailView: View {
    var image: Photo
    var onDidTapDelete: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            image.color.frame(width: 50, height: 50)
                .cornerRadius(5)

            Image(systemName: "x.circle.fill")
                .resizable()
                .font(.system(size: 16))
                .frame(width: 16, height: 16)
                .background(.black, in: .circle)
                .foregroundStyle(.white)
                .scaledToFit()
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

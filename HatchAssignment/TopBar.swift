// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct TopBar: View {
    var body: some View {
        HStack {
            Button {}
                label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .bold()
                        .tint(.black)
                        .padding(.horizontal)
                }

            Spacer()

            Text("Some Text")
                .bold()

            Spacer()

            Button {}
                label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .tint(.black)
                        .padding(.horizontal)
                }
                .hidden()
        }
    }
}

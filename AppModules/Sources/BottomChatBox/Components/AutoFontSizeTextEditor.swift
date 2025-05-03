// Created for HatchAssignment in 2025
// Using Swift 6.0

import Foundation
import SwiftUI

struct AutoFontSizeTextEditor: View {
    static var shrinkThreshold: CGFloat = 2.0 / 3.0
    static var growThreshold: CGFloat = 0.56

    enum FontSize: CGFloat, CaseIterable, Equatable {
        case `default` = 18
        case medium = 16
        case small = 14

        func decrease() -> FontSize {
            switch self {
                case .default:
                    .medium
                case .medium:
                    .small
                case .small:
                    .small
            }
        }

        func increase() -> FontSize {
            switch self {
                case .default:
                    .default
                case .medium:
                    .default
                case .small:
                    .medium
            }
        }
    }

    @Binding var text: String
    var placeHolder: String = "Start Typing..."
    @State var fontSize = FontSize.default
    var overrideFontSize = false
    @State var textEditorHeight = CGFloat.zero
    @State var textViewHeight = CGFloat.zero
    @FocusState var isTextFieldFocused
    
    var heightFactor: CGFloat {
        textViewHeight / textEditorHeight
    }
    
    private var displayFontSize: CGFloat {
        (overrideFontSize ? FontSize.default : fontSize).rawValue
    }
    
    private var showPlaceHolder: Bool {
        !isTextFieldFocused && text.isEmpty
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.system(size: displayFontSize))
                .padding(
                    EdgeInsets(
                        top: -7.8,
                        leading: -4.8,
                        bottom: 0,
                        trailing: -5
                    )
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .focused($isTextFieldFocused)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled()
                .scrollContentBackground(.hidden)
                .scrollDisabled(fontSize != .small)
                .scrollDismissesKeyboard(.interactively)
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { newValue in
                    textEditorHeight = newValue.height
                }

            // Dummy Textfield for calculating the space text occupied
            Text(text)
                .font(.system(size: fontSize.rawValue))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { newValue in
                    textViewHeight = newValue.height
                }
                .hidden()

            // Placeholder
            PlaceholderView(placeholder: placeHolder)
                .opacity(showPlaceHolder ? 1 : 0)
                .allowsHitTesting(false)
        }
        .animation(.smooth, value: showPlaceHolder)
        .task(id: heightFactor) {
            fontSize = updateFontSize(by: heightFactor, with: fontSize)
        }
    }

    func updateFontSize(by factor: CGFloat, with fontSize: FontSize) -> FontSize {
        if factor >= Self.shrinkThreshold {
            fontSize.decrease()
        } else if factor <= Self.growThreshold {
            fontSize.increase()
        } else {
            fontSize
        }
    }
}

#Preview {
    AutoFontSizeTextEditor(
        text: .constant(
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ut quam bibendum, blandit odio a, luctus sapien. Nullam sodales urna in est congue eleifend. Curabitur mattis enim in purus bibendum, et dapibus libero laoreet. Donec scelerisque facilisis elit at convallis. Integer congue sollicitudin ultrices. Vivamus a mattis nibh. Integer interdum sagittis mattis. Mauris dictum eros vel tincidunt fringilla. Proin urna erat, lobortis vitae enim a, fermentum gravida nulla. Ut congue lectus est, a viverra arcu tempor non. Aliquam molestie felis mi, sed aliquam metus euismod vel. Pellentesque lobortis sagittis ipsum lobortis vestibulum.

            Mauris posuere orci arcu, et posuere sem hendrerit vitae. Pellentesque id purus et magna eleifend consequat. Quisque tempus lectus metus, in pellentesque arcu iaculis sed. Sed dapibus neque sem, ac laoreet ipsum feugiat vitae. Pellentesque in bibendum nisi, eleifend ultrices libero. Aenean facilisis, odio quis pulvinar placerat, mauris dolor tristique sem, id pretium nibh arcu quis velit. Phasellus mollis porttitor lectus sit amet facilisis. Vestibulum vel odio ac nisi tincidunt sagittis. Nulla a sagittis mi, at consectetur mauris. Donec condimentum elementum nibh ac blandit. Ut mollis enim ipsum, non dapibus lectus accumsan in. Nam efficitur ex vel diam ornare posuere. Aliquam mattis felis neque, ut finibus nisl mattis facilisis. Morbi pretium venenatis consectetur. Pellentesque in tortor a magna viverra placerat. Donec auctor interdum sapien ut blandit.

            Aliquam molestie elit nulla, ac mollis arcu finibus a. Curabitur non nunc at enim vehicula finibus sed dapibus lacus. Donec vulputate ut nibh nec facilisis. Nam id erat quis velit tincidunt facilisis ut ut nibh. Sed vitae massa pellentesque, varius lectus ut, aliquam leo. Quisque et turpis accumsan, pretium ligula ac, rhoncus arcu. Donec commodo in quam ac lobortis. Phasellus nec malesuada est.

            Vestibulum et bibendum risus. Nullam eget gravida tortor. Proin ultricies interdum accumsan. Phasellus mattis ac nisi sed tempus. Morbi viverra turpis quis ligula eleifend condimentum. Vestibulum a accumsan lacus. Nam vel est vel lorem laoreet vestibulum non sit amet lacus. Nunc in condimentum lectus. Vivamus pulvinar accumsan magna, placerat rhoncus sapien hendrerit ac. Curabitur gravida velit sem.

            Nulla vestibulum semper sollicitudin. Mauris feugiat viverra nisl, sit amet porttitor ipsum dignissim nec. Vestibulum lorem purus, placerat ut lorem vitae, feugiat mollis lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed ac dignissim ligula. Morbi dictum accumsan felis non placerat. Vestibulum at congue leo. Praesent eget luctus magna. Aenean efficitur tempus augue et congue.

            Suspendisse id felis in lorem porta commodo. Morbi malesuada leo ac nibh fringilla, nec scelerisque arcu congue. Nam tempus elit eget bibendum vestibulum. Pellentesque ut lectus mauris. Phasellus sed eros blandit, facilisis enim at, dictum risus. Nam blandit magna vel velit pharetra pretium. Donec imperdiet aliquet elit nec sodales. Sed eu ullamcorper ipsum. Etiam venenatis facilisis metus. Quisque a lacus sit amet velit vulputate convallis. Phasellus vitae risus ipsum. Aliquam euismod nunc eu sapien vulputate, nec ultrices arcu pretium. Pellentesque ullamcorper finibus nulla, vitae porta dui bibendum non. Quisque eu sem sem. Donec a quam tincidunt, tempus eros ac, mattis arcu.
            """
        )
    )
    .containerRelativeFrame(.vertical) { h, _ in
        h * 0.35
    }
}

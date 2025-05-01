// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

public struct KeyboardAttachedView: UIViewControllerRepresentable {
    public var offset: Binding<CGFloat>

    public init(offset: Binding<CGFloat>) {
        self.offset = offset
    }

    public func makeUIViewController(
        context _: Context
    ) -> KeyboardObservingViewController {
        let viewController = KeyboardObservingViewController(offset: offset)
        return viewController
    }

    public func updateUIViewController(_: KeyboardObservingViewController, context _: Context) {}
}

public class KeyboardObservingViewController: UIViewController {
    var offset: Binding<CGFloat>
    var emptyView: UIView = .init()

    var keyboardAnimation: Animation = .easeOut(duration: 0.25)

    public init(offset: Binding<CGFloat>) {
        self.offset = offset
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(emptyView)
        view.keyboardLayoutGuide.usesBottomSafeArea = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let newOffset = emptyView.layer.position.y

        if abs(newOffset - offset.wrappedValue) > 100 {
            print("Offset:", newOffset)
            withAnimation(keyboardAnimation) {
                self.offset.wrappedValue = newOffset
            }
        } else {
            offset.wrappedValue = newOffset
        }
    }
}

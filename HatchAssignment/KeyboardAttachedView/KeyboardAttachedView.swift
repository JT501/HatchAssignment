// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

struct KeyboardAttachedView: UIViewControllerRepresentable {
    var offset: Binding<CGFloat>

    func makeUIViewController(
        context _: Context
    ) -> KeyboardObservingViewController {
        let viewController = KeyboardObservingViewController(offset: offset)
        return viewController
    }

    func updateUIViewController(_: KeyboardObservingViewController, context _: Context) {}
}

class KeyboardObservingViewController: UIViewController {
    var offset: Binding<CGFloat>
    var emptyView: UIView = .init()

    var keyboardAnimation: Animation = .easeOut(duration: 0.25)

    init(offset: Binding<CGFloat>) {
        self.offset = offset
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(emptyView)
        view.keyboardLayoutGuide.usesBottomSafeArea = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let newOffset = emptyView.layer.position.y

        if abs(newOffset - offset.wrappedValue) > 100 {
            withAnimation(keyboardAnimation) {
                self.offset.wrappedValue = newOffset
            }
        } else {
            offset.wrappedValue = newOffset
        }
    }
}

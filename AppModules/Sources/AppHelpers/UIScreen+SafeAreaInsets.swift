// Created for HatchAssignment in 2025
// Using Swift 6.0

import SwiftUI

@MainActor
public extension UIApplication {
    var newKeyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

@MainActor
public struct SafeAreaInsetsKey: @preconcurrency EnvironmentKey {
    public static var defaultValue: EdgeInsets {
        UIApplication.shared.newKeyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

public extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

public extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let targets: [Target] = [
    .target(
        name: "AppModules",
        dependencies: [
            .textChipScrollView,
            .sheetLikeEffectView,
            .photoPickerView,
            .selectedImagesScrollView,
            .keyboardAttachedView,
            .bottomChatBox,
        ]
    ),
    .target(
        name: "AppColors",
        resources: [
            .process("Resources")
        ]
    ),
    .target(name: "AppHelpers"),
    .target(
        name: "AppModels",
        dependencies: [.appHelpers]
    ),
    .target(
        name: "TextChipScrollView",
        dependencies: [
            .appColors,
            .appModels
        ]
    ),
    .target(
        name: "SheetLikeEffectView",
        dependencies: [.appHelpers]
    ),
    .target(
        name: "PhotoPickerView",
        dependencies: [
            .appModels,
            .appHelpers,
            .introspect,
        ]
    ),
    .target(
        name: "SelectedImagesScrollView",
        dependencies: [
            .appModels,
            .appHelpers,
        ]
    ),
    .target(name: "KeyboardAttachedView"),
    .target(
        name: "BottomChatBox",
        dependencies: [
            .appModels,
            .appColors,
            .photoPickerView,
            .selectedImagesScrollView,
        ]
    ),
]

let package = Package(
    name: "AppModules",
    platforms: [.iOS(.v17)],
    products: [
        .library("AppModules"),
        .library("AppColors"),
        .library("AppHelpers"),
        .library("AppModels"),
        .library("TextChipScrollView"),
        .library("SheetLikeEffectView"),
        .library("PhotoPickerView"),
        .library("SelectedImagesScrollView"),
        .library("KeyboardAttachedView"),
        .library("BottomChatBox"),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", .upToNextMajor(from: "1.3.0")),
    ],
    targets: targets
)

extension Target.Dependency {
    // MARK: App Modules

    static var appColors: Self { .target(name: "AppColors") }
    static var appHelpers: Self { .target(name: "AppHelpers") }
    static var appModels: Self { .target(name: "AppModels") }
    static var textChipScrollView: Self { .target(name: "TextChipScrollView") }
    static var sheetLikeEffectView: Self { .target(name: "SheetLikeEffectView") }
    static var photoPickerView: Self { .target(name: "PhotoPickerView") }
    static var selectedImagesScrollView: Self { .target(name: "SelectedImagesScrollView") }
    static var keyboardAttachedView: Self { .target(name: "KeyboardAttachedView") }
    static var bottomChatBox: Self { .target(name: "BottomChatBox") }

    // MARK: Third Party Dependencies

    static var introspect: Self { .product(name: "SwiftUIIntrospect", package: "swiftui-introspect") }
}

// MARK: Helper

extension Product {
    static func library(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}

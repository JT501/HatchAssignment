// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let targets: [Target] = [
    .target(
        name: "AppModules",
        dependencies: [
            .appConstants,
            .appHelpers,
        ]
    ),
    .target(name: "AppConstants"),
    .target(name: "AppHelpers"),
]

let package = Package(
    name: "AppModules",
    platforms: [.iOS(.v17)],
    products: [
        .library("AppModules"),
        .library("AppConstants"),
        .library("AppHelpers"),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", .upToNextMajor(from: "1.3.0")),
    ],
    targets: targets
)

extension Target.Dependency {
    // MARK: App Modules

    static var appConstants: Self { .target(name: "AppConstants") }
    static var appHelpers: Self { .target(name: "AppHelpers") }

    // MARK: Third Party Dependencies

    static var introspect: Self { .product(name: "SwiftUIIntrospect", package: "swiftui-introspect") }
}

// MARK: Helper

extension Product {
    static func library(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}

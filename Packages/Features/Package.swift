// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureCatalog", targets: ["FeatureCatalog"]),
        .library(name: "FeatureForms", targets: ["FeatureForms"]),
        .library(name: "FeatureLists", targets: ["FeatureLists"]),
        .library(name: "FeatureNavigation", targets: ["FeatureNavigation"]),
        .library(name: "FeatureTextRich", targets: ["FeatureTextRich"]),
        .library(name: "FeatureAnimations", targets: ["FeatureAnimations"]),
        .library(name: "FeatureGesturesDnD", targets: ["FeatureGesturesDnD"]),
        .library(name: "FeatureCharts", targets: ["FeatureCharts"]),
        .library(name: "FeatureImagesDrawing", targets: ["FeatureImagesDrawing"]),
        .library(name: "FeatureSwiftData", targets: ["FeatureSwiftData"]),
        .library(name: "FeatureNetworking", targets: ["FeatureNetworking"]),
        .library(name: "FeatureWidgets", targets: ["FeatureWidgets"]),
        .library(name: "FeatureUIKitInterop", targets: ["FeatureUIKitInterop"]),
        .library(name: "FeatureMapsStatic", targets: ["FeatureMapsStatic"])
    ],
    dependencies: [
        .package(path: "../AppCore"),
        .package(path: "../DesignSystem"),
        .package(path: "../DataLayer")
    ],
    targets: [
        .target(name: "FeatureCatalog", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureCatalog"),
        .target(name: "FeatureForms", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureForms"),
        .target(name: "FeatureLists", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureLists"),
        .target(name: "FeatureNavigation", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureNavigation"),
        .target(name: "FeatureTextRich", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureTextRich"),
        .target(name: "FeatureAnimations", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureAnimations"),
        .target(name: "FeatureGesturesDnD", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureGesturesDnD"),
        .target(name: "FeatureCharts", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureCharts"),
        .target(name: "FeatureImagesDrawing", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureImagesDrawing"),
        .target(name: "FeatureSwiftData", dependencies: ["AppCore", "DesignSystem", "DataLayer"], path: "Sources/FeatureSwiftData"),
        .target(name: "FeatureNetworking", dependencies: ["AppCore", "DesignSystem", "DataLayer"], path: "Sources/FeatureNetworking"),
        .target(name: "FeatureWidgets", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureWidgets"),
        .target(name: "FeatureUIKitInterop", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureUIKitInterop"),
        .target(name: "FeatureMapsStatic", dependencies: ["AppCore", "DesignSystem"], path: "Sources/FeatureMapsStatic")
    ]
)

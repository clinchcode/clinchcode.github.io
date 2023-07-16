// swift-tools-version:5.8
import PackageDescription
let package = Package(
    name: "ClotGuideSwift",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .executable(name: "ClotGuideSwift", targets: ["ClotGuideSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/TokamakUI/Tokamak", from: "0.11.0")
    ],
    targets: [
        .executableTarget(
            name: "ClotGuideSwift",
            dependencies: [
                "ClotGuideSwiftLibrary",
                .product(name: "TokamakShim", package: "Tokamak")
            ]),
        .target(
            name: "ClotGuideSwiftLibrary",
            dependencies: []),
        .testTarget(
            name: "ClotGuideSwiftLibraryTests",
            dependencies: ["ClotGuideSwiftLibrary"]),
    ]
)
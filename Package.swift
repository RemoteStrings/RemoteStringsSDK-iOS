// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RemoteStringsSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RemoteStringsSDK",
            targets: ["RemoteStringsSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "RemoteStringsSDK",
            path: "./RemoteStringsSDK.xcframework"
        )
    ]
)

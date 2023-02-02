// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minds-sdk-mobile-ios",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "MindsSDK",
            targets: ["MindsSDK"]),
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "3.4.1")),
        .package(name: "SwiftOGG", url: "https://github.com/vector-im/swift-ogg", .revision("e9a9e7601da662fd8b97d93781ff5c60b4becf88"))
    ],
    targets: [
        .target(
            name: "MindsSDK",
            dependencies: ["Alamofire", "SwiftOGG", "Lottie"],
            resources: [
                .process("resources")
            ]),
    ]
)

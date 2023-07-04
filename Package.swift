// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minds-sdk-mobile-ios",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "MindsSDK",
            targets: ["MindsSDK"]),
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "3.4.1")),
        //.package(name: "SwiftOGG", url: "https://github.com/mindsdigital/swift-ogg", .branch("main")),
        .package(name: "Sentry", url: "https://github.com/getsentry/sentry-cocoa", from: "8.7.0"),
        .package(
                 name: "YbridOpus",
                 url: "https://github.com/vector-im/opus-swift",
                 from: "0.8.4"),
             .package(
                 name: "YbridOgg",
                 url: "https://github.com/vector-im/ogg-swift.git",
                 from: "0.8.3")
    ],
    targets: [
        .target(name: "Copustools", path: "Sources/SupportingFiles/Dependencies/Copustools"),
        .target(name: "SwiftOGG", dependencies: ["YbridOpus", "YbridOgg", "Copustools"], path: "Sources/SwiftOGG"),
        .target(
            name: "MindsSDK",
            dependencies: ["Alamofire", "SwiftOGG", "Lottie", "Sentry"],
            resources: [
                .process("resources")
            ]),
    ]
)

// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minds-sdk-mobile-ios",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "minds-sdk-mobile-ios",
            targets: ["minds-sdk-mobile-ios"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "3.4.1")),
        .package(name: "SwiftOGG", url: "https://github.com/vector-im/swift-ogg", .commit("e9a9e7601da662fd8b97d93781ff5c60b4becf88"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "minds-sdk-mobile-ios",
            dependencies: ["Alamofire", "SwiftOGG", "Lottie"],
            resources: [
                .process("resources")
            ]),
    ]
)

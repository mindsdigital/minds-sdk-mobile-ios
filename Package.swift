// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minds-sdk-mobile-ios",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "MindsSDK",
            targets: ["MindsSDK"]),
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "3.4.1")),
        .package(name: "Sentry", url: "https://github.com/getsentry/sentry-cocoa", from: "8.7.0"),
    ],
    targets: [
        .target(
            name: "MindsSDK",
            dependencies: ["Alamofire", "Lottie", "Sentry", "FFmpegKit", "Libavcodec", "Libavdevice", "Libavfilter","Libavformat", "Libavutil", "Libswresample", "Libswscale"],
            resources: [
                .process("resources")
            ]),
        .binaryTarget(
                        name: "FFmpegKit",
                        path: "Sources/Frameworks/ffmpegkit.xcframework"
                    ),
             .binaryTarget(
                        name: "Libavcodec",
                        path: "Sources/Frameworks/libavcodec.xcframework"
                    ),
             .binaryTarget(
                        name: "Libavdevice",
                        path: "Sources/Frameworks/libavdevice.xcframework"
                    ),
             .binaryTarget(
                        name: "Libavfilter",
                        path: "Sources/Frameworks/libavfilter.xcframework"
                    ),
             .binaryTarget(
                        name: "Libavformat",
                        path: "Sources/Frameworks/libavformat.xcframework"
                    ),
             .binaryTarget(
                        name: "Libavutil",
                        path: "Sources/Frameworks/libavutil.xcframework"
                    ),
             .binaryTarget(
                        name: "Libswresample",
                        path: "Sources/Frameworks/libswresample.xcframework"
                    ),
             .binaryTarget(
                        name: "Libswscale",
                        path: "Sources/Frameworks/libswscale.xcframework"
                    ),
        
    ]
)

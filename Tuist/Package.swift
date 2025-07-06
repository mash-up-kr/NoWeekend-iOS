// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "GoogleSignIn": .framework,
        "GTMAppAuth": .framework,
        "GTMSessionFetcher": .framework,
        "GTMSessionFetcherCore": .framework,
        "AppCheckCore": .framework,
        "Swinject": .framework
    ]
)
#endif

let package = Package(
    name: "NoWeekend",
    dependencies: [
         .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.2"),
         .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0"),
         .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
         .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0")
    ]
)

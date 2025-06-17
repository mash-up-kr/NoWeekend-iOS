// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "NoWeekend",
    dependencies: [
         .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.2"),
         .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0")
    ]
)

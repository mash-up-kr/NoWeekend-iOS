//
//  InfoPlist+extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 김시종 on 6/16/25.
//

import ProjectDescription

public extension InfoPlist {
    static func app(
        displayName: String,
        version: String = Environment.App.version,
        buildNumber: String = Environment.App.buildNumber
    ) -> InfoPlist {
        .extendingDefault(with: [
            "CFBundleDisplayName": .string(displayName),
            "CFBundleShortVersionString": .string(version),
            "CFBundleVersion": .string(buildNumber),
            "UILaunchStoryboardName": "LaunchScreen",
            "UISupportedInterfaceOrientations": .array([
                .string("UIInterfaceOrientationPortrait")
            ]),
            "UIUserInterfaceStyle": .string("Automatic"),
            "ITSAppUsesNonExemptEncryption": .boolean(false),
            "NSAppTransportSecurity": .dictionary([
                "NSAllowsArbitraryLoads": .boolean(false)
            ])
        ])
    }
    
    static let framework: InfoPlist = .extendingDefault(with: [
        "CFBundlePackageType": "FMWK"
    ])
    
    static func test(hostApp: String? = nil) -> InfoPlist {
        var plist: [String: Plist.Value] = [
            "CFBundlePackageType": "BNDL"
        ]
        
        if let hostApp = hostApp {
            plist["TEST_HOST"] = "$(BUILT_PRODUCTS_DIR)/\(hostApp).app/\(hostApp)"
        }
        
        return .extendingDefault(with: plist)
    }
}

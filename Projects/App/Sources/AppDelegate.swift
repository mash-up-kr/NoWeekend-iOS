//
//  AppDelegate.swift
//  App
//
//  Created by 김시종 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import GoogleSignIn
import LoginDomain
import NWNetwork
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        configureGoogleSignIn()
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: - Private Methods
    private func configureGoogleSignIn() {
        print("🔐 Google Sign-In 설정 시작")
        
        let clientID = GoogleConfig.clientID
        print("📋 Google Client ID: \(clientID)")
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        print("   - Client ID: \(GoogleConfig.clientID)")
        print("   - Server Client ID: \(GoogleConfig.serverClientID)")
    }
}

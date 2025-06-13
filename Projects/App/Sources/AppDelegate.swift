//
//  AppDelegate.swift
//  App
//
//  Created by SiJongKim on 6/12/25.
//

import UIKit
import Login

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        LoginConfiguration.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return LoginConfiguration.handleOpenURL(url)
    }
}
 

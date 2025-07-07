//
//  GoogleConfig.swift
//  LoginDomain
//
//  Created by 김시종 on 7/6/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct GoogleConfig {
    public static var clientID: String {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            fatalError("Google Client ID not found in Info.plist")
        }
        return clientID
    }
    
    public static var serverClientID: String {
        guard let serverClientID = Bundle.main.object(forInfoDictionaryKey: "GIDServerClientID") as? String else {
            fatalError("Google Server Client ID not found in Info.plist")
        }
        return serverClientID
    }
}

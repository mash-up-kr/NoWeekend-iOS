//
//  GoogleConfig.swift
//  Common
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation

public struct GoogleConfig {
    public static var clientID: String {
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String else {
            fatalError("Google Clinet ID not found in Info.plist")
        }
        return clientID
    }
    
    public static var serverClientID: String {
        guard let serverClientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_SERVER_CLIENT_ID") as? String else {
            fatalError("Google Server Client ID not found in Info.plist")
        }
        return serverClientID
    }
}

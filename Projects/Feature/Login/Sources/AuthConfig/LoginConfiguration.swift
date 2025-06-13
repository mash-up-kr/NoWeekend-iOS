//
//  LoginConfiguration.swift
//  Calendar
//
//  Created by SiJongKim on 6/12/25.
//

import Foundation
import GoogleSignIn
import Common

public final class LoginConfiguration {
    public static func configure() {
        let config = GIDConfiguration(
            clientID: GoogleConfig.clientID,
            serverClientID: GoogleConfig.serverClientID
        )
        GIDSignIn.sharedInstance.configuration = config
    }
    
    public static func handleOpenURL(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

//
//  GoogleSignInConfiguration.swift
//  ThirdParty
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import GoogleSignIn
import Common

public final class GoogleSignInConfiguration {
    public static func configure() {
        let config = GIDConfiguration(
            clientID: GoogleConfig.clientID,
            serverClientID: GoogleConfig.serverClientID
        )
        GIDSignIn.sharedInstance.configuration = config
    }
}

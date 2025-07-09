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
        return Config.googleClientID
    }
    
    public static var serverClientID: String {
        return Config.googleServerClientID
    }
}

//
//  AuthRepositoryInterface.swift
//  CalendarInterface
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain

public protocol AuthRepositoryInterface {
    func loginWithGoogle(accessToken: String, name: String?) async throws -> LoginUser
    func loginWithApple(identityToken: String, name: String?) async throws -> LoginUser
}


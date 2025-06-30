//
//  AuthRepositoryInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import Domain

public protocol AuthRepositoryInterface {
    func loginWithGoogle(authorizationCode: String, name: String?) async throws -> LoginUser
    func loginWithApple(identityToken: String, authorizationCode: String?, email: String?, name: String?) async throws -> LoginUser
}


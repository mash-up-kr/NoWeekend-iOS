//
//  AuthRepositoryInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation

public protocol AuthRepositoryInterface {
    func loginWithGoogle(authorizationCode: String, name: String?) async throws -> LoginUser
    
    func loginWithApple(authorizationCode: String, name: String?) async throws -> LoginUser
    
    func withdrawAppleAccount(identityToken: String) async throws
}

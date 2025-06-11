//
//  AuthRepositoryInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import Domain

public protocol AuthRepositoryInterface {
    func loginWithGoogle(accessToken: String, name: String?) async throws -> LoginEntity
}

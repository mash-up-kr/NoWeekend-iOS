//
//  GoogleAuthServiceInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import Domain

public protocol GoogleAuthServiceInterface {
    func signIn() async throws -> (accessToken: String, name: String?, email: String?)
    func signOut()
}


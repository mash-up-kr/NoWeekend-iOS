//
//  GoogleAuthServiceInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import UIKit
import Domain

public protocol GoogleAuthServiceInterface {
    func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult
    func signOut()
}


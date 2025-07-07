//
//  GoogleAuthServiceInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import UIKit

public protocol GoogleAuthServiceInterface {
    @MainActor
    func signIn(presentingViewController: UIViewController) async throws -> GoogleSignInResult
    
    @MainActor
    func signOut()
}

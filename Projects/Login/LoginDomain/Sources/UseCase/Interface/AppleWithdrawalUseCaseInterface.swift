//
//  AppleWithdrawalUseCaseInterface.swift
//  LoginDomain
//
//  Created by SiJongKim on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol AppleWithdrawalUseCaseInterface {
    @MainActor
    func execute() async throws
}

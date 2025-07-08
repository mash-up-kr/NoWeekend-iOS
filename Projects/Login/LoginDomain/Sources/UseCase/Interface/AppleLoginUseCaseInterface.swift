//
//  AppleLoginUseCaseInterface.swift
//  Domain
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol AppleLoginUseCaseInterface {
    func execute() async throws -> LoginUser
}

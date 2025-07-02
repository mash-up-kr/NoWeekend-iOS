//
//  OnboardingNetworkDataSourceInterface.swift
//  Domain
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain

public protocol OnboardingDataSourceInterface {
    func saveProfile(_ dto: ProfileRequestDTO) async throws -> OnboardingResponseDTO
    func saveLeave(_ dto: LeaveRequestDTO) async throws -> OnboardingResponseDTO
    func saveTags(_ dto: TagRequestDTO) async throws -> OnboardingResponseDTO
}

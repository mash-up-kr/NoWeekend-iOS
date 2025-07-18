//
//  ProfileNetworkServiceInterface.swift
//  ProfileData
//
//  Created by SiJongKim on 7/11/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import ProfileDomain

public protocol ProfileNetworkServiceInterface {
    func getUserProfile() async throws -> UserProfileDTO
    func updateUserProfile(_ request: UserProfileUpdateRequestDTO) async throws -> UserProfileDTO
    func getUserTags() async throws -> UserTagsResponseDTO
    func updateUserTags(_ request: UserTagsUpdateRequestDTO) async throws -> UserTagsResponseDTO
    func updateVacationLeave(_ request: VacationLeaveDTO) async throws -> VacationLeaveDTO
    func getAITagRecommendation(selectedTags: [String]) async throws -> AIRecommendationResponse
}


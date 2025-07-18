//
//  OnboardingNetworkService.swift
//  OnboardingData
//
//  Created by SiJongKim on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import NWNetwork
import OnboardingDomain

public class OnboardingNetworkService: OnboardingNetworkServiceInterface {
    private let networkService: NWNetworkServiceProtocol
    
    public init(networkService: NWNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Profile 저장 (Domain Model → DTO 변환)
    
    public func saveProfile(_ profile: OnboardingProfile) async throws {
        let dto = ProfileRequestDTO(
            nickname: profile.nickname,
            birthDate: profile.birthDate
        )
        
        let endpoint = OnboardingEndpoint.profile
        
        print("🌐 API Request: \(endpoint.method) \(endpoint.path)")
        print("📤 Profile DTO: \(dto.toDictionary)")
        
        let response: OnboardingResponseDTO = try await networkService.post(
            endpoint: endpoint.path,
            parameters: dto.toDictionary
        )
        
        guard response.isSuccess else {
            let errorMessage = response.error?.message ?? response.data
            throw OnboardingError.tagsSaveFailed(errorMessage)
        }
        
        print("✅ Profile API call successful")
    }
    
    public func saveLeave(_ leave: OnboardingLeave) async throws {
        let dto = LeaveRequestDTO(
            days: leave.days,
            hours: leave.hours
        )
        
        let endpoint = OnboardingEndpoint.leave
        
        print("🌐 API Request: \(endpoint.method) \(endpoint.path)")
        print("📤 Leave DTO: \(dto.toDictionary)")
        
        let response: OnboardingResponseDTO = try await networkService.post(
            endpoint: endpoint.path,
            parameters: dto.toDictionary
        )
        
        guard response.isSuccess else {
            let errorMessage = response.error?.message ?? response.data
            throw OnboardingError.tagsSaveFailed(errorMessage)
        }
        
        print("✅ Leave API call successful")
    }
    
    // MARK: - Tags 저장 (Domain Model → DTO 변환)
    
    public func saveTags(_ tags: OnboardingTags) async throws {
        let dto = TagRequestDTO(
            scheduleTags: tags.scheduleTags
        )
        
        let endpoint = OnboardingEndpoint.tag
        
        print("🌐 API Request: \(endpoint.method) \(endpoint.path)")
        print("📤 Tags DTO: \(dto.toDictionary)")
        
        let response: OnboardingResponseDTO = try await networkService.post(
            endpoint: endpoint.path,
            parameters: dto.toDictionary
        )
        
        guard response.isSuccess else {
            let errorMessage = response.error?.message ?? response.data
            throw OnboardingError.tagsSaveFailed(errorMessage)
        }
        
        print("✅ Tags API call successful")
    }
    
    public func fetchOnboardingStatus() async throws -> String {
        let endpoint = OnboardingEndpoint.status
        let response: OnboardingStatusResponseDTO = try await networkService.get(
            endpoint: endpoint.path,
            parameters: nil
        )
        let status = response.data.status
        if status.isEmpty {
            throw OnboardingError.networkError("온보딩 상태값이 없습니다")
        }
        return status
    }
}


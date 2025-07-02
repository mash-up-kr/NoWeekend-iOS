//
//  OnboardingRepository.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain
import RepositoryInterface
import NetworkInterface

public class OnboardingRepository: OnboardingRepositoryInterface {
    
    private let dataSource: OnboardingDataSourceInterface
    
    public init(dataSource: OnboardingDataSourceInterface) {
        self.dataSource = dataSource
    }
    
    // MARK: - Profile 저장
    
    public func saveProfile(_ profile: OnboardingProfile) async throws {
        let dto = ProfileRequestDTO(
            nickname: profile.nickname,
            birthDate: profile.birthDate
        )
        
        let response = try await dataSource.saveProfile(dto)
        
        guard response.success else {
            throw OnboardingError.profileSaveFailed(response.message ?? "프로필 저장 실패")
        }
        
        print("✅ Profile saved successfully: \(profile.nickname)")
    }
    
    // MARK: - Leave 저장
    
    public func saveLeave(_ leave: OnboardingLeave) async throws {
        let dto = LeaveRequestDTO(
            days: leave.days,
            hours: leave.hours
        )
        
        let response = try await dataSource.saveLeave(dto)
        
        guard response.success else {
            throw OnboardingError.leaveSaveFailed(response.message ?? "연차 정보 저장 실패")
        }
        
        print("✅ Leave saved successfully: \(leave.days)일 \(leave.hours)시간")
    }
    
    // MARK: - Tags 저장
    
    public func saveTags(_ tags: OnboardingTags) async throws {
        let dto = TagRequestDTO(
            scheduleTags: tags.scheduleTags
        )
        
        let response = try await dataSource.saveTags(dto)
        
        guard response.success else {
            throw OnboardingError.tagsSaveFailed(response.message ?? "태그 저장 실패")
        }
        
        print("✅ Tags saved successfully: \(tags.scheduleTags)")
    }
}


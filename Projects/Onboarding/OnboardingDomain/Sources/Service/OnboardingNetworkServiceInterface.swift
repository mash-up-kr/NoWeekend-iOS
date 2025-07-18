//
//  OnboardingNetworkServiceInterface.swift
//  OnboardingDomain
//
//  Created by SiJongKim on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol OnboardingNetworkServiceInterface {
    func saveProfile(_ profile: OnboardingProfile) async throws
    func saveLeave(_ leave: OnboardingLeave) async throws
    func saveTags(_ tags: OnboardingTags) async throws
    func fetchOnboardingStatus() async throws -> String
}

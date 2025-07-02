//
//  OnboardingRepositoryInterface.swift
//  CalendarInterface
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain

public protocol OnboardingRepositoryInterface {
    func saveProfile(_ profile: OnboardingProfile) async throws
    func saveLeave(_ leave: OnboardingLeave) async throws
    func saveTags(_ tags: OnboardingTags) async throws
}

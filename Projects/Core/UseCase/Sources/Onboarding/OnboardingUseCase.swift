//
//  OnboardingUseCase.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import RepositoryInterface
import Domain


public class SaveProfileUseCase: SaveProfileUseCaseInterface {
    private let repository: OnboardingRepositoryInterface
    
    public init(repository: OnboardingRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(nickname: String, birthDate: String) async throws {
        let profile = OnboardingProfile(nickname: nickname, birthDate: birthDate)
        try await repository.saveProfile(profile)
    }
}

public class SaveLeaveUseCase: SaveLeaveUseCaseInterface {
    private let repository: OnboardingRepositoryInterface
    
    public init(repository: OnboardingRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(days: Int, hours: Int) async throws {
        let leave = OnboardingLeave(days: days, hours: hours)
        try await repository.saveLeave(leave)
    }
}

public class SaveTagsUseCase: SaveTagsUseCaseInterface {
    private let repository: OnboardingRepositoryInterface
    
    public init(repository: OnboardingRepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(tags: [String]) async throws {
        let tagModel = OnboardingTags(scheduleTags: tags)
        try await repository.saveTags(tagModel)
    }
}

public class ValidateNicknameUseCase: ValidateNicknameUseCaseInterface {
    public init() {}
    
    public func execute(_ nickname: String) -> ValidationResult {
        if nickname.isEmpty {
            return .invalid("닉네임을 입력해주세요")
        } else if nickname.count > 6 {
            return .invalid("6글자까지 작성할 수 있어요.")
        } else if nickname.trimmingCharacters(in: .whitespaces).isEmpty {
            return .invalid("유효한 닉네임을 입력해주세요")
        } else {
            return .valid
        }
    }
}

public class ValidateBirthDateUseCase: ValidateBirthDateUseCaseInterface {
    public init() {}
    
    public func execute(_ birthDate: String) -> ValidationResult {
        if birthDate.isEmpty {
            return .invalid("생년월일을 입력해주세요")
        } else if birthDate.count != 8 {
            return .invalid("생년월일은 8자리로 입력해주세요")
        } else if birthDate.filter({ !$0.isNumber }).count > 0 {
            return .invalid("유효한 생년월일을 입력해주세요")
        } else {
            return .valid
        }
    }
}

public class ValidateRemainingDaysUseCase: ValidateRemainingDaysUseCaseInterface {
    public init() {}
    
    public func execute(_ days: String) -> ValidationResult {
        if days.isEmpty {
            return .valid
        }
        guard let _ = Int(days) else {
            return .invalid("올바른 숫자를 입력해주세요")
        }
        return .valid
    }
}

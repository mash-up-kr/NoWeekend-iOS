//
//  ProfileFeatureAssembly.swift
//  ProfileFeature
//
//  Created by SijongKim on 7/4/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DIContainer
import Foundation
import NWNetwork
import ProfileData
import ProfileDomain
import Swinject

public struct ProfileFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🔧 ProfileFeatureAssembly 등록 시작")
        
        // MARK: - Infrastructure Layer
        container.register(NWNetworkServiceProtocol.self) { _ in
            let token = UserDefaults.standard.string(forKey: "access_token")
            return NWNetworkService(authToken: token)
        }
        .inObjectScope(.container)
        
        container.register(ProfileNetworkServiceInterface.self) { resolver in
            let baseNetworkService = resolver.resolve(NWNetworkServiceProtocol.self)!
            return ProfileNetworkService(networkService: baseNetworkService)
        }.inObjectScope(.container)
        
        container.register(ProfileRepositoryInterface.self) { resolver in
            let profileNetworkService = resolver.resolve(ProfileNetworkServiceInterface.self)!
            return ProfileRepository(networkService: profileNetworkService)
        }.inObjectScope(.container)
        
        // MARK: - Domain Layer (Use Cases)
        container.register(GetUserProfileUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryInterface.self)!
            return GetUserProfileUseCase(repository: repository)
        }.inObjectScope(.graph)
        
        container.register(UpdateUserProfileUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryInterface.self)!
            return UpdateUserProfileUseCase(repository: repository)
        }.inObjectScope(.graph)
        
        container.register(GetUserTagsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryInterface.self)!
            return GetUserTagsUseCase(repository: repository)
        }.inObjectScope(.graph)
        
        container.register(UpdateUserTagsUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryInterface.self)!
            return UpdateUserTagsUseCase(repository: repository)
        }.inObjectScope(.graph)
        
        container.register(UpdateVacationLeaveUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(ProfileRepositoryInterface.self)!
            return UpdateVacationLeaveUseCase(repository: repository)
        }.inObjectScope(.graph)
        
        container.register(ProfileStore.self) { resolver in
            let getUserProfileUseCase = resolver.resolve(GetUserProfileUseCaseProtocol.self)!
            return ProfileStore(getUserProfileUseCase: getUserProfileUseCase)
        }.inObjectScope(.container)
        
        container.register(ProfileEditStore.self) { resolver in
            let updateUserProfileUseCase = resolver.resolve(UpdateUserProfileUseCaseProtocol.self)!
            let profileStore = resolver.resolve(ProfileStore.self)!
            
            return ProfileEditStore(
                updateUserProfileUseCase: updateUserProfileUseCase,
                profileStore: profileStore
            )
        }.inObjectScope(.graph)
        
        container.register(VacationStore.self) { resolver in
            let updateVacationLeaveUseCase = resolver.resolve(UpdateVacationLeaveUseCaseProtocol.self)!
            return VacationStore(updateVacationLeaveUseCase: updateVacationLeaveUseCase)
        }.inObjectScope(.graph)
        
        container.register(TagsStore.self) { resolver in
            let getUserTagsUseCase = resolver.resolve(GetUserTagsUseCaseProtocol.self)!
            let updateUserTagsUseCase = resolver.resolve(UpdateUserTagsUseCaseProtocol.self)!
            
            return TagsStore(
                getUserTagsUseCase: getUserTagsUseCase,
                updateUserTagsUseCase: updateUserTagsUseCase
            )
        }.inObjectScope(.graph)
        
        print("✅ ProfileFeatureAssembly 등록 완료")
    }
}

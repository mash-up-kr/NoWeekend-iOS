//
//  LoginDataModule.swift
//  LoginData
//
//  Created by SiJongKim on 7/7/25.
//

import Foundation
import DIContainer
import LoginDomain
import NWNetwork

public enum LoginDataModule {
    public static func registerRepositories() {
        print("🔐 LoginData Repository 등록")
        
        DIContainer.shared.container.register(NWNetworkServiceProtocol.self) { _ in
            return NWNetworkService()
        }.inObjectScope(.container)
        
        DIContainer.shared.container.register(AuthRepositoryInterface.self) { resolver in
            let networkService = resolver.resolve(NWNetworkServiceProtocol.self)!
            return AuthRepositoryImpl(networkService: networkService)
        }.inObjectScope(.container)
        
        DIContainer.shared.container.register(AppleAuthServiceInterface.self) { _ in
            return MainActor.assumeIsolated {
                AppleAuthService()
            }
        }.inObjectScope(.graph)
        
        DIContainer.shared.container.register(GoogleAuthServiceInterface.self) { _ in
            return GoogleAuthService()
        }.inObjectScope(.graph)
        
        print("✅ LoginData Repository 등록 완료")
    }
}

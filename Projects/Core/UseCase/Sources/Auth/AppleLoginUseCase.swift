//
//  AppleLoginUseCase.swift
//  Repository
//
//  Created by SiJongKim on 6/30/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain
import RepositoryInterface
import ServiceInterface
import LoginInterface
import NetworkInterface

@MainActor
public final class AppleLoginUseCase: AppleLoginUseCaseInterface {
    private let authRepository: AuthRepositoryInterface
    private let appleAuthService: AppleAuthServiceInterface
    
    public init(
        authRepository: AuthRepositoryInterface,
        appleAuthService: AppleAuthServiceInterface
    ) {
        self.authRepository = authRepository
        self.appleAuthService = appleAuthService
    }
    
    public func execute() async throws -> LoginUser {
        print("🍎 Apple UseCase 시작")
        
        let signInResult = try await appleAuthService.signIn()
        
        print("🔍 Apple SignIn 결과:")
        print("  - User ID: \(signInResult.userIdentifier)")
        print("  - Email: \(signInResult.email ?? "nil")")
        print("  - Authorization Code 유무: \(signInResult.authorizationCode != nil)")
        
        // 이름 조합
        let fullName = [
            signInResult.fullName?.givenName,
            signInResult.fullName?.familyName
        ].compactMap { $0 }.joined(separator: " ")
        
        let nameToSend = fullName.isEmpty ? nil : fullName
        
        print("🔍 서버 전송 데이터:")
        print("  - Authorization Code: \(signInResult.authorizationCode != nil ? "있음" : "없음")")
        print("  - Name: \(nameToSend ?? "nil")")
        print("  - Email: \(signInResult.email ?? "nil")")
        
        do {
            let user = try await authRepository.loginWithApple(
                identityToken: "",
                authorizationCode: signInResult.authorizationCode,
                email: signInResult.email,
                name: nameToSend
            )
            
            print("🎉 Apple 로그인 성공: \(user.email)")
            return user
            
        } catch {
            print("❌ Apple 로그인 실패: \(error)")
            
            // 회원가입 시도 (이름이 있는 경우만)
            if isUnauthorizedError(error) {
                print("🔄 회원가입 시도...")
                
                guard let name = nameToSend, !name.isEmpty else {
                    print("❌ 회원가입을 위한 이름이 필요합니다")
                    throw LoginError.nameNotAvailable
                }
                
                let user = try await authRepository.loginWithApple(
                    identityToken: "",
                    authorizationCode: signInResult.authorizationCode,
                    email: signInResult.email,
                    name: name
                )
                
                print("🎉 Apple 회원가입 성공: \(user.email)")
                return user
            } else {
                throw LoginError.authenticationFailed(error)
            }
        }
    }
    
    private func isUnauthorizedError(_ error: Error) -> Bool {
        if let networkError = error as? NetworkError,
           case .serverError(let message) = networkError {
            return message.contains("401") || message.contains("Unauthorized")
        }
        return false
    }
}

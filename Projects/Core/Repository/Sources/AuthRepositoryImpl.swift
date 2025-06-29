//
//  AuthRepositoryImpl.swift
//  Repository
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Domain
import RepositoryInterface
import NetworkInterface

public final class AuthRepositoryImpl: AuthRepositoryInterface {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func loginWithGoogle(accessToken: String, name: String?) async throws -> LoginUser {
        var parameters: [String: Any] = [
            "accessToken": accessToken
        ]
        
        if let name = name {
            parameters["name"] = name
        }
        
        let endpoint = "/api/v1/login/GOOGLE"
        
        do {
            // Google 전용 DTO 사용
            let apiDTO: ApiResponseGoogleLoginDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw NetworkError.serverError(errorMessage)
            }
            
            return apiDTO.data.toDomain()
            
        } catch let networkError as NetworkError {
            if case .serverError(let message) = networkError, message.contains("401") {
                
                guard let name = name, !name.isEmpty else {
                    throw NetworkError.serverError("회원가입을 위한 이름이 필요합니다.")
                }
                
                let retryParameters: [String: Any] = [
                    "accessToken": accessToken,
                    "name": name
                ]
                
                // 재시도도 Google DTO 사용
                let retryApiDTO: ApiResponseGoogleLoginDTO = try await networkService.post(
                    endpoint: endpoint,
                    parameters: retryParameters
                )
                
                guard retryApiDTO.result == "SUCCESS" else {
                    let errorMessage = retryApiDTO.error?.message ?? "Server Error"
                    throw NetworkError.serverError(errorMessage)
                }
                
                return retryApiDTO.data.toDomain()
            } else {
                throw networkError
            }
        }
    }
    
    public func loginWithApple(identityToken: String, name: String?) async throws -> LoginUser {
        var parameters: [String: Any] = [
            "authorizationCode": identityToken
        ]
        
        if let name = name {
            parameters["name"] = name
        }
        
        let endpoint = "/api/v1/login/APPLE"
        
        do {
            // Apple 전용 DTO 사용
            let apiDTO: ApiResponseAppleLoginDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw NetworkError.serverError(errorMessage)
            }
            
            return apiDTO.data.toDomain()
            
        } catch let networkError as NetworkError {
            if case .serverError(let message) = networkError, message.contains("401") {
                
                guard let name = name, !name.isEmpty else {
                    throw NetworkError.serverError("회원가입을 위한 이름이 필요합니다.")
                }
                
                let retryParameters: [String: Any] = [
                    "authorizationCode": identityToken,
                    "name": name
                ]
                
                // 재시도도 Apple DTO 사용
                let retryApiDTO: ApiResponseAppleLoginDTO = try await networkService.post(
                    endpoint: endpoint,
                    parameters: retryParameters
                )
                
                guard retryApiDTO.result == "SUCCESS" else {
                    let errorMessage = retryApiDTO.error?.message ?? "Server Error"
                    throw NetworkError.serverError(errorMessage)
                }
                
                return retryApiDTO.data.toDomain()
            } else {
                throw networkError
            }
        }
    }
}

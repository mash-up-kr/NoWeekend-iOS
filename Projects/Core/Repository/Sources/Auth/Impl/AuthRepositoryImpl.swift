//
//  AuthRepositoryImpl.swift
//  Network
//
//  Created by SiJongKim on 6/11/25.
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
            "authorizationCode": accessToken
        ]
        
        if let name = name {
            parameters["name"] = name
        }
        
        let endpoint = "/api/v1/login/GOOGLE"
        
        do {
            let apiDTO: ApiResponseGoogleLoginDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw NetworkError.serverError(errorMessage)
            }
            
            let user = apiDTO.data.toDomain()
            return user
            
        } catch {
            throw error
        }
    }
    
    public func loginWithApple(
        identityToken: String,
        authorizationCode: String?,
        email: String?,
        name: String?
    ) async throws -> LoginUser {
        var parameters: [String: Any] = [
            "identityToken": identityToken
        ]
        
        if let authorizationCode = authorizationCode {
            parameters["authorizationCode"] = authorizationCode
        }
        if let email = email {
            parameters["email"] = email
        }
        if let name = name {
            parameters["name"] = name
        }
        
        let endpoint = "/api/v1/login/APPLE"
        
        do {
            let apiDTO: ApiResponseAppleLoginDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw NetworkError.serverError(errorMessage)
            }
            
            return apiDTO.data.toDomain()
        } catch {
            throw error
        }
    }
}

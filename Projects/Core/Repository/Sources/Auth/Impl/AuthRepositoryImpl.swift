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
import Common

public final class AuthRepositoryImpl: AuthRepositoryInterface {
    private let networkService: NetworkServiceInterface
    
    public init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    public func loginWithGoogle(accessToken: String, name: String?) async throws -> LoginUser {
        var parameters: [String: Any] = [
            "accessToken": accessToken
        ]
        
        if let name = name {
            parameters["name"] = name
        }
        
        let endpoint = "/api/v1/login/google"
        
        do {
            let apiDTO: ApiResponseGoogleLoginDTO = try await networkService.post(
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

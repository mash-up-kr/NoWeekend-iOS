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
    
    public func loginWithGoogle(
        authorizationCode: String,
        name: String?
    ) async throws -> LoginUser {
        let requestDTO = GoogleLoginRequestDTO(
            authorizationCode: authorizationCode,
            name: name
        )
        let parameters = try requestDTO.asDictionary()
        let endpoint = "/api/v1/login/GOOGLE"
        let apiDTO: ApiResponseGoogleLoginDTO = try await networkService.post(
            endpoint: endpoint,
            parameters: parameters
        )
        guard apiDTO.result == "SUCCESS" else {
            let errorMessage = apiDTO.error?.message ?? "Server Error"
            throw NetworkError.serverError(errorMessage)
        }
        return apiDTO.data.toDomain()
    }
    
    public func loginWithApple(
        identityToken: String,
        authorizationCode: String?,
        email: String?,
        name: String?
    ) async throws -> LoginUser {
        let requestDTO = AppleLoginRequestDTO(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            email: email,
            name: name
        )
        let parameters = try requestDTO.asDictionary()
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

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = json as? [String: Any] else {
            throw NSError(domain: "Encoding", code: -1, userInfo: nil)
        }
        return dict
    }
}

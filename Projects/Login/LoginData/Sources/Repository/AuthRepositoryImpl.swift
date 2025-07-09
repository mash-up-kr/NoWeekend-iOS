//
//  AuthRepositoryImpl.swift
//  LoginData
//
//  Created by SiJongKim on 6/11/25.
//

//
//  AuthRepositoryImpl.swift
//  LoginData
//
//  Created by SiJongKim on 6/11/25.
//

import Foundation
import LoginDomain
import NWNetwork

public final class AuthRepositoryImpl: AuthRepositoryInterface {
    private let networkService: NWNetworkServiceProtocol
    
    public init(networkService: NWNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - 로그인
    public func loginWithGoogle(authorizationCode: String, name: String?) async throws -> LoginUser {
        let requestDTO = GoogleLoginRequestDTO(
            authorizationCode: authorizationCode,
            name: name
        )
        let parameters = try requestDTO.asDictionary()
        let endpoint = "/login/GOOGLE"
        
        do {
            let apiDTO: ApiResponseGoogleLoginDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw mapToLoginError(errorMessage)
            }
            
            return apiDTO.data.toDomain()
            
        } catch {
            throw mapNetworkErrorToLoginError(error)
        }
    }
    
    public func loginWithApple(authorizationCode: String, name: String?) async throws -> LoginUser {
        let requestDTO = AppleLoginRequestDTO(
            authorizationCode: authorizationCode,
            name: name
        )
        let parameters = try requestDTO.asDictionary()
        let endpoint = "/login/APPLE"
        
        do {
            let apiDTO: ApiResponseAppleLoginDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw mapToLoginError(errorMessage)
            }
            
            return apiDTO.data.toDomain()
            
        } catch {
            throw mapNetworkErrorToLoginError(error)
        }
    }
    
    // MARK: - Apple 회원탈퇴
    public func withdrawAppleAccount(identityToken: String) async throws {
        print("📤 Apple 회원탈퇴 API 호출")
        
        let requestDTO = AppleWithdrawalRequestDTO(identityToken: identityToken)
        let parameters = try requestDTO.asDictionary()
        // 아직 API 요청 안함
        let endpoint = "/withdrawal/APPLE"
        
        do {
            let apiDTO: ApiResponseWithdrawalDTO = try await networkService.post(
                endpoint: endpoint,
                parameters: parameters
            )
            
            guard apiDTO.result == "SUCCESS" else {
                let errorMessage = apiDTO.error?.message ?? "Server Error"
                throw LoginError.withdrawalFailed(
                    NSError(domain: "WithdrawalError", code: 500,
                           userInfo: [NSLocalizedDescriptionKey: errorMessage])
                )
            }
            
            print("✅ Apple 회원탈퇴 API 성공")
            
        } catch {
            throw mapNetworkErrorToWithdrawalError(error)
        }
    }
    
    // MARK: - Error Mapping
    private func mapNetworkErrorToLoginError(_ error: Error) -> LoginError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverError(let message):
                if message.contains("401") || message.contains("Unauthorized") {
                    return .registrationRequired(networkError)
                } else {
                    return .authenticationFailed(networkError)
                }
            case .decodingError, .notImplemented, .unknown:
                return .authenticationFailed(networkError)
            @unknown default:
                return .authenticationFailed(networkError)
            }
        } else {
            return .authenticationFailed(error)
        }
    }
    
    private func mapNetworkErrorToWithdrawalError(_ error: Error) -> LoginError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverError(let message):
                return .withdrawalFailed(
                    NSError(domain: "WithdrawalError", code: 500,
                           userInfo: [NSLocalizedDescriptionKey: message])
                )
            case .decodingError, .notImplemented, .unknown:
                return .withdrawalFailed(networkError)
            @unknown default:
                return .withdrawalFailed(networkError)
            }
        } else {
            return .withdrawalFailed(error)
        }
    }
    
    private func mapToLoginError(_ message: String) -> LoginError {
        if message.contains("401") || message.contains("Unauthorized") {
            return .registrationRequired(
                NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: message])
            )
        } else {
            return .authenticationFailed(
                NSError(domain: "AuthError", code: 500, userInfo: [NSLocalizedDescriptionKey: message])
            )
        }
    }
}


// MARK: - Encodable Extension
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = json as? [String: Any] else {
            throw NSError(domain: "Encoding", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert to dictionary"])
        }
        return dict
    }
}

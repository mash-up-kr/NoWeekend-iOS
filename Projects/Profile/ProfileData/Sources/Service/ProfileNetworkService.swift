//
//  ProfileNetworkService.swift
//  ProfileData
//
//  Created by SiJongKim on 7/11/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import NWNetwork
import ProfileDomain

public final class ProfileNetworkService: ProfileNetworkServiceInterface {
    
    private let networkService: NWNetworkServiceProtocol
    
    public init(networkService: NWNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func getUserProfile() async throws -> UserProfileDTO {
        let response: ApiResponse<UserProfileDTO> = try await networkService.get(
            endpoint: "/user",
            parameters: nil
        )
        
        guard let dataOrString = response.data else {
            throw ProfileNetworkError.noData(endpoint: "/user")
        }
        
        switch dataOrString {
        case .data(let dto):
            return dto
        case .string(let errorMessage):
            throw ProfileNetworkError.invalidResponse(endpoint: "/user")
        }
    }
    
    public func updateUserProfile(_ request: UserProfileUpdateRequestDTO) async throws -> UserProfileDTO {
        let parameters = try request.asDictionary()
        
        let response: ApiResponse<UserProfileDTO> = try await networkService.patch(
            endpoint: "/user/profile",
            parameters: parameters
        )
        
        guard let dataOrString = response.data else {
            throw ProfileNetworkError.updateFailed(endpoint: "/user/profile")
        }
        
        switch dataOrString {
        case .data(let dto):
            return dto
        case .string(let errorMessage):
            throw ProfileNetworkError.invalidResponse(endpoint: "/user/profile")
        }
    }
    
    public func getUserTags() async throws -> UserTagsResponseDTO {
        let response: ApiResponse<UserTagsResponseDTO> = try await networkService.get(
            endpoint: "/user/tags",
            parameters: nil
        )
        
        guard let dataOrString = response.data else {
            throw ProfileNetworkError.noData(endpoint: "/user/tags")
        }
        
        switch dataOrString {
        case .data(let dto):
            return dto
        case .string(let errorMessage):
            throw ProfileNetworkError.invalidResponse(endpoint: "/user/tags")
        }
    }
    
    public func updateUserTags(_ request: UserTagsUpdateRequestDTO) async throws -> UserTagsResponseDTO {
        let parameters = try request.asDictionary()
        
        let response: ApiResponse<UserTagsResponseDTO> = try await networkService.patch(
            endpoint: "/user/tags",
            parameters: parameters
        )
        
        guard let dataOrString = response.data else {
            throw ProfileNetworkError.updateFailed(endpoint: "/user/tags")
        }
        
        switch dataOrString {
        case .data(let dto):
            return dto
        case .string(let errorMessage):
            throw ProfileNetworkError.invalidResponse(endpoint: "/user/tags")
        }
    }
    
    public func updateVacationLeave(_ request: VacationLeaveDTO) async throws -> VacationLeaveDTO {
        let parameters = try request.asDictionary()
        
        let response: ApiResponse<VacationLeaveDTO> = try await networkService.patch(
            endpoint: "/user/leave",
            parameters: parameters
        )
        
        guard let dataOrString = response.data else {
            throw ProfileNetworkError.updateFailed(endpoint: "/user/leave")
        }
        
        switch dataOrString {
        case .data(let dto):
            return dto
        case .string(let errorMessage):
            throw ProfileNetworkError.invalidResponse(endpoint: "/user/leave")
        }
    }
    
    public func getAITagRecommendation(selectedTags: [String]) async throws -> AIRecommendationResponse {
            var queryItems: [URLQueryItem] = []
            
            for (index, tag) in selectedTags.enumerated() {
                queryItems.append(URLQueryItem(name: "selectedTags[\(index)]", value: tag))
            }
            
            var urlComponents = URLComponents(string: "/recommend/todo/new-only")!
            urlComponents.queryItems = queryItems
            
            let response: AIRecommendationResponse = try await networkService.get(
                endpoint: urlComponents.url?.absoluteString ?? "/recommend/todo/new-only",
                parameters: nil
            )
            
            return response
        }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw ProfileNetworkError.invalidResponse(endpoint: "encoding")
        }
        return dictionary
    }
}

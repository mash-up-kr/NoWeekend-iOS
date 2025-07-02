//
//  OnboardingDataSourceInterface.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import NetworkInterface

public class OnboardingNetworkDataSource: OnboardingDataSourceInterface {
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func saveProfile(_ dto: ProfileRequestDTO) async throws -> OnboardingResponseDTO {
        let endpoint = OnboardingEndpoint.profile
        
        print("🌐 API Request: \(endpoint.method) \(endpoint.path)")
        print("📤 Request DTO: \(dto.toDictionary)")
        
        return try await networkService.post(
            endpoint: endpoint.path,
            parameters: dto.toDictionary
        )
    }
    
    public func saveLeave(_ dto: LeaveRequestDTO) async throws -> OnboardingResponseDTO {
        let endpoint = OnboardingEndpoint.leave
        
        print("🌐 API Request: \(endpoint.method) \(endpoint.path)")
        print("📤 Request DTO: \(dto.toDictionary)")
        
        return try await networkService.post(
            endpoint: endpoint.path,
            parameters: dto.toDictionary
        )
    }
    
    public func saveTags(_ dto: TagRequestDTO) async throws -> OnboardingResponseDTO {
        let endpoint = OnboardingEndpoint.tag
        
        print("🌐 API Request: \(endpoint.method) \(endpoint.path)")
        print("📤 Request DTO: \(dto.toDictionary)")
        
        return try await networkService.post(
            endpoint: endpoint.path,
            parameters: dto.toDictionary
        )
    }
}


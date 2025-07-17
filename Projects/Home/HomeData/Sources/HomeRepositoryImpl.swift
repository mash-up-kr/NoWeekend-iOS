//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DIContainer
import Foundation
import HomeDomain
import NWNetwork

public final class HomeRepositoryImpl: HomeRepositoryProtocol {
    private let networkService: NWNetworkServiceProtocol

    public init(networkService: NWNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func getHomes() async throws -> [Home] {
        // 빈 배열 반환 - 뷰에서 자체 데이터 사용
        return []
    }
    
    public func createHome(_ home: Home) async throws {
        // 빈 구현
    }
    
    public func deleteHome(id: String) async throws {
        // 빈 구현
    }

    public func registerLocation(_ location: LocationRegistration) async throws {
        let dto = location.toDTO()
        let parameters: [String: Any] = [
            "latitude": dto.latitude,
            "longitude": dto.longitude
        ]
        let _: ApiResponse<String> = try await networkService.post(
            endpoint: HomeEndpoint.registerLocation.path,
            parameters: parameters
        )
    }

    public func getWeatherRecommendations() async throws -> [Weather] {
        let response: ApiResponse<WeatherRecommendResponseDTO> = try await networkService.get(
            endpoint: HomeEndpoint.getWeatherRecommendations.path,
            parameters: nil
        )
        return response.data?.weatherResponses.map { $0.toDomain() } ?? []
    }
    
    public func getSandwichHoliday() async throws -> [SandwichHoliday] {
        let response: SandwichHolidayResponseDTO = try await networkService.get(
            endpoint: HomeEndpoint.getSandwichHoliday.path,
            parameters: nil
        )
        
        guard response.result == "SUCCESS" else {
            throw NetworkError.serverError(response.error ?? "샌드위치 휴일 조회 실패")
        }
        
        guard let data = response.data else {
            return []
        }
        
        return data.toDomain()
    }
    
    public func getHolidays() async throws -> [Holiday] {
        let response: HolidayResponseDTO = try await networkService.get(
            endpoint: HomeEndpoint.getHolidays.path,
            parameters: nil
        )
        
        guard response.result == "SUCCESS" else {
            throw NetworkError.serverError(response.error ?? "공휴일 조회 실패")
        }
        
        return response.data?.holidays.compactMap { $0.toDomain() } ?? []
    }
} 
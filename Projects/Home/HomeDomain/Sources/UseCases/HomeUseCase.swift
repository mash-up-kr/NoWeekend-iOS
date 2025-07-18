//
//  HomeUseCaseProtocol.swift
//  HomeDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public class HomeUseCase: HomeUseCaseProtocol {
    private let homeRepository: HomeRepositoryProtocol
    
    public init(homeRepository: HomeRepositoryProtocol) {
        self.homeRepository = homeRepository
        print("🏠 HomeUseCase 생성")
    }
    
    public func getHomes() async throws -> [Home] {
        return []
    }
    
    public func createHome(title: String, date: Date, description: String?) async throws {
    }
    
    public func deleteHome(id: String) async throws {
    }
    
    public func getUpcomingHomes() async throws -> [Home] {
        return []
    }
    
    // MARK: - 위치 및 날씨 관련
    
    public func registerLocation(latitude: Double, longitude: Double) async throws {
        let location = LocationRegistration(latitude: latitude, longitude: longitude)
        try await homeRepository.registerLocation(location)
    }
    
    public func getWeatherRecommendations() async throws -> [Weather] {
        return try await homeRepository.getWeatherRecommendations()
    }
    
    // MARK: - 샌드위치 휴일 및 공휴일 관련
    
    public func getSandwichHoliday() async throws -> [SandwichHoliday] {
        return try await homeRepository.getSandwichHoliday()
    }
    
    public func getHolidays() async throws -> [Holiday] {
        return try await homeRepository.getHolidays()
    }
    
    // MARK: - 휴가 추천 관련
    
    public func createVacationRecommend(_ request: VacationRecommendRequest) async throws -> String {
        return try await homeRepository.createVacationRecommend(request)
    }
    
    public func getVacationRecommend() async throws -> VacationRecommend? {
        return try await homeRepository.getVacationRecommend()
    }
} 

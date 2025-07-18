//
//  WeatherService.swift
//  HomeFeature
//
//  Created by 김나희 on 7/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import HomeDomain

final class WeatherService {
    private let homeUseCase: HomeUseCaseProtocol
    
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }
    
    // MARK: - Weather Data Loading
    
    func loadWeatherData() async throws -> [Weather] {
        return try await homeUseCase.getWeatherRecommendations()
    }
    
    // MARK: - Error Handling
    
    func isLocationMissingError(_ error: Error) -> Bool {
        return error.localizedDescription.contains("404") || 
               error.localizedDescription.contains("위치 정보가 존재하지 않습니다")
    }
} 

//
//  LocationService.swift
//  HomeFeature
//
//  Created by 김나희 on 7/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import HomeDomain
import Utils

final class LocationService {
    private let homeUseCase: HomeUseCaseProtocol
    private let locationManager: LocationManager
    
    init(homeUseCase: HomeUseCaseProtocol, locationManager: LocationManager) {
        self.homeUseCase = homeUseCase
        self.locationManager = locationManager
    }
    
    // MARK: - Location Registration
    
    func registerLocation(_ location: LocationInfo) async throws {
        
        try await homeUseCase.registerLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
    }
    
    // MARK: - Location Resolution
    
    func resolveLocationForRegistration(currentLocation: LocationInfo?) -> LocationInfo {
        if let currentLocation = currentLocation {
            return currentLocation
        }
        return locationManager.getDefaultLocation()
    }
    
    // MARK: - Address Update
    
    func updateLocationWithAddress(_ location: LocationInfo) async -> LocationInfo {
        return await locationManager.updateLocationWithAddress(location)
    }
    
    // MARK: - Saved Location
    
    func getSavedLocation() -> LocationInfo? {
        return locationManager.getSavedLocation()
    }
} 

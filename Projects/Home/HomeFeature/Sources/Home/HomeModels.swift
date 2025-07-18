//
//  HomeModels.swift
//  HomeFeature
//
//  Created by 김나희 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Utils
import HomeDomain
import Foundation

// MARK: - Location Registration State

enum LocationRegistrationState: Equatable {
    case notRegistered
    case registering
    case registered
    case failed(String)
    
    var isRegistered: Bool {
        switch self {
        case .registered:
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .registering:
            return true
        default:
            return false
        }
    }
}

// MARK: - Home State

struct HomeState: Equatable {
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var vacationBakingStatus: VacationBakingStatus = .notStarted
    var remainingAnnualLeave: Int = 10
    
    var currentMonth: String = ""
    var currentWeekOfMonth: String = ""
    
    var locationPermissionStatus: LocationPermissionStatus = .notDetermined
    var hasLocationPermission: Bool = false
    var currentLocation: LocationInfo? = nil
    var savedLocation: LocationInfo? = nil
    
    var locationRegistrationState: LocationRegistrationState = .notRegistered
    var isWeatherLoading: Bool = false
    var weatherRecommendations: [Weather] = []
    var currentLocationAddress: String? = nil
    
    // 기존 boolean 값들과의 호환성을 위한 computed property
    var isLocationRegistered: Bool {
        get { locationRegistrationState.isRegistered }
        set { 
            if newValue {
                locationRegistrationState = .registered
            } else {
                locationRegistrationState = .notRegistered
            }
        }
    }
    
    // 샌드위치 휴일 및 공휴일 관련 상태
    var sandwichHoliday: [SandwichHoliday] = []
    var holidays: [Holiday] = []
    var isHolidayLoading: Bool = false
    
    //생일축하합니다~
    var userBirthday: String? = nil
    var isBirthdayLoading: Bool = false
    
    // 사용자 정보
    var averageTemperature: Double = 0.0
    
    
    
    var longCards: [VacationCardItem] = [
        VacationCardItem(dateString: "0/00(월) ~ 0/00(월)", type: .trip),
        VacationCardItem(dateString: "0/00(월) ~ 0/00(월)", type: .home)
    ]
    
    var shortCards: [VacationCardItem] = [
        VacationCardItem(dateString: "0/00(월) ~ 0/00(월)", type: .sandwich),
        VacationCardItem(dateString: "0/00(월)", type: .birthday),
        VacationCardItem(dateString: "0/00(월)", type: .holiday),
    ]
}

// MARK: - Home Intent

enum HomeIntent {
    case viewDidLoad
    case vacationCardTapped(VacationCardType)
    case refreshData
    case vacationBakingCompleted
    case vacationBakingProcessed
    case remainingAnnualLeaveLoaded(Int)
    case locationIconTapped
    case locationPermissionChanged(LocationPermissionStatus)
    case registerLocation
    case loadWeatherRecommendations
    case loadSandwichHoliday
    case loadHolidays
    case selectedDateChanged(Date)
}

// MARK: - Home Effect

enum HomeEffect {
    case showError(String)
    case navigateToDetail(VacationCardType)
    case showLoading
    case hideLoading
    case requestLocationPermission
    case openAppSettings
    case showLocationPermissionDeniedAlert
    case showLocationSettingsAlert
}

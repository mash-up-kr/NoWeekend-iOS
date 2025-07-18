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
    var vacationBakingStatus: VacationBakingStatus = .none
    var remainingAnnualLeave: Int = 10
    
    var currentMonth: String = ""
    var currentWeekOfMonth: String = ""
    
    var locationPermissionStatus: LocationPermissionStatus = .notDetermined
    var hasLocationPermission: Bool = false
    var currentLocation: LocationInfo? = nil
    var savedLocation: LocationInfo? = nil
    
    // 위치 등록 상태를 enum으로 관리
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
    
    // 휴가 추천 관련 상태
    var vacationRecommendState: VacationRecommendState = VacationRecommendState(status: .none) {
        didSet {
            // 네트워킹 상태에 따라 vacationBakingStatus 업데이트
            vacationBakingStatus = vacationRecommendState.status.toVacationBakingStatus()
        }
    }
    
    var longCards: [VacationCardItem] = [
        VacationCardItem(dateString: "0/00(월) ~ 0/00(월)", type: .trip),
        VacationCardItem(dateString: "0/00(월) ~ 0/00(월)", type: .home)
    ]
    
    var shortCards: [VacationCardItem] = [
        VacationCardItem(dateString: "0/00(월) ~ 0/00(월)", type: .sandwich),
        VacationCardItem(dateString: "0/00(월)", type: .birthday),
        VacationCardItem(dateString: "0/00(월)", type: .holiday),
    ]
    
    // 바텀시트 상태
    var showTextInputBottomSheet: Bool = false
    var textInputBottomSheetData: TextInputBottomSheetData?
}

// MARK: - Text Input Bottom Sheet Data

struct TextInputBottomSheetData: Equatable {
    let title: String
    let selectedHoliday: Holiday?
    let selectedWeatherDate: String?
    let selectedCardType: VacationCardType?
    let selectedVacationRecommend: VacationRecommend?
    
    init(
        title: String = "",
        selectedHoliday: Holiday? = nil,
        selectedWeatherDate: String? = nil,
        selectedCardType: VacationCardType? = nil,
        selectedVacationRecommend: VacationRecommend? = nil
    ) {
        self.title = title
        self.selectedHoliday = selectedHoliday
        self.selectedWeatherDate = selectedWeatherDate
        self.selectedCardType = selectedCardType
        self.selectedVacationRecommend = selectedVacationRecommend
    }
}

// MARK: - Home Intent

enum HomeIntent {
    case viewDidLoad
    case vacationCardTapped(VacationCardType)
    case refreshData
    case vacationBakingCompleted(VacationBakingResult)
    case remainingAnnualLeaveLoaded(Int)
    case locationIconTapped
    case locationPermissionChanged(LocationPermissionStatus)
    case registerLocation
    case loadWeatherRecommendations
    case loadSandwichHoliday
    case loadHolidays
    case selectedDateChanged(Date)
    case createVacationRecommend(VacationRecommendRequest)
    case startVacationRecommendPolling
    case stopVacationRecommendPolling
    case showTextInputBottomSheet(TextInputBottomSheetData)
    case hideTextInputBottomSheet
}

// MARK: - Home Effect

enum HomeEffect {
    case showError(String)
    case navigateToDetail(VacationCardType)
    case showLoading
    case hideLoading
    case requestLocationPermission
    case showLocationPermissionDeniedAlert
    case showLocationSettingsAlert
}

// MARK: - VacationRecommendStatus to VacationBakingStatus Extension

extension VacationRecommendStatus {
    func toVacationBakingStatus() -> VacationBakingStatus {
        switch self {
        case .none:
            return .none
        case .requesting:
            return .requesting
        case .ready:
            return .ready
        case .failed:
            return .failed
        }
    }
}

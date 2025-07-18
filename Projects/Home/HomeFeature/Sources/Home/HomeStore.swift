//
//  HomeStore.swift
//  HomeFeature
//
//  Created by 김나희 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem
import CalendarDomain
import Combine
import DIContainer
import Foundation
import HomeDomain
import ProfileDomain
import Utils

@MainActor
final class HomeStore: ObservableObject {
    @Published private(set) var state = HomeState()
    @Published var weeklySchedules: [DailySchedule] = []
        
    let effect = PassthroughSubject<HomeEffect, Never>()
    
    // Services
    private let locationService: LocationService
    private let weatherService: WeatherService
    private let homeUseCase: HomeUseCaseProtocol
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    private var vacationRecommendTimer: Timer?

    init() {
        self.homeUseCase = DIContainer.shared.resolve(HomeUseCaseProtocol.self)
        self.getUserProfileUseCase = DIContainer.shared.resolve(GetUserProfileUseCaseProtocol.self)
        self.calendarUseCase = DIContainer.shared.resolve(CalendarUseCaseProtocol.self)
        
        // Initialize services
        self.locationService = LocationService(homeUseCase: homeUseCase, locationManager: locationManager)
        self.weatherService = WeatherService(homeUseCase: homeUseCase)
    }
    
    // MARK: - Intent Handling

    func send(_ intent: HomeIntent) {
        switch intent {
        case .viewDidLoad:
            handleViewDidLoad()
        case .vacationCardTapped(let cardType):
            handleVacationCardTapped(cardType)
        case .refreshData:
            handleRefreshData()
        case .vacationBakingCompleted(let result):
            handleVacationBakingCompleted(result)
        case .remainingAnnualLeaveLoaded(let days):
            handleRemainingAnnualLeaveLoaded(days)
        case .locationIconTapped:
            handleLocationIconTapped()
        case .locationPermissionChanged(let status):
            handleLocationPermissionChanged(status)
        case .registerLocation:
            handleRegisterLocation()
        case .loadWeatherRecommendations:
            handleLoadWeatherRecommendations()
        case .loadSandwichHoliday:
            handleLoadSandwichHoliday()
        case .loadHolidays:
            handleLoadHolidays()
        case .selectedDateChanged(let date):
            handleSelectedDateChanged(date)
        case .createVacationRecommend(let request):
            handleCreateVacationRecommend(request)
        case .startVacationRecommendPolling:
            handleStartVacationRecommendPolling()
        case .stopVacationRecommendPolling:
            handleStopVacationRecommendPolling()
        }
    }
    
    // MARK: - Location & Weather Management
    
    private func handleLoadWeatherRecommendations() {
        Task {
            await loadWeatherWithLocationCheck()
        }
    }
    
    private func handleRegisterLocation() {
        Task {
            await registerCurrentLocation()
        }
    }
    
    private func registerCurrentLocation() async {
        let location = locationService.resolveLocationForRegistration(currentLocation: state.currentLocation)
        await registerLocationAndLoadWeather(location: location)
    }
    
    private func loadWeatherWithLocationCheck() async {
        if state.locationRegistrationState.isRegistered {
            await loadWeatherData()
        } else {
            await registerCurrentLocation()
        }
    }
    
    private func registerLocationAndLoadWeather(location: LocationInfo) async {
        state.locationRegistrationState = .registering
        
        do {
            try await locationService.registerLocation(location)
            
            // Update state and address
            state.locationRegistrationState = .registered
            state.currentLocation = location
            
            let updatedLocation = await locationService.updateLocationWithAddress(location)
            state.currentLocationAddress = updatedLocation.address
            
            // Load weather data after successful registration
            await loadWeatherData()
            
        } catch {
            print("❌ 위치 등록 실패: \(error)")
            state.locationRegistrationState = .failed(error.localizedDescription)
            effect.send(.showError("위치 등록에 실패했습니다."))
        }
    }
    
    private func loadWeatherData() async {
        state.isWeatherLoading = true
        
            do {
            let weatherData = try await weatherService.loadWeatherData()
                state.weatherRecommendations = weatherData
                state.isWeatherLoading = false
            
            } catch {
                state.isWeatherLoading = false
            print("❌ 날씨 데이터 로딩 실패: \(error)")
            
            // Handle location missing error
            if weatherService.isLocationMissingError(error) {
                print("🔄 위치 정보 없음 - 위치 등록 재시도")
                state.locationRegistrationState = .notRegistered
                await registerCurrentLocation()
            } else {
                effect.send(.showError("날씨 데이터를 가져오는데 실패했습니다."))
            }
        }
    }
    
    // MARK: - Other Intent Handlers
    
    private func handleViewDidLoad() {
        updateCurrentDateInfo()
        setupLocationManager()
        
        send(.loadSandwichHoliday)
        send(.loadHolidays)
        
        Task {
            await loadUserInfoAsync()
        }
    }
    
    private func handleLoadSandwichHoliday() {
        state.isHolidayLoading = true
        Task {
            do {
                let sandwichHolidays = try await homeUseCase.getSandwichHoliday()
                state.sandwichHoliday = sandwichHolidays
                state.isHolidayLoading = false
                updateShortCardsWithSandwichHolidayData()
            } catch {
                state.isHolidayLoading = false
                effect.send(.showError("샌드위치 휴일 데이터를 가져오는데 실패했습니다."))
            }
        }
    }
    
    private func handleLoadHolidays() {
        state.isHolidayLoading = true
        Task {
            do {
                let holidays = try await homeUseCase.getHolidays()
                state.holidays = holidays
                state.isHolidayLoading = false
                updateShortCardsWithHolidayData()
            } catch {
                state.isHolidayLoading = false
                effect.send(.showError("공휴일 데이터를 가져오는데 실패했습니다."))
            }
        }
    }
    
    private func handleSelectedDateChanged(_ date: Date) {
        updateCardData(for: date)
    }
    
    private func handleRefreshData() {
        state.isLoading = true
        effect.send(.showLoading)
        
        Task {
            if state.currentLocation != nil {
                await loadWeatherData()
            }
            
            await loadSandwichHolidayAsync()
            await loadHolidaysAsync()
            await loadUserInfoAsync()
            
            state.isLoading = false
            effect.send(.hideLoading)
        }
    }
    
    private func handleVacationCardTapped(_ cardType: VacationCardType) {
        effect.send(.navigateToDetail(cardType))
    }
    
    private func handleVacationBakingCompleted(_ result: VacationBakingResult) {
        state.vacationRecommendState = VacationRecommendState(status: .requesting)
        
        // 사용자가 선택한 실제 데이터로 API 요청
        let vacationRequest = VacationRecommendRequest(
            days: result.days,
            travelStyle: result.travelStyle,
            activityType: result.activityType,
            restPreference: result.restPreference,
            leisurePreference: result.leisurePreference
        )
        
        print("사용자 선택 데이터로 휴가 추천 요청: \(vacationRequest)")
        
        // 휴가 추천 API 요청 시작
        send(.createVacationRecommend(vacationRequest))
    }
    
    private func handleRemainingAnnualLeaveLoaded(_ days: Int) {
        state.remainingAnnualLeave = days
    }
    
    private func handleLocationIconTapped() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.refreshLocation()
        case .denied, .restricted:
            effect.send(.showLocationSettingsAlert)
        case .notDetermined:
            effect.send(.requestLocationPermission)
        default:
            break
        }
    }
    
    private func handleLocationPermissionChanged(_ status: LocationPermissionStatus) {
        let previousStatus = state.locationPermissionStatus
        state.locationPermissionStatus = status
        state.hasLocationPermission = (status == .authorizedWhenInUse || status == .authorizedAlways)
        
        if (status == .denied || status == .restricted) && previousStatus == .notDetermined {
            effect.send(.showLocationPermissionDeniedAlert)
            Task {
                await registerCurrentLocation()
            }
        }
    }
    
    // MARK: - Setup Methods
    
    private func updateCurrentDateInfo() {
        let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        let now = Date()
        
        state.currentMonth = now.toMonthString()
        
        var calendar = Calendar.current
        calendar.timeZone = koreaTimeZone
        let weekOfMonth = calendar.component(.weekOfMonth, from: now)
        
        let weekNames = ["첫째", "둘째", "셋째", "넷째", "다섯째", "여섯째"]
        state.currentWeekOfMonth = weekNames[weekOfMonth - 1]
    }
    
    private func setupLocationManager() {
        state.locationPermissionStatus = locationManager.authorizationStatus
        state.hasLocationPermission = (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways)
        
        state.savedLocation = locationService.getSavedLocation()
        
        if let savedLocation = state.savedLocation {
            state.currentLocation = savedLocation
            state.currentLocationAddress = savedLocation.address
            print("💾 저장된 위치 발견: \(savedLocation.coordinate)")
            
            Task {
                await loadWeatherData()
            }
        } else {
            print("💾 저장된 위치 없음")
        Task {
                await registerCurrentLocation()
            }
        }
        
        setupLocationObservers()
        
        if locationManager.authorizationStatus == .notDetermined {
            effect.send(.requestLocationPermission)
        } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            if state.savedLocation == nil {
                locationManager.requestLocationOnce()
            }
        }
    }
    
    private func setupLocationObservers() {
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.send(.locationPermissionChanged(status))
            }
            .store(in: &cancellables)
        
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                
                self.state.currentLocation = location
                self.state.savedLocation = location
                
                if !self.state.locationRegistrationState.isRegistered {
                    Task {
                        await self.registerLocationAndLoadWeather(location: location)
                    }
                } else {
                    Task {
                        let updatedLocation = await self.locationService.updateLocationWithAddress(location)
                        self.state.currentLocationAddress = updatedLocation.address
                        await self.loadWeatherData()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Async Methods for Refresh
    
    private func loadSandwichHolidayAsync() async {
        state.isHolidayLoading = true
        do {
            let sandwichHolidays = try await homeUseCase.getSandwichHoliday()
            state.sandwichHoliday = sandwichHolidays
            state.isHolidayLoading = false
            updateShortCardsWithSandwichHolidayData()
        } catch {
            state.isHolidayLoading = false
            effect.send(.showError("샌드위치 휴일 데이터를 가져오는데 실패했습니다."))
        }
    }
    
    private func loadHolidaysAsync() async {
        state.isHolidayLoading = true
        do {
            let holidays = try await homeUseCase.getHolidays()
            state.holidays = holidays
            state.isHolidayLoading = false
            updateShortCardsWithHolidayData()
        } catch {
            state.isHolidayLoading = false
            effect.send(.showError("공휴일 데이터를 가져오는데 실패했습니다."))
        }
    }
    
    private func updateCardData(for date: Date) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let monthName = date.toMonthName()
        
        state.shortCards = [
            VacationCardItem(dateString: "\(month)/00(\(monthName)) ~ \(month)/00(\(monthName))", type: .sandwich),
            VacationCardItem(dateString: "\(month)/00(\(monthName))", type: .birthday),
            VacationCardItem(dateString: "\(month)/00(\(monthName))", type: .holiday),
        ]
        
        updateShortCardsWithHolidayData()
        updateShortCardsWithSandwichHolidayData()
        updateBirthdayCard()
    }
    
    // MARK: - User Info
    
    private func loadUserInfoAsync() async {
        state.isBirthdayLoading = true
        do {
            let userProfile = try await getUserProfileUseCase.execute()
            print("🔥 userProfile: \(userProfile)")

            state.averageTemperature = userProfile.averageTemperature
            state.userBirthday = userProfile.birthDate
            state.remainingAnnualLeave = Int(userProfile.remainingAnnualLeave)
            
            state.isBirthdayLoading = false
            updateBirthdayCard()
        } catch {
            state.isBirthdayLoading = false
            effect.send(.showError("사용자 정보를 가져오는데 실패했습니다."))
        }
    }
    

    
    private func updateBirthdayCard() {
        let birthdayText: String
        if let userBirthday = state.userBirthday, let birthday = userBirthday.toDate() {
            birthdayText = birthday.toMonthDayString()
        } else {
            birthdayText = "생일 없음"
        }
        
        for index in state.shortCards.indices {
            if state.shortCards[index].type == .birthday {
                state.shortCards[index] = VacationCardItem(
                    dateString: birthdayText,
                    type: .birthday
                )
                break
            }
        }
    }
    
    // MARK: - Card Update Methods
    
    private func updateShortCardsWithHolidayData() {
        updateCard(for: .holiday, data: state.holidays, defaultText: "공휴일 없음") { holidays in
            getNextUpcomingHoliday(from: holidays)
        }
    }
    
    private func updateShortCardsWithSandwichHolidayData() {
        let nextSandwichHoliday = getNextUpcomingSandwichHoliday(from: state.sandwichHoliday)
        let dateString = nextSandwichHoliday?.dateString ?? "샌드위치 휴일 없음"
        
        for index in state.shortCards.indices {
            if state.shortCards[index].type == .sandwich {
                state.shortCards[index] = VacationCardItem(
                    dateString: dateString,
                    type: .sandwich,
                    sandwichHoliday: nextSandwichHoliday
                )
                break
            }
        }
    }
    
    private func updateCard<T>(
        for cardType: VacationCardType,
        data: [T],
        defaultText: String,
        getNextUpcoming: ([T]) -> (any DateStringConvertible)?
    ) {
        let nextItem = data.isEmpty ? nil : getNextUpcoming(data)
        let dateString = nextItem?.dateString ?? defaultText
        
        for index in state.shortCards.indices {
            if state.shortCards[index].type == cardType {
                state.shortCards[index] = VacationCardItem(
                    dateString: dateString,
                    type: cardType
                )
                break
            }
        }
    }
    
    private func getNextUpcomingHoliday(from holidays: [Holiday]) -> Holiday? {
        let today = Date()
        let calendar = Calendar.current
        
        let upcomingHolidays = holidays
            .filter { holiday in
                calendar.compare(holiday.date, to: today, toGranularity: .day) != .orderedAscending
            }
            .sorted { $0.date < $1.date }
        
        return upcomingHolidays.first
    }
    
    private func getNextUpcomingSandwichHoliday(from sandwichHolidays: [SandwichHoliday]) -> SandwichHoliday? {
        let today = Date()
        let calendar = Calendar.current
        
        let upcomingSandwichHolidays = sandwichHolidays
            .filter { sandwichHoliday in
                calendar.compare(sandwichHoliday.endDate, to: today, toGranularity: .day) != .orderedAscending
            }
            .sorted { $0.startDate < $1.startDate }
        
        return upcomingSandwichHolidays.first
    }
    
    // MARK: - Calendar & Weather Methods
    
    func formatWeatherDate(_ dateString: String) -> String {
        guard let date = dateString.toDate() else {
            return dateString
        }
        
        return date.toMonthDayWeekString()
    }
    
    // MARK: - Date Helper Methods
    
    func getBirthdayDate() -> Date? {
        guard let userBirthday = state.userBirthday else { return nil }
        return userBirthday.toDate()
    }
    
    func getWeatherDate(from dateString: String) -> Date? {
        return dateString.toDate()
    }
    
    func determineTargetDate(
        selectedHoliday: Holiday?,
        selectedWeatherDate: String?,
        selectedCardType: VacationCardType?
    ) -> Date {
        if let holiday = selectedHoliday {
            return holiday.date
        }
        
        if let weatherDateString = selectedWeatherDate {
            if let date = getWeatherDate(from: weatherDateString) {
                return date
            }
        }
        
        if let cardType = selectedCardType {
            switch cardType {
            case .sandwich:
                if let sandwichHoliday = state.sandwichHoliday.first {
                    return sandwichHoliday.startDate
                }
            case .birthday:
                if let birthday = getBirthdayDate() {
                    return birthday
                }
            case .holiday:
                if let holiday = state.holidays.first {
                    return holiday.date
                }
            default:
                break
            }
        }
        
        return Date()
    }
}

// MARK: - Extensions

extension HomeStore {
    func loadWeeklySchedules() async {
        do {
            let schedules = try await calendarUseCase.getWeeklySchedules(for: Date())
            await MainActor.run {
                self.weeklySchedules = schedules
            }
        } catch {
            print("❌ 주간 스케줄 로드 실패: \(error)")
            await MainActor.run {
                self.weeklySchedules = []
            }
        }
    }
    
    func getSchedulesForDate(_ date: Date) -> [Schedule] {
        let dateString = date.toString(format: "yyyy-MM-dd")
        
        if let daySchedule = weeklySchedules.first(where: { $0.date == dateString }) {
            return daySchedule.schedules
        }
        
        return []
    }
    
    func calendarCellContent(for date: Date) -> some View {
        let schedules = getSchedulesForDate(date)
        return AnyView(temperatureImage(for: schedules).resizable().scaledToFit())
    }
    
    private func temperatureImage(for schedules: [Schedule]) -> Image {
        if schedules.isEmpty {
            return DS.Images.imgFlour
        }
        
        let hasVacation = schedules.contains { $0.category == .leave }
        if hasVacation {
            return DS.Images.imgToastVacation
        }
        
        let hasCompletedTasks = schedules.contains { $0.completed }
        
        if !hasCompletedTasks {
            return DS.Images.imgToastNone
        }
        
        let avgTemperature = calculateAverageTemperature(for: schedules)
        
        switch avgTemperature {
        case 0...25:
            return DS.Images.imgToastDefault
        case 26...50:
            return DS.Images.imgToastEven
        case 51...100:
            return DS.Images.imgToastBurn
        default:
            return DS.Images.imgToastDefault
        }
    }
    
    private func calculateAverageTemperature(for schedules: [Schedule]) -> Int {
        guard !schedules.isEmpty else { return 0 }
        
        let totalTemperature = schedules.reduce(0) { $0 + $1.temperature }
        return totalTemperature / schedules.count
    }
    
    func getNextUpcomingHoliday() -> Holiday? {
        let today = Date()
        let calendar = Calendar.current
        
        return state.holidays
            .filter { holiday in
                calendar.compare(holiday.date, to: today, toGranularity: .day) != .orderedAscending
            }
            .sorted { $0.date < $1.date }
            .first
    }
    
    func getNextUpcomingSandwichHoliday() -> SandwichHoliday? {
        let today = Date()
        let calendar = Calendar.current
        
        return state.sandwichHoliday
            .filter { sandwichHoliday in
                calendar.compare(sandwichHoliday.endDate, to: today, toGranularity: .day) != .orderedAscending
            }
            .sorted { $0.startDate < $1.startDate }
            .first
    }
    
    // MARK: - Vacation Recommend Handlers
    
    private func handleCreateVacationRecommend(_ request: VacationRecommendRequest) {
        state.vacationRecommendState = VacationRecommendState(status: .requesting)
        
        Task {
            do {
                let message = try await homeUseCase.createVacationRecommend(request)
                print("휴가 추천 생성 시작: \(message)")
                
                // 폴링 시작
                send(.startVacationRecommendPolling)
                
            } catch {
                print("❌ 휴가 추천 생성 실패: \(error)")
                state.vacationRecommendState = VacationRecommendState(
                    status: .failed,
                    error: error.localizedDescription
                )
            }
        }
    }
    
    private func handleStartVacationRecommendPolling() {
        // 기존 타이머 정리
        vacationRecommendTimer?.invalidate()
        
        // 2분(120초)마다 폴링
        vacationRecommendTimer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { [weak self] _ in
            Task {
                await self?.checkVacationRecommendStatus()
            }
        }
        
        // 즉시 한 번 체크
        Task {
            await checkVacationRecommendStatus()
        }
    }
    
    private func handleStopVacationRecommendPolling() {
        vacationRecommendTimer?.invalidate()
        vacationRecommendTimer = nil
    }
    
    private func checkVacationRecommendStatus() async {
        do {
            if let recommendation = try await homeUseCase.getVacationRecommend() {
                print("휴가 추천 완료: \(recommendation.title)")
                
                // 메인 스레드에서 상태 업데이트
                await MainActor.run {
                    state.vacationRecommendState = VacationRecommendState(
                        status: .ready,
                        recommendation: recommendation
                    )
                    
                    // 폴링 중지
                    send(.stopVacationRecommendPolling)
                }
            } else {
                print("휴가 추천 아직 준비 중...")
            }
        } catch {
            print("❌ 휴가 추천 조회 실패: \(error)")
        }
    }

}

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
import DIContainer
import Combine
import Foundation
import Utils
import HomeDomain
import ProfileDomain

@MainActor
final class HomeStore: ObservableObject {
    private let homeUseCase: HomeUseCaseProtocol
    private let getUserProfileUseCase: GetUserProfileUseCaseProtocol
    private let calendarUseCase: CalendarUseCaseProtocol
    
    @Published private(set) var state = HomeState()
    @Published var weeklySchedules: [DailySchedule] = []
        
    let effect = PassthroughSubject<HomeEffect, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared

    init() {
        self.homeUseCase = DIContainer.shared.resolve(HomeUseCaseProtocol.self)
        self.getUserProfileUseCase = DIContainer.shared.resolve(GetUserProfileUseCaseProtocol.self)
        self.calendarUseCase = DIContainer.shared.resolve(CalendarUseCaseProtocol.self)
    }

    func send(_ intent: HomeIntent) {
        switch intent {
        case .viewDidLoad:
            handleViewDidLoad()
            
        case .vacationCardTapped(let cardType):
            handleVacationCardTapped(cardType)
            
        case .refreshData:
            handleRefreshData()
            
        case .vacationBakingCompleted:
            handleVacationBakingCompleted()
            
        case .vacationBakingProcessed:
            handleVacationBakingProcessed()
            
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
        }
    }
    
    private func handleViewDidLoad() {
        // 초기 데이터 로딩 로직
        // TODO: UseCase를 통해 사용자 정보 로딩
        updateCurrentDateInfo()
        setupLocationManager()
        
        // 샌드위치 휴일 및 공휴일 데이터 로딩
        send(.loadSandwichHoliday)
        send(.loadHolidays)
        
        // 생일 데이터 로딩
        Task {
            await loadUserInfoAsync()
        }
    }
    
    private func updateCurrentDateInfo() {
        // TimeZone 고정
        let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        let now = Date()
        
        // 월 계산
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "ko_KR")
        monthFormatter.dateFormat = "M"
        monthFormatter.timeZone = koreaTimeZone
        state.currentMonth = monthFormatter.string(from: now)
        
        // 주차 계산
        var calendar = Calendar.current
        calendar.timeZone = koreaTimeZone
        let weekOfMonth = calendar.component(.weekOfMonth, from: now)
        
        let weekNames = ["첫째", "둘째", "셋째", "넷째", "다섯째", "여섯째"]
        state.currentWeekOfMonth = weekNames[weekOfMonth - 1]
    }
    
    private func handleVacationCardTapped(_ cardType: VacationCardType) {
        effect.send(.navigateToDetail(cardType))
    }
    
    private func handleRefreshData() {
        state.isLoading = true
        effect.send(.showLoading)
        
        Task {
            // 저장된 위치가 있으면 날씨 데이터 새로고침
            if state.savedLocation != nil || state.isLocationRegistered {
                await loadWeatherRecommendationsAsync()
            }
            
            await loadSandwichHolidayAsync()
            await loadHolidaysAsync()
            await loadUserInfoAsync()
            
            state.isLoading = false
            effect.send(.hideLoading)
        }
    }
    
    private func handleVacationBakingCompleted() {
        state.vacationBakingStatus = .processing
        
        // TODO: API 변경
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2초
            await MainActor.run {
                self.send(.vacationBakingProcessed)
            }
        }
    }
    
    private func handleVacationBakingProcessed() {
        state.vacationBakingStatus = .completed
    }
    
    private func handleRemainingAnnualLeaveLoaded(_ days: Int) {
        state.remainingAnnualLeave = days
    }
    
    private func handleLocationIconTapped() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // 위치 권한이 허용된 경우 - 새로운 위치 받기
            locationManager.refreshLocation()
            // 위치 변경 감지에서 자동으로 등록 처리됨
        case .denied, .restricted:
            // 위치 권한이 거부된 경우 - 설정 이동 팝업 표시
            effect.send(.showLocationSettingsAlert)
        case .notDetermined:
            // 위치 권한이 결정되지 않은 경우 - 권한 요청
            effect.send(.requestLocationPermission)
        default:
            break
        }
    }
    
    private func handleLocationPermissionChanged(_ status: LocationPermissionStatus) {
        let previousStatus = state.locationPermissionStatus
        state.locationPermissionStatus = status
        state.hasLocationPermission = (status == .authorizedWhenInUse || status == .authorizedAlways)
        
        // 권한이 거부된 경우 알림 표시 (이전 상태가 notDetermined일 때만)
        if (status == .denied || status == .restricted) && previousStatus == .notDetermined {
            effect.send(.showLocationPermissionDeniedAlert)
            // 권한이 거부되면 위치 등록 확인
            ensureLocationRegistered()
        }
    }
    
    private func handleRegisterLocation() {
        // 현재 위치가 있으면 사용, 없으면 디폴트 위치 사용
        let locationToRegister: LocationInfo
        if let currentLocation = state.currentLocation {
            locationToRegister = currentLocation
        } else {
            locationToRegister = locationManager.getDefaultLocation()
        }
        
        registerLocationAndLoadWeather(location: locationToRegister)
    }

    private func handleLoadWeatherRecommendations() {
        loadWeatherDataWithLocationCheck()
    }
    
    private func loadWeatherData() {
        state.isWeatherLoading = true
        Task {
            do {
                let weatherData = try await homeUseCase.getWeatherRecommendations()
                state.weatherRecommendations = weatherData
                state.isWeatherLoading = false
            } catch {
                state.isWeatherLoading = false
                effect.send(.showError("날씨 데이터를 가져오는데 실패했습니다."))
            }
        }
    }
    
    private func handleLoadSandwichHoliday() {
        state.isHolidayLoading = true
        Task {
            do {
                let sandwichHolidays = try await homeUseCase.getSandwichHoliday()
                state.sandwichHoliday = sandwichHolidays
                state.isHolidayLoading = false
                // 샌드위치 휴일 데이터 로드 후 카드 업데이트
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
    
    // MARK: - Async Loading Methods for Pull-to-Refresh
    
    private func loadWeatherRecommendationsAsync() async {
        await loadWeatherDataWithLocationCheckAsync()
    }
    
    private func loadWeatherDataAsync() async {
        state.isWeatherLoading = true
        do {
            let weatherData = try await homeUseCase.getWeatherRecommendations()
            state.weatherRecommendations = weatherData
            state.isWeatherLoading = false
        } catch {
            state.isWeatherLoading = false
            effect.send(.showError("날씨 데이터를 가져오는데 실패했습니다."))
        }
    }
    
    private func loadSandwichHolidayAsync() async {
        state.isHolidayLoading = true
        do {
            let sandwichHolidays = try await homeUseCase.getSandwichHoliday()
            state.sandwichHoliday = sandwichHolidays
            state.isHolidayLoading = false
            // 샌드위치 휴일 데이터 로드 후 카드 업데이트
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
            // 공휴일 데이터 로드 후 카드 업데이트
            updateShortCardsWithHolidayData()
        } catch {
            state.isHolidayLoading = false
            effect.send(.showError("공휴일 데이터를 가져오는데 실패했습니다."))
        }
    }
    
    private func handleSelectedDateChanged(_ date: Date) {
        // 선택된 날짜에 따라 카드 데이터 업데이트
        updateCardData(for: date)
    }
    
    private func updateCardData(for date: Date) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        // 월 이름 가져오기
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let monthName = dateFormatter.monthSymbols[month - 1]
        
        // 선택된 월의 데이터로 카드 업데이트
        state.shortCards = [
            VacationCardItem(dateString: "\(month)/00(\(monthName)) ~ \(month)/00(\(monthName))", type: .sandwich),
            VacationCardItem(dateString: "\(month)/00(\(monthName))", type: .birthday),
            VacationCardItem(dateString: "\(month)/00(\(monthName))", type: .holiday),
        ]
        
        // 실제 데이터로 카드 업데이트
        updateShortCardsWithHolidayData()
        updateShortCardsWithSandwichHolidayData()
        updateBirthdayCard()
        
        // TODO: 실제 API 호출로 해당 월의 데이터 가져오기
        // send(.loadSandwichHoliday)
        // send(.loadHolidays)
    }
    
    // MARK: - 카드 업데이트 공통 메서드
    private func updateShortCardsWithHolidayData() {
        updateCard(for: .holiday, data: state.holidays, defaultText: "공휴일 없음") { holidays in
            getNextUpcomingHoliday(from: holidays)
        }
    }
    
    private func updateShortCardsWithSandwichHolidayData() {
        print("🔥 샌드위치 휴일 \(state.sandwichHoliday)")
        
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
    
    // MARK: - 다음 공휴일 찾기 메서드
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
    
    // MARK: - 다음 샌드위치 휴일 찾기 메서드
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
    
    private func setupLocationManager() {
        // 위치 권한 상태 초기화
        state.locationPermissionStatus = locationManager.authorizationStatus
        state.hasLocationPermission = (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways)
        
        // 저장된 위치 정보 불러오기
        state.savedLocation = locationManager.getSavedLocation()
        
        // 저장된 위치가 있으면 위치 등록 상태 설정 및 날씨 데이터 요청
        if let savedLocation = state.savedLocation {
            state.currentLocation = savedLocation
            state.isLocationRegistered = true
            state.currentLocationAddress = savedLocation.address
            // 저장된 위치가 있으면 바로 날씨 데이터 요청
            loadWeatherData()
        } else {
            // 저장된 위치가 없으면 위치 등록 확인
            ensureLocationRegistered()
        }
        
        // 위치 권한 상태 변경 감지
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.send(.locationPermissionChanged(status))
            }
            .store(in: &cancellables)
        
        // 현재 위치 변경 감지 (사용자가 위치 아이콘을 탭했을 때만)
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                if let location = location {
                    self?.state.currentLocation = location
                    self?.state.savedLocation = location
                    
                    // 위치가 등록되어 있지 않을 때만 등록
                    if !(self?.state.isLocationRegistered ?? false) {
                        self?.registerLocationAndLoadWeather(location: location)
                    } else {
                        // 위치가 이미 등록되어 있으면 주소만 업데이트하고 날씨 데이터 새로고침
                        Task {
                            let updatedLocation = await self?.locationManager.updateLocationWithAddress(location)
                            self?.state.currentLocationAddress = updatedLocation?.address
                            self?.loadWeatherData()
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        // 앱 시작 시 위치 권한 요청 (notDetermined 상태인 경우)
        if locationManager.authorizationStatus == .notDetermined {
            // 권한 요청
            effect.send(.requestLocationPermission)
        } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            // 권한이 있지만 저장된 위치가 없으면 한 번만 받기
            if state.savedLocation == nil {
                locationManager.requestLocationOnce()
            }
        }
    }

    // MARK: - 위치 등록 및 날씨 데이터 로딩 통합 메서드
    
    private func registerLocationAndLoadWeather(location: LocationInfo) {
        Task {
            do {
                print("🌍 위치 등록 시작: \(location.coordinate)")
                try await homeUseCase.registerLocation(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                print("✅ 위치 등록 성공")
                state.isLocationRegistered = true
                
                // 주소 정보 업데이트
                let updatedLocation = await locationManager.updateLocationWithAddress(location)
                state.currentLocationAddress = updatedLocation.address
                
                // 위치 등록 완료 후 바로 날씨 데이터 로딩
                loadWeatherData()
            } catch {
                print("❌ 위치 등록 실패: \(error)")
                state.isLocationRegistered = false
                effect.send(.showError("위치 등록에 실패했습니다."))
            }
        }
    }
    
    // MARK: - 위치 및 날씨 데이터 통합 관리
    
    /// 위치 등록이 필요한지 확인하고 필요시 디폴트 위치로 등록
    private func ensureLocationRegistered() {
        guard !state.isLocationRegistered else { return }
        
        let locationToRegister = state.currentLocation ?? locationManager.getDefaultLocation()
        state.currentLocation = locationToRegister
        state.currentLocationAddress = locationToRegister.address
        registerLocationAndLoadWeather(location: locationToRegister)
    }
    
    /// 날씨 데이터 로딩 (위치 등록 상태 확인 포함)
    private func loadWeatherDataWithLocationCheck() {
        if state.isLocationRegistered {
            loadWeatherData()
        } else {
            ensureLocationRegistered()
        }
    }
    
    /// 날씨 데이터 로딩 (Async 버전)
    private func loadWeatherDataWithLocationCheckAsync() async {
        if state.isLocationRegistered {
            await loadWeatherDataAsync()
        } else {
            ensureLocationRegistered()
        }
    }
}

// MARK: - 생일 관련 기능 (Extension)
extension HomeStore {
    
    private func loadUserInfoAsync() async {
        state.isBirthdayLoading = true
        do {
            let userProfile = try await getUserProfileUseCase.execute()
            print("🔥 userProfile: \(userProfile)")

            // 생일 정보 저장
            state.userBirthday = userProfile.birthDate
            
            // 평균 열정온도 저장
            state.averageTemperature = userProfile.averageTemperature
            
            // 남은 연차 저장
            state.remainingAnnualLeave = Int(userProfile.remainingAnnualLeave)
            
            state.isBirthdayLoading = false
            
            updateBirthdayCard()
        } catch {
            state.isBirthdayLoading = false
            effect.send(.showError("사용자 정보를 가져오는데 실패했습니다."))
        }
    }
    
    private func updateBirthdayCard() {
        guard let birthday = state.userBirthday, !birthday.isEmpty else {
            updateCard(for: .birthday, data: [], defaultText: "생일 정보 없음") { _ in nil }
            return
        }
        
        if let nextBirthday = calculateNextBirthday(from: birthday) {
            let birthdayDateString = formatBirthdayDate(nextBirthday)
            state.nextBirthday = nextBirthday
            
            updateCard(for: .birthday, data: [nextBirthday], defaultText: "생일 정보 없음") { _ in
                BirthdayItem(date: nextBirthday, dateString: birthdayDateString)
            }
        } else {
            updateCard(for: .birthday, data: [], defaultText: "생일 정보 없음") { _ in nil }
        }
    }
    
    private func calculateNextBirthday(from birthDateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        if birthDateString.contains("-") {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = "yyyyMMdd"
        }
        
        guard let birthDate = dateFormatter.date(from: birthDateString) else {
            print("❌ 생년월일 파싱 실패: \(birthDateString)")
            return nil
        }
        
        let calendar = Calendar.current
        let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        var calendarWithTimezone = calendar
        calendarWithTimezone.timeZone = koreaTimeZone
        
        let today = Date()
        let currentYear = calendarWithTimezone.component(.year, from: today)
        let birthMonth = calendarWithTimezone.component(.month, from: birthDate)
        let birthDay = calendarWithTimezone.component(.day, from: birthDate)
        
        var thisYearBirthday = DateComponents()
        thisYearBirthday.year = currentYear
        thisYearBirthday.month = birthMonth
        thisYearBirthday.day = birthDay
        thisYearBirthday.timeZone = koreaTimeZone
        
        guard let thisYearBirthdayDate = calendarWithTimezone.date(from: thisYearBirthday) else {
            return nil
        }
        
        let comparison = calendarWithTimezone.compare(thisYearBirthdayDate, to: today, toGranularity: .day)
        
        if comparison == .orderedAscending {
            var nextYearBirthday = DateComponents()
            nextYearBirthday.year = currentYear + 1
            nextYearBirthday.month = birthMonth
            nextYearBirthday.day = birthDay
            nextYearBirthday.timeZone = koreaTimeZone
            
            return calendarWithTimezone.date(from: nextYearBirthday)
        } else {
            return thisYearBirthdayDate
        }
    }
    
    private func formatBirthdayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M/dd(E)"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - BirthdayItem (DateStringConvertible)
    private struct BirthdayItem: DateStringConvertible {
        let date: Date
        let dateString: String
    }
    
    // MARK: - 날씨 날짜 포맷팅
    func formatWeatherDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "M/dd(E)"
        return outputFormatter.string(from: date)
    }
}

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
}

extension HomeStore {
    
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
    
    var nextBirthday: Date? {
        return state.nextBirthday
    }
}

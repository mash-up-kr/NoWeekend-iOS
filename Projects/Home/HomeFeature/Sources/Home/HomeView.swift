//
//  HomeView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem
import Utils
import CalendarDomain
import DIContainer
import HomeDomain

public struct HomeView: View {
    @StateObject private var store = HomeStore()
    @EnvironmentObject private var coordinator: HomeCoordinator

    public init() {}
    
    @State private var currentLongCardPage: Int = 0
    @State private var currentShortCardPage: Int = 0
    @State private var selectedDate: Date = Date()
    
    // 위치권한 관련 알림 상태
    @State private var showLocationPermissionDeniedAlert = false
    @State private var showLocationSettingsAlert = false
    @State private var showDatePickerBottomSheet = false
    
    // 바텀시트 상태 추가
    @State private var showTextInputBottomSheet = false
    @State private var inputText = ""
    
    // 선택된 항목 정보 저장
    @State private var selectedHoliday: Holiday?
    @State private var selectedWeatherDate: String?
    @State private var selectedCardType: VacationCardType?
    
    // 에러 상태 추가
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    public var body: some View {
        ZStack(alignment: .top) {
            DS.Images.imgGradient
                .resizable()
                .frame(height: 260)
                .ignoresSafeArea(edges: .top)
                .zIndex(0)

            ScrollView {
                VStack(spacing: 0) {
                    MainTopView(
                        vacationBakingStatus: store.state.vacationBakingStatus,
                        averageTemperature: store.state.averageTemperature,
                        remainingAnnualLeave: store.state.remainingAnnualLeave,
                        onVacationBakingTapped: {
                            switch store.state.vacationBakingStatus {
                            case .notStarted:
                                coordinator.push(.bakingVacation)
                            case .completed:
                                coordinator.push(.recommendVaction)
                            case .processing:
                                break
                            }
                        }
                    )
                    .zIndex(1)
                    
                    VStack {
                        Spacer(minLength: 48)
                        if !store.state.holidays.isEmpty {
                            HolidayCardSection(
                                holidays: store.state.holidays,
                                onAddTapped: { holiday in
                                    selectedHoliday = holiday
                                    selectedWeatherDate = nil
                                    selectedCardType = nil
                                    inputText = ""
                                    showTextInputBottomSheet = true
                                }
                            )
                            .background(DS.Colors.Background.alternative01)
                        }
                        
                        Spacer(minLength: 48)
                        WeekVacation(
                            currentMonth: store.state.currentMonth,
                            currentWeekOfMonth: store.state.currentWeekOfMonth,
                            weatherData: store.state.weatherRecommendations,
                            isWeatherLoading: store.state.isWeatherLoading,
                            onLocationIconTapped: {
                                store.send(.locationIconTapped)
                            },
                            onWeatherRefresh: {
                                store.send(.loadWeatherRecommendations)
                            },
                            onWeatherPlusTapped: { weather in
                                selectedHoliday = nil
                                selectedWeatherDate = weather.localDate
                                selectedCardType = nil
                                inputText = ""
                                showTextInputBottomSheet = true
                            },
                            store: store
                        )
                        
                        Spacer(minLength: 48)
                        ShortCardSection(
                            currentPage: $currentShortCardPage,
                            selectedDate: $selectedDate,
                            cards: store.state.shortCards,
                            onCardTapped: { cardType in
                                store.send(.vacationCardTapped(cardType))
                            },
                            onDateButtonTapped: {
                                showDatePickerBottomSheet = true
                            },
                            onAddTapped: { cardType in
                                selectedHoliday = nil
                                selectedWeatherDate = nil
                                selectedCardType = cardType
                                inputText = ""
                                showTextInputBottomSheet = true
                            }
                        )
                        Spacer()
                    }
                    .background(DS.Colors.Background.normal)
                }
            }
            .refreshable {
                await refreshData()
            }
        }
        .onAppear {
            store.send(.viewDidLoad)
            coordinator.onVacationBakingCompleted = {
                store.send(.vacationBakingCompleted)
            }
        }
        .onChange(of: store.state.remainingAnnualLeave) { oldValue, newValue in
            coordinator.remainingAnnualLeave = newValue
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            store.send(.selectedDateChanged(newValue))
        }
        .onReceive(store.effect) { effect in
            handleEffect(effect)
        }
        .alert("", isPresented: $showLocationPermissionDeniedAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("위치정보를 설정하지 않아 임의 위치로 검색됩니다.")
        }
        .alert("GPS 권한 설정", isPresented: $showLocationSettingsAlert) {
            Button("취소", role: .cancel) { }
            Button("확인") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        } message: {
            Text("GPS 권한이 없습니다. 날씨 기반 휴가 추천을 하려면 GPS 권한이 필요합니다. 설정으로 이동하시겠습니까?")
        }
        .sheet(isPresented: $showDatePickerBottomSheet) {
            DatePickerWithLabelBottomSheet(selectedDate: $selectedDate)
        }
        .sheet(isPresented: $showTextInputBottomSheet) {
            TextInputBottomSheet(
                subtitle: "연차 제목을 작성하면\n할 일에 추가돼요",
                placeholder: "쓸래말래가 추천한 연차 ✈️",
                text: $inputText,
                isPresented: $showTextInputBottomSheet,
                onAddButtonTapped: {
                    Task {
                        await addScheduleToCalendar()
                    }
                }
            )
        }
    }
    
    // MARK: - 캘린더 일정 추가 메서드
    
    private func addScheduleToCalendar() async {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await MainActor.run {
                errorMessage = "제목을 입력해주세요"
                showErrorAlert = true
            }
            return
        }
        
        
        let calendarUseCase: CalendarUseCaseProtocol = DIContainer.shared.resolve(CalendarUseCaseProtocol.self)
        
        let targetDate = determineTargetDate()
        let scheduleCategory = determineScheduleCategory()
        
        do {
            let calendar = Calendar.current
            
            let startTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: targetDate) ?? targetDate
            let endTime = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: targetDate) ?? targetDate
            
            let createdSchedule = try await calendarUseCase.createSchedule(
                title: inputText.trimmingCharacters(in: .whitespacesAndNewlines),
                date: targetDate,
                startTime: startTime,
                endTime: endTime,
                category: scheduleCategory,
                temperature: 70,
                allDay: true,
                alarmOption: .none
            )
            
            await MainActor.run {
                
                showTextInputBottomSheet = false
                inputText = ""
                resetSelectedItems()
                
                switchToCalendarTab()
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "일정 추가에 실패했습니다: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
    
    private func determineTargetDate() -> Date {
        let calendar = Calendar.current
        
        if let holiday = selectedHoliday {
            return holiday.date
        }
        
        if let weatherDateString = selectedWeatherDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: weatherDateString) {
                return date
            }
        }
        
        if let cardType = selectedCardType {
            switch cardType {
            case .sandwich:
                if let sandwichHoliday = store.state.sandwichHoliday.first {
                    return sandwichHoliday.startDate
                }
            case .birthday:
                if let nextBirthday = store.state.nextBirthday {
                    return nextBirthday
                }
            case .holiday:
                if let holiday = store.state.holidays.first {
                    return holiday.date
                }
            default:
                break
            }
        }
        
        let today = Date()
        return today
    }
    
    private func determineScheduleCategory() -> ScheduleCategory {
        if let cardType = selectedCardType {
            switch cardType {
            case .birthday:
                return .personal
            case .holiday, .sandwich:
                return .leave
            default:
                return .personal
            }
        }
        
        if selectedHoliday != nil {
            return .leave
        }
        
        if selectedWeatherDate != nil {
            return .personal
        }
        
        return .personal
    }
    
    private func getDefaultTitleForCardType(_ cardType: VacationCardType) -> String {
        return ""
    }
    
    private func resetSelectedItems() {
        selectedHoliday = nil
        selectedWeatherDate = nil
        selectedCardType = nil
    }
    
    private func handleEffect(_ effect: HomeEffect) {
        switch effect {
        case .requestLocationPermission:
            LocationManager.shared.requestLocationPermission()
        case .openAppSettings:
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        case .showLocationPermissionDeniedAlert:
            showLocationPermissionDeniedAlert = true
        case .showLocationSettingsAlert:
            showLocationSettingsAlert = true
        case .showError(let message):
            print("Error: \(message)")
        case .navigateToDetail(let cardType):
            selectedCardType = cardType
            inputText = ""
            showTextInputBottomSheet = true
        case .showLoading:
            break
        case .hideLoading:
            break
        }
    }
    
    @MainActor
    private func refreshData() async {
        store.send(.refreshData)
    }
    
    private func switchToCalendarTab() {
        NotificationCenter.default.post(
            name: NSNotification.Name("SwitchToCalendarTab"),
            object: nil
        )
    }
}

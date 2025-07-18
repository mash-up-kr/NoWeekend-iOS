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
    @EnvironmentObject private var store: HomeStore
    @EnvironmentObject private var coordinator: HomeCoordinator

    public init() {}
    
    // Store state binding helper
    private var showTextInputBottomSheetBinding: Binding<Bool> {
        Binding(
            get: { store.state.showTextInputBottomSheet },
            set: { _ in store.send(.hideTextInputBottomSheet) }
        )
    }
    
    @State private var currentLongCardPage: Int = 0
    @State private var currentShortCardPage: Int = 0
    @State private var selectedDate: Date = Date()
    
    // 위치권한 관련 알림 상태
    @State private var showLocationPermissionDeniedAlert = false
    @State private var showLocationSettingsAlert = false
    @State private var showDatePickerBottomSheet = false
    
    // 바텀시트 상태 추가
    @State private var inputText = ""
    
    // 에러 상태 추가
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    

    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                MainTopView(
                    vacationBakingStatus: store.state.vacationBakingStatus,
                    averageTemperature: store.state.averageTemperature,
                    remainingAnnualLeave: store.state.remainingAnnualLeave,
                    vacationRecommendState: store.state.vacationRecommendState,
                    onVacationBakingTapped: {
                        switch store.state.vacationBakingStatus {
                        case .none:
                            coordinator.push(.bakingVacation)
                        case .ready:
                            if store.state.vacationRecommendState.status == .ready {
                                coordinator.push(.recommendVaction)
                            }
                        case .requesting:
                            break
                        case .failed:
                            // 다시 굽기 버튼 클릭 시 재시도
                            store.send(.retryVacationRecommend)
                        }
                    }
                )
                
                VStack {
                    Spacer(minLength: 48)
                    if !store.state.holidays.isEmpty {
                        HolidayCardSection(
                            holidays: store.state.holidays,
                            onAddTapped: { holiday in
                                let data = TextInputBottomSheetData(
                                    title: "",
                                    selectedHoliday: holiday
                                )
                                store.send(.showTextInputBottomSheet(data))
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
                            let data = TextInputBottomSheetData(
                                title: "",
                                selectedWeatherDate: weather.localDate
                            )
                            store.send(.showTextInputBottomSheet(data))
                        },
                        locationAddress: store.state.currentLocationAddress,
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
                            let data = TextInputBottomSheetData(
                                title: "",
                                selectedCardType: cardType
                            )
                            store.send(.showTextInputBottomSheet(data))
                        }
                    )
                    Spacer()
                }
                .background(DS.Colors.Background.normal)
            }
        }
        .ignoresSafeArea(edges: .top)
        .refreshable {
            await refreshData()
        }
        .onAppear {
            store.send(.viewDidLoad)
        }
        .onChange(of: store.state.textInputBottomSheetData) { oldValue, newValue in
            if let data = newValue {
                inputText = data.title
            } else {
                inputText = ""
            }
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
        .sheet(isPresented: showTextInputBottomSheetBinding) {
            TextInputBottomSheet(
                subtitle: "연차 제목을 작성하면\n할 일에 추가돼요",
                placeholder: "쓸래말래가 추천한 연차 ✈️",
                text: $inputText,
                isPresented: showTextInputBottomSheetBinding,
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
                store.send(.hideTextInputBottomSheet)
                inputText = ""
                switchToCalendarTab(with: targetDate)
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "일정 추가에 실패했습니다: \(error.localizedDescription)"
                showErrorAlert = true
            }
        }
    }
    
    private func determineTargetDate() -> Date {
        return store.getTargetDateForTextInput()
    }
    
    private func determineScheduleCategory() -> ScheduleCategory {
        return store.getScheduleCategoryForTextInput()
    }
    
    private func getDefaultTitleForCardType(_ cardType: VacationCardType) -> String {
        return ""
    }
    

    
    private func handleEffect(_ effect: HomeEffect) {
        switch effect {
        case .requestLocationPermission:
            LocationManager.shared.requestLocationPermission()
        case .showLocationPermissionDeniedAlert:
            showLocationPermissionDeniedAlert = true
        case .showLocationSettingsAlert:
            showLocationSettingsAlert = true
        case .showError(let message):
            print("Error: \(message)")
        case .navigateToDetail(let cardType):
            let data = TextInputBottomSheetData(
                title: "",
                selectedCardType: cardType
            )
            store.send(.showTextInputBottomSheet(data))
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
    
    private func switchToCalendarTab(with date: Date? = nil) {
        var userInfo: [String: Any] = [:]
        
        if let date = date {
            userInfo["selectedDate"] = date
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("SwitchToCalendarTab"),
            object: nil,
            userInfo: userInfo
        )
    }
}

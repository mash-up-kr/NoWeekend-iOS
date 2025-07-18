//
//  VacationScheduleModalView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/18/25.
//

import SwiftUI
import DesignSystem
import HomeDomain

struct VacationScheduleModalView: View {
    @StateObject private var store = VacationScheduleModalStore()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var homeStore: HomeStore
    let vacationRecommend: VacationRecommend
    
    var body: some View {
        VStack(spacing: 0) {
            // 타이틀 섹션
            if let scheduleData = store.state.scheduleData {
                titleSection(scheduleData.title)
                
                // 일정 내용 섹션
                contentSection(scheduleData.dailySchedules)
            }
            
            // 하단 버튼 섹션
            bottomButtonSection
        }
        .background(DS.Colors.Background.normal)
        .onAppear {
            store.send(.viewDidLoad(vacationRecommend))
        }
        .onReceive(store.effect) { effect in
            handleEffect(effect)
        }
    }
    
    // MARK: - View Components
    
    private func titleSection(_ title: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.heading3)
                .foregroundColor(DS.Colors.Text.netural)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.top, 32)
        .padding(.bottom, 32)
    }
    
    private func contentSection(_ dailySchedules: [DailyScheduleData]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(dailySchedules, id: \.day) { daySchedule in
                    VStack(alignment: .leading, spacing: 16) {
                        // 일차 제목
                        Text(daySchedule.dayTitle)
                            .font(.heading5)
                            .foregroundColor(DS.Colors.Text.netural)
                        
                        // 일정 항목들
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(daySchedule.activities, id: \.self) { activity in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .font(.body2)
                                        .foregroundColor(DS.Colors.Text.body)
                                    
                                    Text(activity)
                                        .font(.body2)
                                        .foregroundColor(DS.Colors.Text.body)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    private var bottomButtonSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 16) {
                Button(action: {
                    store.send(.rejectButtonTapped)
                }) {
                    Text("말래")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.netural)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(DS.Colors.Neutral.gray200)
                        .cornerRadius(16)
                }
                .padding(.vertical, 8)
                
                Button(action: {
                    let data = TextInputBottomSheetData(
                        title: vacationRecommend.title,
                        selectedVacationRecommend: vacationRecommend
                    )
                    homeStore.send(.showTextInputBottomSheet(data))
                    // 모달 닫기
                    dismiss()
                }) {
                    Text("쓸래")
                        .font(.body1)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(DS.Colors.Toast._600)
                        .cornerRadius(16)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 24)
        }
        .background(DS.Colors.Neutral.white)
    }
    
    private func handleEffect(_ effect: VacationScheduleModalEffect) {
        switch effect {
        case .acceptSchedule:
            dismiss()
        case .rejectSchedule:
            dismiss()
        case .dismissModal:
            dismiss()
        case .showError(let message):
            print("Error: \(message)")
        }
    }
}

#Preview {
    VacationScheduleModalView(
        vacationRecommend: VacationRecommend(
            title: "도쿄 2박 3일 추천코스",
            content: "• Day 1 (07/07 월) - Day 3 of 5\n\n1. Morning: 집→세종문화회관, 지하철 5호선, 08:30 출발\n2. Morning activity: 세종문화회관 뮤지컬 '팬텀' 관람, 도보 이동·10분\n3. Lunch: 세븐스도어(컨템포러리 요리 전문점, 창의적 코스 요리), 종로",
            iconStyle: "STAR",
            startDate: "2025-07-07",
            endDate: "2025-07-09"
        )
    )
} 

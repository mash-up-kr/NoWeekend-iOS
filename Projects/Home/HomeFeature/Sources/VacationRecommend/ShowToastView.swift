//
//  ShowToastView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/12/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem
import HomeDomain

struct ShowToastView: View {
    @State private var isToastAnimated = false
    @State private var showScheduleModal = false
    @EnvironmentObject private var coordinator: HomeCoordinator
    @EnvironmentObject private var homeStore: HomeStore
    
    private var vacationRecommend: VacationRecommend? {
        homeStore.state.vacationRecommendState.recommendation
    }
    
    private var toastText: String {
        vacationRecommend?.title ?? "휴가 추천을 준비중입니다"
    }
    
    private var dateText: String {
        guard let recommendation = vacationRecommend else { return "날짜 정보 없음" }
        return homeStore.formatVacationRecommendDate(recommendation)
    }

    private var iconStyle: String {
        vacationRecommend?.iconStyle ?? "STAR"
    }

    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    type: .backOnly,
                    onBackTapped: {
                        coordinator.popToRoot()
                    }
                )
                
                Spacer()
                
                if !isToastAnimated {
                    LoadingContentView()
                } else {
                    BalloonView(
                        dateText: dateText,
                        onPlusTapped: {
                            let data = TextInputBottomSheetData(
                                title: vacationRecommend?.title ?? "",
                                selectedVacationRecommend: vacationRecommend
                            )
                            homeStore.send(.showTextInputBottomSheet(data))
                        }
                    )
                    .padding(.top, 20)
                }
                
                // 토스트 뷰 항상 렌더링
                ToastView(
                    isAnimated: isToastAnimated,
                    toastMessage: toastText,
                    iconStyle: iconStyle
                )
                
                if isToastAnimated {
                    Button(action: {
                        showScheduleModal = true
                    }) {
                        showPlanView()
                    }
                    .padding(.top, 20)
                    .buttonStyle(PlainButtonStyle())
                }
            
                
                Spacer()
                DS.Images.imgToaster
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                isToastAnimated = true
            }
        }
        .sheet(isPresented: $showScheduleModal) {
            if let recommendation = vacationRecommend {
                VacationScheduleModalView(vacationRecommend: recommendation)
            }
        }
    }
}

struct LoadingContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("휴가가 구워졌어요")
                .font(.heading4)
                .foregroundColor(DS.Colors.Text.netural)
            LottieView(type: JSONFiles.Loading.self)
                .frame(width: 200, height: 45)
                .padding(.top, 16)
        }
    }
}

struct ToastView: View {
    let isAnimated: Bool
    let toastMessage: String
    let iconStyle: String

    @State private var offsetY: CGFloat = 197  // 260 - 63 = 197 (토스트 높이에서 보이고 싶은 부분 빼기)

    var body: some View {
        ZStack {
            getToastImage(for: iconStyle)
                .resizable()
                .scaledToFit()
            
            Text(toastMessage)
                .font(.heading3)
                .foregroundColor(DS.Colors.Toast._500)
                .multilineTextAlignment(.center)
                .truncationMode(.tail)
                .padding(.top, 136)
                .padding(.bottom, 20)
                .padding(.leading, 48)
                .padding(.trailing, 62)
        }
        .offset(y: offsetY)
        .frame(width: 260, height: 260)
        .onAppear {
            animateToast(animated: isAnimated)
        }
        .onChange(of: isAnimated) {
            animateToast(animated: isAnimated)
        }
    }
    
    private func animateToast(animated: Bool) {
        if animated {
            withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                offsetY = 0
            }
        } else {
            offsetY = 197  // 초기 위치: 63만큼만 보이게
        }
    }
    
    private func getToastImage(for iconStyle: String) -> Image {
        switch iconStyle {
        case "STAR":
            return DS.Images.imgToasterGood
        case "TRAIN":
            return DS.Images.imgToasterTrip
        case "PLANE":
            return DS.Images.imgToasterTrip
        case "HOUSE":
            return DS.Images.imgToasterHome
        default:
            return DS.Images.imgToasterGood  // 기본 이미지
        }
    }
}

struct BalloonView: View {
    let dateText: String
    let onPlusTapped: () -> Void
    
    var body: some View {
        ZStack {
            // 말풍선 배경 이미지
            DS.Images.imgBubble
                .resizable()
                .frame(width: 218, height: 65)
            
            HStack(spacing: 8) {
                Text(dateText)
                    .font(.heading6)
                    .foregroundColor(DS.Colors.Text.netural)
                Button(action: onPlusTapped) {
                    DS.Images.icnPlus
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 16)
            .padding(.bottom, 25)
        }
    }
}

struct showPlanView: View {
    
    var body: some View {
        HStack(spacing: 0) {
            Text("일정 볼래말래")
                .font(.body1)
                .foregroundColor(DS.Colors.Neutral.gray900)
            
            DS.Images.icnChevronRight
        }
        .frame(height: 24)
    }
}

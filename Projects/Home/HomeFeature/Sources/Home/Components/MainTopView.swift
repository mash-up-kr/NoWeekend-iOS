//
//  HomeView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem
import HomeDomain

struct MainTopView: View {
    let vacationBakingStatus: VacationBakingStatus
    let averageTemperature: Double
    let remainingAnnualLeave: Int
    let vacationRecommendState: VacationRecommendState
    let onVacationBakingTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                DS.Images.imgGradient
                    .resizable()
                    .frame(height: 310)
                    .ignoresSafeArea(edges: .top)
                    .zIndex(0)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("오늘 연차쓸래?")
                            .font(.heading4)
                            .foregroundColor(DS.Colors.Text.netural)
                            .padding(.leading, 26)
                            .padding(.bottom, 8)
                        Spacer()
                    }
                    .padding(.top, getSafeAreaTop() + 16)
                    .padding(.bottom, 32)
                    
                    HStack(spacing: 4) {
                        Text("평균 열정온도:")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Text.body)
                        Text("\(Int(averageTemperature))°C")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Toast._600)
                    }
                    .padding(.bottom, 4)
                    
                    Text(vacationBakingStatus.titleText)
                        .font(.heading4)
                        .foregroundColor(DS.Colors.Text.netural)
                    
                    let mainImage = vacationBakingStatus == .requesting ? DS.Images.imgMainToasting : DS.Images.imageMain
                    mainImage
                        .resizable()
                        .frame(width: 140, height: 140)
                        .padding(.vertical, 16)
                    
                    Button(action: onVacationBakingTapped) {
                        Text(getButtonText())
                            .font(.body1)
                            .foregroundColor(getButtonTextColor())
                            .frame(width: 200, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(getButtonBackgroundColor())
                            )
                    }
                    .disabled(!getButtonEnabled())
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private func getSafeAreaTop() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 47
        }
        return window.safeAreaInsets.top
    }
    
    private func getButtonText() -> String {
        switch vacationBakingStatus {
        case .none:
            return "최대 \(remainingAnnualLeave)일 휴가 굽기"
        case .requesting:
            return "휴가 굽는중"
        case .ready:
            return "휴가 쓸래말래?"
        case .failed:
            return "다시 굽기"
        }
    }
    
    private func getButtonEnabled() -> Bool {
        switch vacationBakingStatus {
        case .none:
            return true
        case .requesting:
            return false
        case .ready, .failed:
            return true
        }
    }
    
    private func getButtonTextColor() -> Color {
        return getButtonEnabled() ? .white : DS.Colors.Text.body
    }
    
    private func getButtonBackgroundColor() -> Color {
        return getButtonEnabled() ? DS.Colors.Toast._600 : DS.Colors.Neutral.gray700
    }
} 

//
//  HomeView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct MainTopView: View {
    let vacationBakingStatus: VacationBakingStatus
    let averageTemperature: Double
    let remainingAnnualLeave: Int
    let onVacationBakingTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("오늘 연차쓸래?")
                    .font(.heading4)
                    .foregroundColor(DS.Colors.Text.netural)
                    .padding(.leading, 26)
                    .padding(.bottom, 8)
                Spacer()
            }
            .padding(.top, 16)
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
            
            let mainImage = vacationBakingStatus == .processing ? DS.Images.imgMainToasting : DS.Images.imageMain
            mainImage
                .resizable()
                .frame(width: 140, height: 140)
                .padding(.vertical, 16)
            
            Button(action: onVacationBakingTapped) {
                Text(getButtonText())
                    .font(.body1)
                    .foregroundColor(vacationBakingStatus.isButtonEnabled ? .white : DS.Colors.Text.body)
                    .frame(width: 200, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(vacationBakingStatus.isButtonEnabled ? DS.Colors.Toast._600 : DS.Colors.Neutral.gray700)
                    )
            }
            .disabled(!vacationBakingStatus.isButtonEnabled)
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func getButtonText() -> String {
        switch vacationBakingStatus {
        case .notStarted:
            return "최대 \(remainingAnnualLeave)일 휴가 굽기"
        case .processing:
            return "휴가 굽는중"
        case .completed:
            return "휴가 쓸래말래?"
        }
    }
} 

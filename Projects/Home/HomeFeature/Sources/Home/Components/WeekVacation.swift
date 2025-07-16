//
//  WeekVacation.swift
//  HomeFeature
//
//  Created by 김나희 on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem
import HomeDomain

struct WeekVacation: View {
    let currentMonth: String
    let currentWeekOfMonth: String
    let weatherData: [Weather]
    let isWeatherLoading: Bool
    let onLocationIconTapped: () -> Void
    let onWeatherRefresh: () -> Void
    let onWeatherPlusTapped: (Weather) -> Void
    let locationAddress: String?

    @ObservedObject var store: HomeStore
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(currentMonth)월 \(currentWeekOfMonth)주 휴가를 추천드려요")
                        .font(.heading5)
                    
                    if let address = locationAddress {
                        Text(address)
                            .font(.body2)
                            .foregroundColor(DS.Colors.Text.disable)
                    }
                }
                
                Spacer()
                Button(action: onLocationIconTapped) {
                    DS.Images.icnLocation
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 24)
            
            WeekCalendarView(cellContent: { date in
                store.calendarCellContent(for: date)
                    .frame(width: 38)
            })
            
            if !weatherData.isEmpty || isWeatherLoading {
                WeatherSection(
                    weatherData: weatherData,
                    isLoading: isWeatherLoading,
                    onPlusTapped: onWeatherPlusTapped,
                    formatDate: store.formatWeatherDate
                )
            }
        }
        .task {
            await store.loadWeeklySchedules()
        }
    }
}

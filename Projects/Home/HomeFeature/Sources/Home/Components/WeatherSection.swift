//
//  WeatherSection.swift
//  HomeFeature
//
//  Created by 김나희 on 2025/07/13.
//

import SwiftUI
import DesignSystem
import HomeDomain

struct WeatherSection: View {
    let weatherData: [Weather]
    let isLoading: Bool
    let onPlusTapped: (Weather) -> Void
    let formatDate: (String) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isLoading {
                ProgressView()
            } else if weatherData.isEmpty {
                Text("위치를 등록하면 날씨 기반 휴가를 추천해드려요")
                    .font(.body2)
                    .foregroundColor(DS.Colors.Text.disable)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(weatherData) { weather in
                        WeatherItemView(
                            weather: weather,
                            onPlusTapped: { onPlusTapped(weather) },
                            formatDate: formatDate
                        )
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .background(DS.Colors.Neutral.white)
    }
}

struct WeatherItemView: View {
    let weather: Weather
    let onPlusTapped: () -> Void
    let formatDate: (String) -> String

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDate(weather.localDate))
                    .font(.subtitle1)
                    .foregroundColor(DS.Colors.Text.body)
                Text(weather.recommendContent)
                    .font(.heading6)
                    .foregroundColor(DS.Colors.Text.netural)
            }
            
            Spacer()
            
            Button(action: onPlusTapped) {
                DS.Images.icnPlus
                    .foregroundColor(DS.Colors.Text.body)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.leading, 16)
        .padding(.trailing, 23)
        .padding(.vertical, 12)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(DS.Colors.Border.border01),
            alignment: .bottom
        )
        .background(DS.Colors.Neutral.white)
    }
}

#Preview {
    WeatherSection(
        weatherData: [
            Weather(id: "1", localDate: "2025-07-16", recommendContent: "오전 8시부터 9시, 11시부터 12시, 그리고 오후 5시부터 8시까지 총 5시간 동안 비가 와요. 연차 어떠세요?"),
            Weather(id: "2", localDate: "2025-07-17", recommendContent: "오전 7시부터 오후 5시까지 총 10시간 동안 비가 와요. 연차 쓰는 게 좋을 것 같아요.")
        ],
        isLoading: false,
        onPlusTapped: { _ in },
        formatDate: { dateString in
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
    )
}

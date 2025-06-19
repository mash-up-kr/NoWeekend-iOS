//
//  CalendarNavigationBar.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct CalendarNavigationBar: View {
    @State private var selectedToggle: ToggleOption = .week
    
    public enum ToggleOption: String, CaseIterable {
        case week = "주"
        case month = "월"
    }
    
    public let onDateTapped: (() -> Void)?
    public let onToggleChanged: ((ToggleOption) -> Void)?
    
    public init(
        onDateTapped: (() -> Void)? = nil,
        onToggleChanged: ((ToggleOption) -> Void)? = nil
    ) {
        self.onDateTapped = onDateTapped
        self.onToggleChanged = onToggleChanged
    }
    
    public var body: some View {
        HStack {
            Button(action: { onDateTapped?() }) {
                HStack(spacing: 4) {
                    Text("2025년 5월")
                        .font(.heading4)
                        .foregroundColor(.black)
                    Image(.icnCaretDown)
                }
            }
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(DS.Colors.Neutral._200)
                    .frame(width: 72, height: 38)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 32, height: 32)
                    .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 0)
                    .offset(x: selectedToggle == .week ? -16 : 16)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: selectedToggle)
                
                HStack(spacing: 0) {
                    ForEach(ToggleOption.allCases, id: \.self) { option in
                        Button(action: {
                            selectedToggle = option
                            onToggleChanged?(option)
                        }) {
                            Text(option.rawValue)
                                .font(.heading6)
                                .foregroundColor(selectedToggle == option ? DS.Colors.Neutral._900 : DS.Colors.Neutral._700)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
            }
        }
        .calendarNavigationBarStyle()
    }
}

private extension View {
    func calendarNavigationBarStyle() -> some View {
        self
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color(.systemBackground))
    }
}

// MARK: - Preview
#Preview {
    CalendarNavigationBar(
        onDateTapped: {
            print("날짜 버튼 클릭")
        },
        onToggleChanged: { toggle in
            print("토글 변경: \(toggle.rawValue)")
        }
    )
    .background(Color.white)
}

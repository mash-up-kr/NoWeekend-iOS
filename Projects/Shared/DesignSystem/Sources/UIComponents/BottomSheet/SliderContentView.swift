//
//  SliderContentView.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - 커스텀 드래그 인디케이터 뷰
struct CustomDragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.4))
            .frame(width: 34, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .frame(height: 21)
    }
}

// MARK: - 슬라이더 컨텐츠 뷰
struct SliderContentView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    
    var body: some View {
        VStack(spacing: 40) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    HStack {
                        Text("1일")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("3일")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("5일")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("7일 이상")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 4)
                    
                    Slider(value: $value, in: range)
                        .accentColor(Color(red: 255/255, green: 93/255, blue: 0/255))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 텍스트 입력 컨텐츠 뷰
struct TextInputContentView: View {
    let subtitle: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("연차 제목을 작성하면\n할 일에 추가돼요")
                .font(.heading4)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            TextField(placeholder, text: $text)
                .font(.body1)
                .foregroundStyle(DS.Colors.Neutral._700)
                .padding(.top, 24)
                .padding(.bottom, 12)
                .background(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(DS.Colors.Border.gray200)
                    }
                )
        }
        .padding(.horizontal, 20)
        Spacer()
    }
}

// MARK: - 레이블 있는 연월 피커 컨텐츠 뷰
struct MonthPickerWithLabelContentView: View {
    @Binding var selectedMonth: Date
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("확인하고 싶은")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("휴가 날짜를 선택해주세요")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            
            DatePicker("", selection: $selectedMonth, displayedComponents: [.date])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "en_US"))
                .environment(\.calendar, Calendar(identifier: .gregorian))
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 레이블 없는 연월 피커 컨텐츠 뷰
struct MonthPickerOnlyContentView: View {
    @Binding var selectedMonth: Date
    
    var body: some View {
        DatePicker("", selection: $selectedMonth, displayedComponents: [.date])
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "en_US"))
            .environment(\.calendar, Calendar(identifier: .gregorian))
            .padding(.horizontal, 20)
    }
}

// MARK: - 할 일 수정 컨텐츠 뷰
struct TaskEditContentView: View {
    let onEditAction: () -> Void
    let onTomorrowAction: () -> Void
    let onDeleteAction: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                onEditAction()
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(.icnEdit)
                    
                    Text(" 할 일 수정")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    Spacer()
                }
                .frame(height: 56)
            }
            
            // 내일 또 하기
            Button(action: {
                onTomorrowAction()
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(.icnArrowForward)
                    
                    Text("내일 또 하기")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    Spacer()
                }
                .frame(height: 56)
            }
            
            Button(action: {
                onDeleteAction()
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(.icnDelete)
                    
                    Text("삭제하기")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    Spacer()
                }
                .frame(height: 56)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 삭제 확인 컨텐츠 뷰
struct DeleteContentView: View {
    let message: String
    let onDeleteAction: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(.icnEdit)
                    
                    Text("할일 수정")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    Spacer()
                }
                .frame(height: 56)
            }
            
            Button(action: {
                onDeleteAction()
                isPresented = false
            }) {
                HStack(spacing: 8) {
                    Image(.icnDelete)
                    
                    Text("삭제")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    Spacer()
                }
                .frame(height: 56)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 개별 바텀시트 뷰들 (커스텀 드래그 인디케이터 적용)
struct SliderBottomSheetView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            SliderContentView(
                title: title,
                value: $value,
                range: range,
                unit: unit
            )
        }
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}

struct TextInputBottomSheetView: View {
    let subtitle: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            TextInputContentView(
                subtitle: subtitle,
                placeholder: placeholder,
                text: $text
            )
        }
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}

struct DatePickerWithLabelBottomSheetView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            MonthPickerWithLabelContentView(selectedMonth: $selectedDate)
        }
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}

struct DatePickerOnlyBottomSheetView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            MonthPickerOnlyContentView(selectedMonth: $selectedDate)
        }
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}

struct TaskEditBottomSheetView: View {
    let onEditAction: () -> Void
    let onTomorrowAction: () -> Void
    let onDeleteAction: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            TaskEditContentView(
                onEditAction: onEditAction,
                onTomorrowAction: onTomorrowAction,
                onDeleteAction: onDeleteAction,
                isPresented: $isPresented
            )
            
            Spacer()
        }
        .presentationDetents([.height(192)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}

struct DeleteBottomSheetView: View {
    let message: String
    let onDeleteAction: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            DeleteContentView(
                message: message,
                onDeleteAction: onDeleteAction,
                isPresented: $isPresented
            )
            Spacer()
        }
        .presentationDetents([.height(136)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}

#Preview {
    BottomSheetExampleView()
}

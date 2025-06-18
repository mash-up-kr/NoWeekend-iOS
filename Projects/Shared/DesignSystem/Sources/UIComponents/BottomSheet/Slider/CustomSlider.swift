//
//  CustomSlider.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 커스텀 슬라이더 뷰
public struct CustomSlider: View {
    @Binding public var value: Double
    public let range: ClosedRange<Double>
    public let labels: [String]
    
    @State private var isDragging: Bool = false
    
    private let thumbSize: CGFloat = 24
    private let trackHeight: CGFloat = 6
    private let activeTrackHeight: CGFloat = 8
    private let horizontalPadding: CGFloat = 12
    
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        labels: [String]
    ) {
        self._value = value
        self.range = range
        self.labels = labels
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            sliderTrack
            sliderLabels
        }
    }
    
    private var sliderTrack: some View {
        GeometryReader { geometry in
            let sliderInfo = calculateSliderInfo(geometry: geometry)
            
            ZStack(alignment: .leading) {
                backgroundTrack
                activeTrack(width: sliderInfo.activeTrackWidth)
                thumb(position: sliderInfo.thumbPosition, geometry: geometry)
            }
        }
        .frame(height: thumbSize)
    }
    
    private var sliderLabels: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width - (horizontalPadding * 2)
            
            ZStack {
                ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .position(x: calculateLabelPosition(index: index, trackWidth: trackWidth), y: 9)
                }
            }
        }
        .frame(height: 18)
    }
    
    private var backgroundTrack: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.3)) // TODO: 색상수정
            .frame(height: trackHeight)
            .padding(.horizontal, horizontalPadding)
    }
    
    private func activeTrack(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.blue) // TODO: 색상수정
            .frame(width: width, height: activeTrackHeight)
            .padding(.leading, horizontalPadding)
    }
    
    private func thumb(position: CGFloat, geometry: GeometryProxy) -> some View {
        Circle()
            .frame(width: thumbSize, height: thumbSize)
            .position(x: position, y: thumbSize / 2)
            .gesture(
                DragGesture()
                    .onChanged { handleDrag($0, geometry: geometry) }
                    .onEnded { _ in handleDragEnd() }
            )
    }
}

// MARK: - 계산 로직
extension CustomSlider {
    
    // 슬라이더 정보를 계산하는 구조체
    struct SliderInfo {
        let thumbPosition: CGFloat
        let activeTrackWidth: CGFloat
    }
    
    // 슬라이더 관련 계산을 한 곳에 모음
    private func calculateSliderInfo(geometry: GeometryProxy) -> SliderInfo {
        let trackWidth = geometry.size.width - (horizontalPadding * 2)
        let progress = calculateProgress() // 0.0 ~ 1.0
        let thumbOffset = trackWidth * progress
        let thumbPosition = horizontalPadding + thumbOffset
        let activeTrackWidth = thumbOffset + horizontalPadding
        
        return SliderInfo(
            thumbPosition: thumbPosition,
            activeTrackWidth: activeTrackWidth
        )
    }
    
    // 현재 값을 0~1 사이의 진행률로 변환
    private func calculateProgress() -> Double {
        return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    // 라벨 위치 계산
    private func calculateLabelPosition(index: Int, trackWidth: CGFloat) -> CGFloat {
        let totalSteps = Double(labels.count - 1)
        let stepProgress = Double(index) / totalSteps
        return horizontalPadding + (trackWidth * stepProgress)
    }
    
    // 드래그 처리
    private func handleDrag(_ gesture: DragGesture.Value, geometry: GeometryProxy) {
        isDragging = true
        
        let trackWidth = geometry.size.width - (horizontalPadding * 2)
        let dragPosition = gesture.location.x
        
        // 드래그 위치를 트랙 범위 내로 제한
        let clampedPosition = max(horizontalPadding, min(geometry.size.width - horizontalPadding, dragPosition))
        
        // 진행률 계산 (0.0 ~ 1.0)
        let progress = (clampedPosition - horizontalPadding) / trackWidth
        
        // 새로운 값 계산
        let newValue = range.lowerBound + progress * (range.upperBound - range.lowerBound)
        value = max(range.lowerBound, min(range.upperBound, newValue))
    }
    
    // 드래그 종료 처리
    private func handleDragEnd() {
        isDragging = false
        value = round(value) // 정수값으로 반올림
    }
}

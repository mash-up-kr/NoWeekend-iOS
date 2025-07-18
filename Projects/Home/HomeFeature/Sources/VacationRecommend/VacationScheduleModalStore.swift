//
//  VacationScheduleModalStore.swift
//  HomeFeature
//
//  Created by 김나희 on 7/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Combine
import Foundation
import HomeDomain

@MainActor
final class VacationScheduleModalStore: ObservableObject {
    @Published private(set) var state = VacationScheduleModalState()
    let effect = PassthroughSubject<VacationScheduleModalEffect, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ intent: VacationScheduleModalIntent) {
        switch intent {
        case .viewDidLoad(let vacationRecommend):
            handleViewDidLoad(vacationRecommend)
            
        case .acceptButtonTapped:
            handleAcceptButtonTapped()
            
        case .rejectButtonTapped:
            handleRejectButtonTapped()
            
        case .dismissModal:
            handleDismissModal()
        }
    }
    
    private func handleViewDidLoad(_ vacationRecommend: VacationRecommend) {
        state.isLoading = true
        state.errorMessage = nil
        
        // 파싱 로직 실행
        let scheduleData = VacationScheduleData.parse(from: vacationRecommend)
        
        state.scheduleData = scheduleData
        state.isLoading = false
    }
    
    private func handleAcceptButtonTapped() {
        effect.send(.acceptSchedule)
    }
    
    private func handleRejectButtonTapped() {
        effect.send(.rejectSchedule)
        effect.send(.dismissModal)
    }
    
    private func handleDismissModal() {
        effect.send(.dismissModal)
    }
} 
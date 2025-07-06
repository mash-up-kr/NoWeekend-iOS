//
//  CalendarCoordinatorView.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct CalendarCoordinatorView: View {
    @StateObject private var coordinator = CalendarCoordinator()
    
    public init() {
        print("📅 CalendarCoordinatorView 초기화")
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.view(.main)
                .navigationDestination(for: CalendarRouter.Screen.self) { screen in
                    coordinator.view(screen)
                        .environmentObject(coordinator)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    NavigationView {
                        coordinator.presentView(sheet)
                            .environmentObject(coordinator)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("닫기") {
                                        coordinator.dismissSheet()
                                    }
                                }
                            }
                    }
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                    coordinator.fullCoverView(cover)
                        .environmentObject(coordinator)
                }
        }
        .environmentObject(coordinator)
    }
}

//
//  HomeCoordinatorView.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct HomeCoordinatorView: View {
    @StateObject private var coordinator = HomeCoordinator()
    @StateObject private var homeStore = HomeStore()
    
    public init() {
        print("🏠 HomeCoordinatorView 초기화")
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.view(.main)
                .environmentObject(coordinator)
                .environmentObject(homeStore)
                .navigationDestination(for: HomeRouter.Screen.self) { screen in
                    coordinator.view(screen)
                        .environmentObject(coordinator)
                        .environmentObject(homeStore)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    NavigationView {
                        coordinator.presentView(sheet)
                            .environmentObject(coordinator)
                            .environmentObject(homeStore)
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
                        .environmentObject(homeStore)
                }
        }
    }
}

#Preview {
    HomeCoordinatorView()
}

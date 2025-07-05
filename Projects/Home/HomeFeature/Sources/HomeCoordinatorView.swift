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
    
    public init() {
        print("🏠 HomeCoordinatorView 초기화")
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.view(.main)
                .navigationDestination(for: HomeRouter.Screen.self) { screen in
                    coordinator.view(screen)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    NavigationView {
                        coordinator.presentView(sheet)
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
                }
        }
    }
}

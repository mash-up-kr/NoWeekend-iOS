//
//  AppCoordinatorView.swift
//  App
//
//  Created by 김시종 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

@MainActor
public struct AppCoordinatorView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.view(coordinator.rootScreen)
                .navigationBarHidden(true)
                .navigationDestination(for: AppRouter.Screen.self) { screen in
                    coordinator.view(screen)
                        .environmentObject(coordinator)
                        .navigationBarHidden(true)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    NavigationView {
                        coordinator.presentView(sheet)
                            .environmentObject(coordinator)
                    }
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                    coordinator.fullCoverView(cover)
                        .environmentObject(coordinator)
                }
        }
        .navigationBarHidden(true)
        .transition(
            coordinator.transitionDirection == .forward
                ? .rightToLeft
                : .leftToRight
        )
        .animation(.easeInOut(duration: 0.3), value: coordinator.rootScreen)
        .animation(.easeInOut(duration: 0.1), value: coordinator.transitionDirection)
    }
}

extension AnyTransition {
    static var rightToLeft: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var leftToRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }
}

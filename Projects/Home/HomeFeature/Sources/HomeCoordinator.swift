//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Core

public final class HomeCoordinator: ObservableObject, Coordinatorable {
    public typealias Screen = HomeRouter.Screen
    public typealias SheetScreen = HomeRouter.Sheet
    public typealias FullScreen = HomeRouter.FullScreen
    
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var sheet: SheetScreen?
    @Published public var fullScreenCover: FullScreen?
    
    public init() {}
    
    @ViewBuilder
    public func view(_ screen: Screen) -> some View {
        switch screen {
        case .main:
            HomeView()
        }
    }
    
    @ViewBuilder
    public func presentView(_ sheet: SheetScreen) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    public func fullCoverView(_ cover: FullScreen) -> some View {
        EmptyView()
    }
}

public enum HomeRouter {
    public enum Screen: Hashable {
        case main
    }
    
    public enum Sheet: String, Identifiable {
        case dummy
        public var id: String { self.rawValue }
    }
    
    public enum FullScreen: String, Identifiable {
        case dummy
        public var id: String { self.rawValue }
    }
}

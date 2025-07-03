//
//  ProfileCoordinator.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Core

@Observable
public final class ProfileCoordinator: Coordinatorable {
    public typealias Screen = ProfileRouter.Screen
    public typealias SheetScreen = ProfileRouter.Sheet
    public typealias FullScreen = ProfileRouter.FullScreen
    
    public var path: NavigationPath = NavigationPath()
    public var sheet: SheetScreen?
    public var fullScreenCover: FullScreen?
    
    public init() {
        print("🧭 ProfileCoordinator 생성")
    }
    
    @ViewBuilder
    public func view(_ screen: Screen) -> some View {
        switch screen {
        case .main:
            ProfileView()
        case .profileEdit:
            ProfileEditView()
        case .settings:
            SettingsView()
        }
    }
    
    @ViewBuilder
    public func presentView(_ sheet: SheetScreen) -> some View {
        switch sheet {
        case .themeSelector:
            ThemeSelectorView()
        }
    }
    
    @ViewBuilder
    public func fullCoverView(_ cover: FullScreen) -> some View {
        switch cover {
        case .about:
            AboutView()
        }
    }
}

public enum ProfileRouter {
    public enum Screen: Hashable {
        case main
        case profileEdit
        case settings
    }
    
    public enum Sheet: String, Identifiable {
        case themeSelector
        public var id: String { self.rawValue }
    }
    
    public enum FullScreen: String, Identifiable {
        case about
        public var id: String { self.rawValue }
    }
}

// MARK: - 임시 뷰들
struct ProfileEditView: View {
    var body: some View {
        VStack {
            Text("✏️ 프로필 편집")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("프로필 편집 화면입니다.")
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("⚙️ 설정")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("설정 화면입니다.")
                .foregroundColor(.secondary)
        }
    }
}

struct ThemeSelectorView: View {
    var body: some View {
        VStack {
            Text("🎨 테마 선택")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("테마 선택 화면입니다.")
                .foregroundColor(.secondary)
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack {
            Text("ℹ️ 앱 정보")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("앱 정보 화면입니다.")
                .foregroundColor(.secondary)
        }
    }
}

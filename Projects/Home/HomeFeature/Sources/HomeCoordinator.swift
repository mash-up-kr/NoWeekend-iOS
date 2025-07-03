//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Core

@Observable
public final class HomeCoordinator: Coordinatorable {
    public typealias Screen = HomeRouter.Screen
    public typealias SheetScreen = HomeRouter.Sheet
    public typealias FullScreen = HomeRouter.FullScreen
    
    public var path: NavigationPath = NavigationPath()
    public var sheet: SheetScreen?
    public var fullScreenCover: FullScreen?
    
    public init() {
        print("🧭 HomeCoordinator 생성")
    }
    
    @ViewBuilder
    public func view(_ screen: Screen) -> some View {
        switch screen {
        case .main:
            HomeView()
        case .eventDetail(let eventId):
            EventDetailView(eventId: eventId)
        case .settings:
            SettingsView()
        }
    }
    
    @ViewBuilder
    public func presentView(_ sheet: SheetScreen) -> some View {
        switch sheet {
        case .createEvent:
            CreateEventView()
        }
    }
    
    @ViewBuilder
    public func fullCoverView(_ cover: FullScreen) -> some View {
        switch cover {
        case .tutorial:
            TutorialView()
        }
    }
}

public enum HomeRouter {
    public enum Screen: Hashable {
        case main
        case eventDetail(String)
        case settings
    }
    
    public enum Sheet: String, Identifiable {
        case createEvent
        public var id: String { self.rawValue }
    }
    
    public enum FullScreen: String, Identifiable {
        case tutorial
        public var id: String { self.rawValue }
    }
}

// MARK: - 임시 뷰들
struct EventDetailView: View {
    let eventId: String
    
    var body: some View {
        VStack {
            Text("📋 이벤트 상세")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("이벤트 ID: \(eventId)")
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

struct CreateEventView: View {
    var body: some View {
        VStack {
            Text("➕ 이벤트 생성")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("이벤트 생성 폼이 들어갑니다.")
                .foregroundColor(.secondary)
        }
    }
}

struct TutorialView: View {
    var body: some View {
        VStack {
            Text("📘 튜토리얼")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("앱 사용법을 소개하는 화면입니다.")
                .foregroundColor(.secondary)
        }
    }
}

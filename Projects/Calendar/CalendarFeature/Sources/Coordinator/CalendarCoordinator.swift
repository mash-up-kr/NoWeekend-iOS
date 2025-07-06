//
//  CalendarCoordinator.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import Coordinator
import Combine

public final class CalendarCoordinator: ObservableObject, Coordinatorable {
    public typealias Screen = CalendarRouter.Screen
    public typealias SheetScreen = CalendarRouter.Sheet
    public typealias FullScreen = CalendarRouter.FullScreen
    
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var sheet: SheetScreen?
    @Published public var fullScreenCover: FullScreen?
    
    public init() {
        print("🧭 CalendarCoordinator 생성")
    }
    
    @ViewBuilder
    public func view(_ screen: Screen) -> some View {
        switch screen {
        case .main:
            CalendarView()
        case .eventDetail(let eventId):
            CalendarEventDetailView(eventId: eventId)
        case .settings:
            CalendarSettingsView()
        }
    }
    
    @ViewBuilder
    public func presentView(_ sheet: SheetScreen) -> some View {
        switch sheet {
        case .createEvent:
            CreateCalendarEventView()
        case .eventFilter:
            EventFilterView()
        }
    }
    
    @ViewBuilder
    public func fullCoverView(_ cover: FullScreen) -> some View {
        switch cover {
        case .eventImport:
            EventImportView()
        }
    }
}

public enum CalendarRouter {
    public enum Screen: Hashable {
        case main
        case eventDetail(String)
        case settings
    }
    
    public enum Sheet: String, Identifiable {
        case createEvent
        case eventFilter
        public var id: String { self.rawValue }
    }
    
    public enum FullScreen: String, Identifiable {
        case eventImport
        public var id: String { self.rawValue }
    }
}

// MARK: - 예시 뷰들
struct CalendarEventDetailView: View {
    let eventId: String
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("📅 캘린더 이벤트 상세")
                .font(.largeTitle)
                .bold()
            
            Text("이벤트 ID: \(eventId)")
                .foregroundColor(.secondary)
            
            Button("설정으로 이동") {
                coordinator.push(.settings)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("뒤로가기") {
                coordinator.pop()
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("이벤트 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CalendarSettingsView: View {
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("⚙️ 캘린더 설정")
                .font(.largeTitle)
                .bold()
            
            Text("캘린더 설정 화면입니다.")
                .foregroundColor(.secondary)
            
            Button("루트로 돌아가기") {
                coordinator.popToRoot()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateCalendarEventView: View {
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("➕ 새 이벤트 생성")
                .font(.largeTitle)
                .bold()
            
            Text("이벤트 생성 폼이 들어갑니다.")
                .foregroundColor(.secondary)
            
            Button("저장") {
                coordinator.dismissSheet()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("새 이벤트")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EventFilterView: View {
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🔍 이벤트 필터")
                .font(.largeTitle)
                .bold()
            
            Text("필터 설정 화면입니다.")
                .foregroundColor(.secondary)
            
            Button("적용") {
                coordinator.dismissSheet()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("필터")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EventImportView: View {
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("📥 이벤트 가져오기")
                .font(.largeTitle)
                .bold()
            
            Text("외부 캘린더에서 이벤트를 가져옵니다.")
                .foregroundColor(.secondary)
            
            Button("완료") {
                coordinator.dismissCover()
            }
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

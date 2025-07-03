//
//  OnboardingView.swift
//  OnboardingFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import OnboardingDomain
import DesignSystem
import Utils

public struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to NoWeekend",
            description: "Discover amazing events happening around you",
            imageName: "calendar"
        ),
        OnboardingPage(
            title: "Find Your Interests", 
            description: "Search and filter events that match your preferences",
            imageName: "magnifyingglass"
        ),
        OnboardingPage(
            title: "Never Miss Out",
            description: "Get notifications for events you care about",
            imageName: "bell"
        )
    ]
    
    public var onComplete: () -> Void
    
    public init(onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
        print("🚪 OnboardingView 초기화")
    }
    
    public var body: some View {
        if showMainApp {
            Text("온보딩 완료!")
                .onAppear {
                    onComplete()
                }
        } else {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                VStack(spacing: 16) {
                    if currentPage == pages.count - 1 {
                        Button("시작하기") {
                            showMainApp = true
                        }
                        .font(.heading6)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(DS.Colors.TaskItem.orange)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                    Button("건너뛰기") {
                        showMainApp = true
                    }
                    .font(.body2)
                    .foregroundColor(DS.Colors.Text.gray700)
                }
                .padding()
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(DS.Colors.TaskItem.orange)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.heading2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DS.Colors.Text.gray900)
                
                Text(page.description)
                    .font(.body1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DS.Colors.Text.gray700)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}

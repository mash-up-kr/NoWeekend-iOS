//
//  Coordinatorable.swift
//  Core
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

@MainActor
public protocol Coordinatorable: AnyObject {
    associatedtype Screen: Hashable
    associatedtype SheetScreen: RawRepresentable, Identifiable
    associatedtype FullScreen: RawRepresentable, Identifiable
    
    associatedtype PushView: View
    associatedtype SheetView: View
    associatedtype FullView: View
    
    var path: NavigationPath { get set }
    var sheet: SheetScreen? { get set }
    var fullScreenCover: FullScreen? { get set }
    
    @ViewBuilder
    func view(_ screen: Screen) -> PushView
    @ViewBuilder
    func presentView(_ sheet: SheetScreen) -> SheetView
    @ViewBuilder
    func fullCoverView(_ cover: FullScreen) -> FullView
}

public extension Coordinatorable {
    func push(_ page: Screen...) {
        page.forEach {
            path.append($0)
        }
    }
    
    func sheet(_ sheet: SheetScreen) {
        self.sheet = sheet
    }
    
    func fullCover(_ cover: FullScreen) {
        self.fullScreenCover = cover
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        guard !path.isEmpty else { return }
        let count = path.count
        path.removeLast(count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissCover() {
        self.fullScreenCover = nil
    }
}

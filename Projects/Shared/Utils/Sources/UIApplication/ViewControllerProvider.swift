//
//  ViewControllerProvider.swift
//  Common
//
//  Created by SiJongKim on 6/16/25.
//

import UIKit

@MainActor
public final class ViewControllerProvider: @preconcurrency ViewControllerProviderInterface {
    
    public init() {}
    
    public func getCurrentPresentingViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        guard let rootViewController = window.rootViewController else {
            return nil
        }
        let presentingVC = findTopViewController(from: rootViewController)
        return presentingVC
    }
    
    private func findTopViewController(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return findTopViewController(from: presented)
        }
        if let navigation = viewController as? UINavigationController,
           let visible = navigation.visibleViewController {
            return findTopViewController(from: visible)
        }
        if let tabBar = viewController as? UITabBarController,
           let selected = tabBar.selectedViewController {
            return findTopViewController(from: selected)
        }
        return viewController
    }
}

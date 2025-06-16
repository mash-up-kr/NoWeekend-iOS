//
//  ViewControllerProvider.swift
//  Common
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation
import UIKit

public final class ViewControllerProvider: ViewControllerProviderInterface {
    public init() {}
    
    public func getCurrentPresentingViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            return nil
        }
        return rootViewController
    }
}

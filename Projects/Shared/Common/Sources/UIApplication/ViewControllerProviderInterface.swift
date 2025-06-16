//
//  ViewControllerProviderInterface.swift
//  Common
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation
import UIKit

public protocol ViewControllerProviderInterface {
    func getCurrentPresentingViewController() -> UIViewController?
}

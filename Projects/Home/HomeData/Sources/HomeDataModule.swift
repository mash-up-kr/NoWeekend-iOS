//
//  HomeDataModule.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core

public enum HomeDataModule {
    @AutoRegisterData
    static var assembly = HomeAssembly()
    
    public static func configure() {
        print("🏠 HomeDataModule 활성화")
        _ = assembly // PropertyWrapper 활성화
    }
}

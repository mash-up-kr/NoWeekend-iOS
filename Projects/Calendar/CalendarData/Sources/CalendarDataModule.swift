//
//  CalendarDataModule.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core

public enum CalendarDataModule {
    @AutoRegisterData
    static var assembly = CalendarAssembly()
    
    public static func configure() {
        print("📅 CalendarDataModule 활성화")
        _ = assembly // PropertyWrapper 활성화
    }
}

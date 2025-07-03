//
//  ProfileDataModule.swift
//  ProfileData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core

public enum ProfileDataModule {
    @AutoRegisterData
    static var assembly = ProfileAssembly()
    
    public static func configure() {
        print("👤 ProfileDataModule 활성화")
        _ = assembly // PropertyWrapper 활성화
    }
}

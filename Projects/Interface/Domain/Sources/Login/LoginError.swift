//
//  LoginError.swift
//  Domain
//
//  Created by SiJongKim on 6/16/25.
//

import Foundation

public enum LoginError: Error, LocalizedError {
    case noPresentingViewController
    case nameNotAvailable
    case authenticationFailed(Error)
    
    public var errorDescription: String? {
        switch self {
        case .noPresentingViewController:
            return "로그인 화면을 표시할 수 없습니다."
        case .nameNotAvailable:
            return "회원가입을 위한 이름을 가져올 수 없습니다."
        case .authenticationFailed(let error):
            return "로그인에 실패했습니다: \(error.localizedDescription)"
        }
    }
}

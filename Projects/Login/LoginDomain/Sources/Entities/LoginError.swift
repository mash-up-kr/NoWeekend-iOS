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
    case appleSignInCancelled
    case appleSignInFailed
    case invalidAppleCredential
    case registrationRequired(Error)
    
    public var errorDescription: String? {
        switch self {
        case .noPresentingViewController:
            return "로그인 화면을 표시할 수 없습니다."
        case .nameNotAvailable:
            return "회원가입을 위한 이름을 가져올 수 없습니다."
        case .authenticationFailed(let error):
            return "로그인에 실패했습니다: \(error.localizedDescription)"
        case .registrationRequired(let error):  // 새로 추가
            return "회원가입이 필요합니다: \(error.localizedDescription)"
        case .appleSignInCancelled:
            return "Apple 로그인이 취소되었습니다."
        case .appleSignInFailed:
            return "Apple 로그인에 실패했습니다."
        case .invalidAppleCredential:
            return "유효하지 않은 Apple 인증 정보입니다."
        }
    }
}

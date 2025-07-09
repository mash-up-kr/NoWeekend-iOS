//
//  WithdrawalResponseDTO.swift
//  LoginData
//
//  Created by SiJongKim on 7/9/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation


public struct WithdrawalResponseDTO: Decodable {
    public let message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
}

public struct ApiResponseWithdrawalDTO: Decodable {
    public let result: String
    public let data: WithdrawalResponseDTO?
    public let error: ErrorMessageDTO?
    
    public init(result: String, data: WithdrawalResponseDTO? = nil, error: ErrorMessageDTO? = nil) {
        self.result = result
        self.data = data
        self.error = error
    }
}

//
//  RecommendTagResponse.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/15/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

// MARK: - API Response Models
public struct RecommendTagResponse: Codable, Sendable {
    public let result: String
    public let data: RecommendTagData?
    public let error: APIError?
    
    public init(result: String, data: RecommendTagData?, error: APIError?) {
        self.result = result
        self.data = data
        self.error = error
    }
}

public struct RecommendTagData: Codable, Sendable {
    public let firstRecommendTag: RecommendTag
    public let secondRecommendTag: RecommendTag
    public let thirdRecommendTag: RecommendTag
    
    public init(firstRecommendTag: RecommendTag, secondRecommendTag: RecommendTag, thirdRecommendTag: RecommendTag) {
        self.firstRecommendTag = firstRecommendTag
        self.secondRecommendTag = secondRecommendTag
        self.thirdRecommendTag = thirdRecommendTag
    }
}

public struct RecommendTag: Codable, Sendable {
    public let content: String
    
    public init(content: String) {
        self.content = content
    }
}

public struct APIError: Codable, Sendable {
    public let code: String
    public let message: String
    public let data: [String: String]
    
    public init(code: String, message: String, data: [String: String]) {
        self.code = code
        self.message = message
        self.data = data
    }
}

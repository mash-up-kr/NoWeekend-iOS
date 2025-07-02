//
//  TagReqeustDTO.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct TagRequestDTO {
    public let scheduleTags: [String]
    
    public init(scheduleTags: [String]) {
        self.scheduleTags = scheduleTags
    }
    
    public var toDictionary: [String: Any] {
        return [
            "scheduleTags": scheduleTags
        ]
    }
}

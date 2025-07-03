//
//  Dependency.swift
//  Core
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Swinject

@propertyWrapper
public struct Dependency<T> {
    private var value: T?
    
    public var wrappedValue: T {
        mutating get {
            if let value = value {
                return value
            }
            
            let resolved = DIContainer.shared.resolve(T.self)
            self.value = resolved
            return resolved
        }
    }
    
    public init() {}
}

@propertyWrapper
public struct AutoRegisterData<T: Assembly> {
    private let assembly: T
    
    public var wrappedValue: T {
        return assembly
    }
    
    public init(wrappedValue: T) {
        self.assembly = wrappedValue
        
        // 자동으로 DI Container에 등록
        DIContainer.shared.registerAssembly(assembly: [wrappedValue])
        print("🔧 PropertyWrapper가 자동 등록: \(T.self)")
    }
}


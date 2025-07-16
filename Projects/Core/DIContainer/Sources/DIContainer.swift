//
//  DIContainer.swift
//  Core
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject

public final class DIContainer {
    public static let shared: DIContainer = DIContainer()
    public let container: Container = Container()
    
    private let queue = DispatchQueue(label: "DIContainer.resolve", qos: .userInitiated)
    
    private init() {
        print("📦 DIContainer 초기화 (Feature별 통합 DI)")
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        return queue.sync {
            guard let service = container.resolve(serviceType) else {
                fatalError("❌ \(serviceType) 타입을 해결할 수 없습니다. 등록되었는지 확인하세요.")
            }
            return service
        }
    }
    
    public func register<T>(
        _ serviceType: T.Type,
        factory: @escaping (DIResolver) -> T
    ) {
        queue.sync {
            container.register(serviceType) { resolver in
                let diResolver = DIResolver(resolver: resolver)
                return factory(diResolver)
            }
            print("✅ \(serviceType) 등록 완료")
        }
    }
    
    public func registerAssembly(assembly: [Assembly]) {
        queue.sync {
            _ = Assembler(assembly, container: container)
            print("🔧 Assembly 등록 완료: \(assembly.count)개")
        }
    }
}

public struct DIResolver {
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        guard let service = resolver.resolve(serviceType) else {
            fatalError("❌ \(serviceType) 타입을 해결할 수 없습니다.")
        }
        return service
    }
}

@propertyWrapper
public struct Dependency<T> {
    private let _wrappedValue: Lazy<T>
    
    public init() {
        self._wrappedValue = Lazy {
            DIContainer.shared.resolve(T.self)
        }
    }
    
    public var wrappedValue: T {
        return _wrappedValue.value
    }
}

private class Lazy<T> {
    private var _value: T?
    private let _factory: () -> T
    private let lock = NSLock()
    
    init(factory: @escaping () -> T) {
        self._factory = factory
    }
    
    var value: T {
        lock.lock()
        defer { lock.unlock() }
        
        if let value = _value {
            return value
        }
        let value = _factory()
        _value = value
        return value
    }
}

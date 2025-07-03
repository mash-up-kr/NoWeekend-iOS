//
//  DIContainer.swift
//  Core
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject

public enum NWObjectScope {
    case graph
    case container
    
    var swinjectScope: ObjectScope {
        switch self {
        case .graph: return .graph
        case .container: return .container
        }
    }
}

public final class DIContainer {
    public static let shared: DIContainer = DIContainer()
    public let container: Container = Container()
    
    private init() {
        print("📦 DIContainer 초기화 (Swinject 완전 은닉)")
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        guard let service = container.resolve(serviceType) else {
            fatalError("❌ \(serviceType) 타입을 해결할 수 없습니다. 등록되었는지 확인하세요.")
        }
        return service
    }
    
    public func register<T>(
        _ serviceType: T.Type,
        scope: NWObjectScope = .graph,
        factory: @escaping (DIResolver) -> T
    ) {
        container.register(serviceType) { resolver in
            let diResolver = DIResolver(resolver: resolver)
            return factory(diResolver)
        }.inObjectScope(scope.swinjectScope)
        print("✅ \(serviceType) 등록 완료 (Scope: \(scope))")
    }
    
    public func registerAssembly(assembly: [Assembly]) {
        _ = Assembler(assembly, container: container)
        print("🔧 Assembly 등록 완료: \(assembly.count)개")
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

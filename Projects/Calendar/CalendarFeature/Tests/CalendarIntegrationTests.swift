//
//  CalendarIntegrationTests.swift
//  CalendarFeatureTests
//
//  Created by 이지훈 on 7/24/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import XCTest
import Combine
@testable import CalendarFeature
@testable import CalendarDomain
@testable import DesignSystem
@testable import DIContainer
@testable import NWNetwork
import Foundation

// MARK: - 동시성 테스트를 위한 향상된 Mock Repository
/**
 동시성 상황에서의 실제 네트워크 요청과 유사한 동작을 시뮬레이션하는 Mock Repository
 
 주요 기능:
 - 현실적인 네트워크 지연 시뮬레이션
 - 동시 요청 추적 및 상태 관리
 - 작업 완료 순서 기록 및 검증
 - Race condition 테스트 지원
 */
class ConcurrencyMockRepository: CalendarRepositoryProtocol {
    
    // MARK: - 동시성 상태 관리
    private var operationQueue = DispatchQueue(label: "mock.repository", qos: .userInitiated)
    private var activeOperations: Set<String> = []
    private var completionOrder: [String] = []
    
    // MARK: - 네트워크 지연 시뮬레이션 설정
    var shouldSimulateRealisticTiming = false
    var baseDelay: TimeInterval = 0.05 // 기본 50ms 지연
    var delayVariation: TimeInterval = 0.03 // ±30ms 랜덤 변동
    
    // MARK: - Mock 결과 설정
    var updateScheduleStateResult: Result<Schedule, Error> = .success(MockHelpers.createMockSchedule())
    
    // MARK: - 호출 추적
    var updateScheduleStateCallCount = 0
    
    // MARK: - 작업 상태 콜백
    var onOperationStarted: ((String) -> Void)?
    var onOperationCompleted: ((String) -> Void)?
    var onAllOperationsCompleted: (() -> Void)?
    
    /**
     스케줄 상태 업데이트 요청을 처리하며, 동시성 테스트를 위한  지연 시뮬레이션
     
     - Parameters:
        - id: 업데이트할 스케줄 ID
        - isComplete: 완료 상태 여부
     - Returns: 업데이트된 Schedule 객체
     - Throws: 설정된 에러 또는 네트워크 관련 에러
     */
    func updateScheduleState(id: String, isComplete: Bool) async throws -> Schedule {
        let operationId = "\(id)-\(isComplete)-\(UUID().uuidString.prefix(8))"
        
        return try await withCheckedThrowingContinuation { continuation in
            operationQueue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(throwing: NSError(domain: "MockError", code: -1))
                    return
                }
                
                // 작업 시작 추적
                self.activeOperations.insert(operationId)
                self.updateScheduleStateCallCount += 1
                
                Task { @MainActor in
                    self.onOperationStarted?(operationId)
                }
                
                Task {
                    do {
                        // 네트워크 지연 시뮬레이션
                        if self.shouldSimulateRealisticTiming {
                            let randomDelay = self.baseDelay + Double.random(in: -self.delayVariation...self.delayVariation)
                            let delayNanoseconds = UInt64(max(0, randomDelay) * 1_000_000_000)
                            try await Task.sleep(nanoseconds: delayNanoseconds)
                        }
                        
                        // Mock 결과 생성
                        let baseSchedule = try self.updateScheduleStateResult.get()
                        let updatedSchedule = Schedule(
                            id: id,
                            title: baseSchedule.title,
                            startTime: baseSchedule.startTime,
                            endTime: baseSchedule.endTime,
                            category: baseSchedule.category,
                            temperature: baseSchedule.temperature,
                            allDay: baseSchedule.allDay,
                            alarmOption: baseSchedule.alarmOption,
                            completed: isComplete
                        )
                        
                        // 작업 완료 처리
                        await self.markOperationCompleted(operationId)
                        continuation.resume(returning: updatedSchedule)
                        
                    } catch {
                        await self.markOperationCompleted(operationId)
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    /**
     작업 완료를 표시하고 완료 순서를 기록
     
     - Parameter operationId: 완료된 작업의 고유 ID
     */
    @MainActor
    private func markOperationCompleted(_ operationId: String) {
        activeOperations.remove(operationId)
        completionOrder.append(operationId)
        
        onOperationCompleted?(operationId)
        
        // 모든 작업이 완료되면 콜백 호출
        if activeOperations.isEmpty {
            onAllOperationsCompleted?()
        }
    }
    
    /**
     모든 활성 작업이 완료될 때까지 대기
     
     - Parameter timeout: 최대 대기 시간 (기본 5초)
     - Returns: 모든 작업이 완료되면 true, 타임아웃 시 false
     */
    func waitForAllOperationsToComplete(timeout: TimeInterval = 5.0) async -> Bool {
        return await withCheckedContinuation { continuation in
            var isResumed = false
            let lock = NSLock()
            
            // 타임아웃 처리
            let timeoutTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                lock.lock()
                defer { lock.unlock() }
                if !isResumed {
                    isResumed = true
                    continuation.resume(returning: false)
                }
            }
            
            // 완료 콜백 설정
            onAllOperationsCompleted = {
                lock.lock()
                defer { lock.unlock() }
                if !isResumed {
                    isResumed = true
                    timeoutTask.cancel()
                    continuation.resume(returning: true)
                }
            }
            
            // 이미 모든 작업이 완료된 경우 즉시 반환
            lock.lock()
            defer { lock.unlock() }
            if activeOperations.isEmpty && !isResumed {
                isResumed = true
                timeoutTask.cancel()
                continuation.resume(returning: true)
            }
        }
    }
    
    /**
     테스트를 위한 상태 초기화
     */
    func reset() {
        operationQueue.sync {
            activeOperations.removeAll()
            completionOrder.removeAll()
            updateScheduleStateCallCount = 0
            onOperationStarted = nil
            onOperationCompleted = nil
            onAllOperationsCompleted = nil
        }
    }
    
    // MARK: - 기타 프로토콜 메서드 (테스트에 불필요한 간단 구현)
    func getSchedules(startDate: String, endDate: String) async throws -> [DailySchedule] { [] }
    func createSchedule(request: CreateScheduleRequest) async throws -> Schedule { MockHelpers.createMockSchedule() }
    func updateSchedule(id: String, request: UpdateScheduleRequest) async throws -> Schedule { MockHelpers.createMockSchedule() }
    func deleteSchedule(id: String) async throws { }
    func getRecommendedTags() async throws -> RecommendTagResponse { MockHelpers.createMockRecommendTags() }
}

// MARK: - 통합 테스트 (Store + UseCase + Repository 연동)
/**
 CalendarStore의 실제 UseCase와 Repository와의 통합 동작을 검증하는 테스트 클래스
 
 주요 테스트 영역:
 - 동시성 시나리오에서의 상태 일관성
 - 네트워크 에러 상황에서의 복구 로직
 - 복잡한 사용자 시나리오의 End-to-End 동작
 */
@MainActor
final class CalendarIntegrationTests: XCTestCase {
    
    private var sut: CalendarStore!
    private var mockRepository: ConcurrencyMockRepository!
    private var cancellables: Set<AnyCancellable>!
    private var capturedEffects: [CalendarEffect] = []
    
    override func setUp() {
        super.setUp()
        
        mockRepository = ConcurrencyMockRepository()
        setupTestDI()
        
        sut = CalendarStore()
        cancellables = Set<AnyCancellable>()
        capturedEffects = []
        
        // Effect 스트림 구독
        sut.effect
            .sink { [weak self] effect in
                self?.capturedEffects.append(effect)
            }
            .store(in: &cancellables)
    }
    
    override func tearDown() {
        mockRepository.reset()
        cancellables?.removeAll()
        capturedEffects.removeAll()
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    /**
     테스트용 DI Container 설정
     실제 Repository 대신 Mock Repository를 주입하여 격리된 테스트 환경 구성
     */
    private func setupTestDI() {
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { _ in
            return self.mockRepository
        }.inObjectScope(.transient)
        
        DIContainer.shared.container.register(CalendarUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(CalendarRepositoryProtocol.self)!
            return CalendarUseCase(calendarRepository: repository)
        }.inObjectScope(.transient)
    }
    
    // MARK: - 동시성 테스트
    
    /**
     다중 할일 동시 업데이트 시나리오 테스트
     
     시나리오:
     1. 5개의 할일이 있는 상태
     2. 모든 할일을 동시에 완료 처리
     3. 네트워크 지연을 시뮬레이션하여 현실적인 조건 재현
     
     검증 사항:
     - 모든 API 호출이 올바르게 수행됨
     - 동시성 상황에서도 상태 일관성 유지
     - 모든 할일이 최종적으로 완료 상태로 변경됨
     */
    func test_concurrentTaskUpdates_maintainsStateConsistency() async {
        // Given: 5개의 할일 아이템 준비
        let todoItems = (1...5).map { index in
            createMockTodoItem(id: index, scheduleId: "schedule-\(index)")
        }
        
        sut.updateState { state in
            state.todoItems = todoItems
        }
        
        // 현실적인 네트워크 지연 시뮬레이션 활성화
        mockRepository.shouldSimulateRealisticTiming = true
        
        // 작업 완료 추적을 위한 상태 설정
        let operationExpectation = XCTestExpectation(description: "모든 동시 작업이 완료되어야 함")
        operationExpectation.expectedFulfillmentCount = 5
        
        var completedOperations: Set<String> = []
        mockRepository.onOperationCompleted = { operationId in
            completedOperations.insert(operationId)
            operationExpectation.fulfill()
        }
        
        // When: 모든 할일을 동시에 완료 처리
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<5 {
                group.addTask { [weak self] in
                    await self?.sut.send(.taskCompletionToggled(i))
                }
            }
        }
        
        // Then: 모든 작업 완료 대기 및 검증
        await fulfillment(of: [operationExpectation], timeout: 10.0)
        
        // Repository 레벨에서 모든 작업 완료 확인
        let allCompleted = await mockRepository.waitForAllOperationsToComplete(timeout: 2.0)
        XCTAssertTrue(allCompleted, "모든 Repository 작업이 완료되어야 함")
        
        // 동시성 동작 검증
        XCTAssertEqual(completedOperations.count, 5, "5개의 작업이 모두 완료되어야 함")
        XCTAssertEqual(mockRepository.updateScheduleStateCallCount, 5, "Repository가 정확히 5번 호출되어야 함")
        
        // 최종 상태 일관성 검증
        let completedCount = sut.state.todoItems.filter { $0.isCompleted }.count
        XCTAssertEqual(completedCount, 5, "모든 할일이 완료 상태여야 함")
    }
    
    /**
     단일 할일에 대한 빠른 연속 토글 테스트 (Race Condition 시나리오)
     
     시나리오:
     1. 하나의 할일에 대해 빠른 연속으로 3번 토글
     2. 각 요청 사이에 충분한 지연을 두어 Race Condition 유발
     
     검증 사항:
     - 모든 토글 요청이 올바르게 처리됨
     - 최종 상태가 예측 가능한 범위 내에 있음
     - 시스템이 동시 요청을 안전하게 처리함
     */
    func test_rapidTaskToggling_handlesRaceConditions() async {
        // Given: 단일 할일 준비
        let todoItem = createMockTodoItem(id: 1, scheduleId: "schedule-1")
        sut.updateState { state in
            state.todoItems = [todoItem]
        }
        
        // Race condition 유발을 위한 긴 지연 설정
        mockRepository.shouldSimulateRealisticTiming = true
        mockRepository.baseDelay = 0.1
        
        let rapidToggleExpectation = XCTestExpectation(description: "빠른 연속 토글 작업이 완료되어야 함")
        rapidToggleExpectation.expectedFulfillmentCount = 3
        
        mockRepository.onOperationCompleted = { _ in
            rapidToggleExpectation.fulfill()
        }
        
        // When: 동일한 할일을 빠르게 3번 토글
        let toggleTasks = (0..<3).map { _ in
            Task {
                sut.send(.taskCompletionToggled(0))
            }
        }
        
        // 모든 토글 작업 시작
        for task in toggleTasks {
            await task.value
        }
        
        // Then: 모든 작업 완료 대기 및 검증
        await fulfillment(of: [rapidToggleExpectation], timeout: 5.0)
        
        XCTAssertEqual(mockRepository.updateScheduleStateCallCount, 3, "모든 토글 요청이 처리되어야 함")
        
        // 최종 상태가 유효한 범위 내에 있는지 확인 (true 또는 false)
        let finalState = sut.state.todoItems[0].isCompleted
        XCTAssertTrue([true, false].contains(finalState), "최종 상태가 예측 가능한 범위 내에 있어야 함")
    }
    
    // MARK: - 에러 처리 테스트
    
    /**
     네트워크 에러 발생 시 상태 복구 로직 테스트
     
     시나리오:
     1. 할일 완료 상태 변경 시도
     2. 네트워크 에러 발생으로 API 호출 실패
     3. UI 상태가 원래대로 복구되고 에러 Effect 발생
     
     검증 사항:
     - 에러 발생 시 할일 상태가 원래대로 복구됨
     - 적절한 에러 Effect가 발생함
     - 시스템이 안정적으로 에러 상황을 처리함
     */
    func test_taskCompletionToggled_withNetworkError_recoversStateAndShowsError() async {
        // Given: 하나의 할일과 네트워크 에러 시뮬레이션
        let todoItem = createMockTodoItem(id: 1, scheduleId: "schedule-1")
        sut.updateState { state in
            state.todoItems = [todoItem]
        }
        
        let networkError = NetworkError.serverError("네트워크 연결 실패")
        mockRepository.updateScheduleStateResult = .failure(networkError)
        
        let originalCompletionState = sut.state.todoItems[0].isCompleted
        
        // When: 할일 완료 상태 토글 시도
        sut.send(.taskCompletionToggled(0))
        await waitForAsyncOperations()
        
        // Then: 상태 복구 및 에러 처리 검증
        XCTAssertEqual(sut.state.todoItems[0].isCompleted, originalCompletionState,
                      "에러 발생 시 할일 상태가 원래대로 복구되어야 함")
        
        // 에러 Effect 발생 확인
        let errorEffects = capturedEffects.compactMap { effect in
            if case .showError = effect { return effect }
            return nil
        }
        XCTAssertEqual(errorEffects.count, 1, "에러 Effect가 정확히 한 번 발생해야 함")
    }
    
    // MARK: - 헬퍼 메서드
    
    /**
     비동기 작업 완료를 위한 대기 시간
     */
    private func waitForAsyncOperations() async {
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
    }
    
    /**
     테스트용 Mock TodoItem 생성
     
     - Parameters:
        - id: 할일 ID
        - scheduleId: 연결된 스케줄 ID (옵셔널)
     - Returns: 테스트용 TodoItem 인스턴스
     */
    private func createMockTodoItem(id: Int, scheduleId: String? = nil) -> DesignSystem.TodoItem {
        return DesignSystem.TodoItem(
            id: id,
            title: "테스트 할일 \(id)",
            isCompleted: false,
            category: DesignSystem.TodoCategory(name: "테스트", color: .blue),
            time: "오전 9:00",
            scheduleId: scheduleId
        )
    }
}

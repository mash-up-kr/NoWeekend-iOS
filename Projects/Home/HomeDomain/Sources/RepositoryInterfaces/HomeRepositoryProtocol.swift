//
//  HomeRepositoryProtocol.swift
//  HomeDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol HomeRepositoryProtocol {
    func getHomes() async throws -> [Home]
    func createHome(_ home: Home) async throws
    func deleteHome(id: String) async throws
    
    // 위치 및 날씨 관련
    func registerLocation(_ location: LocationRegistration) async throws
    func getWeatherRecommendations() async throws -> [Weather]
    
    // 샌드위치 휴일 및 공휴일 관련
    func getSandwichHoliday() async throws -> [SandwichHoliday]
    func getHolidays() async throws -> [Holiday]
    
    // 휴가 추천 관련
    func createVacationRecommend(_ request: VacationRecommendRequest) async throws -> String
    func getVacationRecommend() async throws -> VacationRecommend?
} 
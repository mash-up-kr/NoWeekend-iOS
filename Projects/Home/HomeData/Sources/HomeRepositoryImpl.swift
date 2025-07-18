//
//  HomeRepositoryImpl.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DIContainer
import Foundation
import HomeDomain
import NWNetwork

public final class HomeRepositoryImpl: HomeRepositoryProtocol {
    private let networkService: NWNetworkServiceProtocol

    public init(networkService: NWNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func getHomes() async throws -> [Home] {
        // 빈 배열 반환 - 뷰에서 자체 데이터 사용
        return []
    }
    
    public func createHome(_ home: Home) async throws {
        // 빈 구현
    }
    
    public func deleteHome(id: String) async throws {
        // 빈 구현
    }

    public func registerLocation(_ location: LocationRegistration) async throws {
        let dto = location.toDTO()
        let parameters: [String: Any] = [
            "latitude": dto.latitude,
            "longitude": dto.longitude
        ]
        let _: ApiResponse<String> = try await networkService.post(
            endpoint: HomeEndpoint.registerLocation.path,
            parameters: parameters
        )
    }

    public func getWeatherRecommendations() async throws -> [Weather] {
        let response: ApiResponse<WeatherRecommendResponseDTO> = try await networkService.get(
            endpoint: HomeEndpoint.getWeatherRecommendations.path,
            parameters: nil
        )
        return response.data?.weatherResponses.map { $0.toDomain() } ?? []
    }
    
    public func getSandwichHoliday() async throws -> [SandwichHoliday] {
        let response: SandwichHolidayResponseDTO = try await networkService.get(
            endpoint: HomeEndpoint.getSandwichHoliday.path,
            parameters: nil
        )
        
        guard response.result == "SUCCESS" else {
            throw NetworkError.serverError(response.error ?? "샌드위치 휴일 조회 실패")
        }
        
        guard let data = response.data else {
            return []
        }
        
        return data.toDomain()
    }
    
    public func getHolidays() async throws -> [Holiday] {
        let response: HolidayResponseDTO = try await networkService.get(
            endpoint: HomeEndpoint.getHolidays.path,
            parameters: nil
        )
        
        guard response.result == "SUCCESS" else {
            throw NetworkError.serverError(response.error ?? "공휴일 조회 실패")
        }
        
        return response.data?.holidays.compactMap { $0.toDomain() } ?? []
    }
    
    public func createVacationRecommend(_ request: VacationRecommendRequest) async throws -> String {
        do {
            let dto = request.toDTO()
            let parameters: [String: Any] = [
                "days": dto.days,
                "travelStyle": dto.travelStyle,
                "activityType": dto.activityType,
                "restPreference": dto.restPreference,
                "leisurePreference": dto.leisurePreference
            ]
            
            let response: VacationRecommendCreateResponseDTO = try await networkService.post(
                endpoint: HomeEndpoint.createVacationRecommend.path,
                parameters: parameters
            )
            
            guard response.result == "SUCCESS" else {
                let errorMessage = response.error?.message ?? "휴가 추천 생성 실패"
                throw VacationRecommendError.serverError(errorMessage)
            }
            
            return response.data
        } catch {
            // 이미 VacationRecommendError인 경우 그대로 throw
            if error is VacationRecommendError {
                throw error
            }
            
            // 네트워크 에러를 VacationRecommendError로 변환
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let message):
                    throw VacationRecommendError.serverError(message)
                case .decodingError:
                    throw VacationRecommendError.serverError("응답 데이터 해석 실패")
                case .notImplemented(let message):
                    throw VacationRecommendError.serverError(message)
                case .unknown(let underlyingError):
                    // URLError인지 확인하여 네트워크 에러로 분류
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            throw VacationRecommendError.networkError("인터넷 연결을 확인해주세요")
                        case .timedOut:
                            throw VacationRecommendError.networkError("요청 시간이 초과되었습니다")
                        case .cannotFindHost:
                            throw VacationRecommendError.networkError("서버를 찾을 수 없습니다")
                        default:
                            throw VacationRecommendError.networkError("네트워크 오류: \(urlError.localizedDescription)")
                        }
                    } else {
                        throw VacationRecommendError.unknown(underlyingError.localizedDescription)
                    }
                }
            }
            
            // 기타 에러
            throw VacationRecommendError.unknown(error.localizedDescription)
        }
    }
    
    public func getVacationRecommend() async throws -> VacationRecommend? {
        do {
            let response: VacationRecommendResponseDTO = try await networkService.get(
                endpoint: HomeEndpoint.getVacationRecommend.path,
                parameters: nil
            )
            
            guard response.result == "SUCCESS" else {
                // E404 에러 확인
                if let error = response.error, error.code == "E404" {
                    throw VacationRecommendError.notReady
                }
                
                // 기타 에러 처리
                let errorMessage = response.error?.message ?? "휴가 추천 조회 실패"
                throw VacationRecommendError.serverError(errorMessage)
            }
            
            return response.data?.toDomain()
        } catch {
            // 이미 VacationRecommendError인 경우 그대로 throw
            if error is VacationRecommendError {
                throw error
            }
            
            // 네트워크 에러를 VacationRecommendError로 변환
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let message):
                    throw VacationRecommendError.serverError(message)
                case .decodingError:
                    throw VacationRecommendError.serverError("응답 데이터 해석 실패")
                case .notImplemented(let message):
                    throw VacationRecommendError.serverError(message)
                case .unknown(let underlyingError):
                    // URLError인지 확인하여 네트워크 에러로 분류
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            throw VacationRecommendError.networkError("인터넷 연결을 확인해주세요")
                        case .timedOut:
                            throw VacationRecommendError.networkError("요청 시간이 초과되었습니다")
                        case .cannotFindHost:
                            throw VacationRecommendError.networkError("서버를 찾을 수 없습니다")
                        default:
                            throw VacationRecommendError.networkError("네트워크 오류: \(urlError.localizedDescription)")
                        }
                    } else {
                        throw VacationRecommendError.unknown(underlyingError.localizedDescription)
                    }
                }
            }
            
            // 기타 에러
            throw VacationRecommendError.unknown(error.localizedDescription)
        }
    }
} 
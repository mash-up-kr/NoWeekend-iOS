//
//  VacationScheduleModalModels.swift
//  HomeFeature
//
//  Created by 김나희 on 7/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import HomeDomain

// MARK: - VacationScheduleModal State

struct VacationScheduleModalState: Equatable {
    var scheduleData: VacationScheduleData?
    var isLoading: Bool = false
    var errorMessage: String?
}

// MARK: - VacationScheduleModal Intent

enum VacationScheduleModalIntent {
    case viewDidLoad(VacationRecommend)
    case acceptButtonTapped
    case rejectButtonTapped
    case dismissModal
}

// MARK: - VacationScheduleModal Effect

enum VacationScheduleModalEffect {
    case acceptSchedule
    case rejectSchedule
    case dismissModal
    case showError(String)
}

// MARK: - VacationScheduleModal Models

struct VacationScheduleData: Equatable {
    let title: String
    let dailySchedules: [DailyScheduleData]
}

struct DailyScheduleData: Equatable {
    let day: Int
    let dayTitle: String
    let activities: [String]
}

// MARK: - VacationScheduleData Parser

extension VacationScheduleData {
    static func parse(from vacationRecommend: VacationRecommend) -> VacationScheduleData {
        let title = vacationRecommend.title
        let content = vacationRecommend.content
        
        // 일차별로 분리
        let dailySchedules = VacationScheduleContentParser.parseDailySchedules(from: content)
        
        return VacationScheduleData(
            title: title,
            dailySchedules: dailySchedules
        )
    }
}

// MARK: - Content Parser

struct VacationScheduleContentParser {
    static func parseDailySchedules(from content: String) -> [DailyScheduleData] {
        var dailySchedules: [DailyScheduleData] = []
        
        // "• Day" 패턴으로 분리
        let dayPattern = "• Day \\d+"
        let regex = try! NSRegularExpression(pattern: dayPattern, options: [])
        let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        
        if matches.isEmpty {
            // Day 패턴이 없으면 전체 텍스트를 하나의 일정으로 처리
            let activities = content.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            dailySchedules.append(DailyScheduleData(
                day: 1,
                dayTitle: "일정",
                activities: activities
            ))
        } else {
            // Day 패턴으로 분리
            for (index, match) in matches.enumerated() {
                let startIndex = match.range.location
                let endIndex = index < matches.count - 1 ? matches[index + 1].range.location : content.count
                
                let dayContent = String(content[content.index(content.startIndex, offsetBy: startIndex)..<content.index(content.startIndex, offsetBy: endIndex)])
                
                if let parsedDay = parseSingleDay(from: dayContent) {
                    dailySchedules.append(parsedDay)
                }
            }
        }
        
        return dailySchedules
    }
    
    private static func parseSingleDay(from dayContent: String) -> DailyScheduleData? {
        let lines = dayContent.components(separatedBy: "\n")
        guard let firstLine = lines.first else { return nil }
        
        // 일차 제목 추출 (• Day 1 (07/07 월) - Day 3 of 5 형태)
        let dayTitle = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "• ", with: "")
            .replacingOccurrences(of: "\\/", with: "/")
        
        // 일차 번호 추출
        let dayNumber = extractDayNumber(from: dayTitle)
        
        // 활동 목록 추출
        let activities = lines.dropFirst()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { line in
                // 숫자로 시작하는 줄 처리 (1. Morning: 2. Lunch: 등)
                if let regex = try? NSRegularExpression(pattern: "^\\d+\\.\\s*", options: []) {
                    let range = NSRange(location: 0, length: line.count)
                    return regex.stringByReplacingMatches(in: line, options: [], range: range, withTemplate: "")
                }
                return line
            }
        
        return DailyScheduleData(
            day: dayNumber,
            dayTitle: dayTitle,
            activities: activities
        )
    }
    
    private static func extractDayNumber(from title: String) -> Int {
        let regex = try! NSRegularExpression(pattern: "Day (\\d+)", options: [])
        let matches = regex.matches(in: title, options: [], range: NSRange(location: 0, length: title.count))
        
        if let match = matches.first, match.numberOfRanges > 1 {
            let range = match.range(at: 1)
            let dayString = String(title[title.index(title.startIndex, offsetBy: range.location)..<title.index(title.startIndex, offsetBy: range.location + range.length)])
            return Int(dayString) ?? 1
        }
        
        return 1
    }
} 
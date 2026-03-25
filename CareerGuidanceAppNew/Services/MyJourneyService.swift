//
//  MyJourneyService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 25/03/26.
//

import Foundation
import UIKit
import Supabase

struct LessonProgressFetchDTO: Decodable {
    let lesson_id: String
    let is_completed: Bool
    let completed_at: String?
}

final class MyJourneyService {
    
    static let shared = MyJourneyService()
    private init() {}
    
    /// Fetches all completed milestones for the current user and groups them by month.
    func fetchCompletedMilestonesHistory() async throws -> [JourneySection] {
        guard let userId = UserSessionManager.shared.userId else {
            return []
        }
        
        // 1. Fetch user's completed lessons
        let progressResponse = try await SupabaseManager.shared.client
            .from("user_lesson_progress")
            .select("lesson_id, is_completed, completed_at")
            .eq("user_id", value: userId.uuidString)
            .eq("is_completed", value: true)
            .execute()
        
        let completedLessons = try JSONDecoder().decode([LessonProgressFetchDTO].self, from: progressResponse.data)
        
        var completedLessonDict: [String: LessonProgressFetchDTO] = [:]
        for prog in completedLessons {
            completedLessonDict[prog.lesson_id] = prog
        }
        
        // 2. Fetch all milestones
        let milestonesResponse = try await SupabaseManager.shared.client
            .from("milestones")
            .select()
            .execute()
        let allMilestones = try JSONDecoder().decode([MilestoneDTO].self, from: milestonesResponse.data)
        
        // 3. Fetch all lessons
        let lessonsResponse = try await SupabaseManager.shared.client
            .from("lessons")
            .select()
            .execute()
        let allLessons = try JSONDecoder().decode([LessonDTO].self, from: lessonsResponse.data)
        
        var lessonsByMilestone: [UUID: [LessonDTO]] = [:]
        for lesson in allLessons {
            lessonsByMilestone[lesson.milestone_id, default: []].append(lesson)
        }
        
        // 4. Determine completed milestones and their completion date
        var completedMilestoneItems: [(item: JourneyItem, date: Date)] = []
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fallbackFormatter = ISO8601DateFormatter()
        
        for milestone in allMilestones {
            guard let lessonsForMilestone = lessonsByMilestone[milestone.id], !lessonsForMilestone.isEmpty else {
                continue // Skip milestones without lessons
            }
            
            var isCompleted = true
            var latestDate: Date?
            
            for lesson in lessonsForMilestone {
                if let progress = completedLessonDict[lesson.id] {
                    if let dateString = progress.completed_at {
                        let date = dateFormatter.date(from: dateString) ?? fallbackFormatter.date(from: dateString)
                        if let validDate = date {
                            if latestDate == nil || validDate > latestDate! {
                                latestDate = validDate
                            }
                        }
                    }
                } else {
                    isCompleted = false
                    break
                }
            }
            
            if isCompleted {
                let finalDate = latestDate ?? Date() // Fallback to now if no date available
                
                let journeyItem = JourneyItem(
                    iconName: milestone.iconName,
                    iconColor: UIColor(hex: milestone.iconColor) ?? .systemBlue,
                    iconBackgroundColor: UIColor(hex: milestone.iconBackgroundColor) ?? .systemBlue.withAlphaComponent(0.2),
                    title: milestone.title,
                    subtitle: milestone.subtitle
                )
                
                completedMilestoneItems.append((item: journeyItem, date: finalDate))
            }
        }
        
        // 5. Group by month
        // We want to sort them descending by date first
        completedMilestoneItems.sort { $0.date > $1.date }
        
        var sectionsDict: [String: [JourneyItem]] = [:]
        var monthOrder: [String] = [] // to retain sorted order of months
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM yyyy" // e.g. "December 2023"
        // Wait, the mock uses just "December", but year is better or maybe just month name if within same year. We'll use "MMMM yyyy" to be safe.
        // Let's use "MMMM" to match mock UI if we only care about month.
        monthFormatter.dateFormat = "MMMM"
        
        for entry in completedMilestoneItems {
            let monthString = monthFormatter.string(from: entry.date)
            if sectionsDict[monthString] == nil {
                sectionsDict[monthString] = []
                monthOrder.append(monthString)
            }
            sectionsDict[monthString]?.append(entry.item)
        }
        
        var finalSections: [JourneySection] = []
        for month in monthOrder {
            if let items = sectionsDict[month] {
                finalSections.append(JourneySection(title: month, items: items))
            }
        }
        
        return finalSections
    }
}

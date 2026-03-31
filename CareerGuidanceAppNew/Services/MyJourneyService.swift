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
        
        let client = SupabaseManager.shared.client
        
        // 1️⃣ Fetch completed lessons
        let progressResponse = try await client
            .from("user_lesson_progress")
            .select("lesson_id, completed_at")
            .eq("user_id", value: userId.uuidString)
            .eq("is_completed", value: true)
            .execute()
        
        let progressRows = try JSONSerialization.jsonObject(
            with: progressResponse.data
        ) as? [[String: Any]] ?? []
        
        if progressRows.isEmpty { return [] }
        
        let completedLessonIds = progressRows.compactMap {
            $0["lesson_id"] as? String
        }
        
        // 2️⃣ Fetch lessons (to map milestone)
        let lessonsResponse = try await client
            .from("lessons")
            .select("id, milestone_id")
            .in("id", values: completedLessonIds)
            .execute()
        
        let lessonRows = try JSONSerialization.jsonObject(
            with: lessonsResponse.data
        ) as? [[String: Any]] ?? []
        
        var completedCount: [String: Int] = [:]
        
        for row in lessonRows {
            if let milestoneId = row["milestone_id"] as? String {
                completedCount[milestoneId, default: 0] += 1
            }
        }
        
        // 3️⃣ Fetch all lessons (for total count per milestone)
        let allLessonsResponse = try await client
            .from("lessons")
            .select("milestone_id")
            .execute()
        
        let allLessonRows = try JSONSerialization.jsonObject(
            with: allLessonsResponse.data
        ) as? [[String: Any]] ?? []
        
        var totalCount: [String: Int] = [:]
        
        for row in allLessonRows {
            if let milestoneId = row["milestone_id"] as? String {
                totalCount[milestoneId, default: 0] += 1
            }
        }
        
        // 4️⃣ Find completed milestones
        var completedMilestoneIds: [String] = []
        
        for (milestoneId, count) in completedCount {
            if count == totalCount[milestoneId] {
                completedMilestoneIds.append(milestoneId)
            }
        }
        
        if completedMilestoneIds.isEmpty { return [] }
        
        // 5️⃣ Fetch milestone UI data
        let milestoneResponse = try await client
            .from("milestones")
            .select("id, title, subtitle, icon_name, icon_color, icon_background_color")
            .in("id", values: completedMilestoneIds)
            .execute()
        
        let milestoneRows = try JSONSerialization.jsonObject(
            with: milestoneResponse.data
        ) as? [[String: Any]] ?? []
        
        let items: [JourneyItem] = milestoneRows.map { row in
            
            JourneyItem(
                iconName: row["icon_name"] as? String ?? "star",
                iconColor: UIColor(hex: row["icon_color"] as? String ?? "#000000") ?? .black,
                iconBackgroundColor: UIColor(hex: row["icon_background_color"] as? String ?? "#E0E0E0") ?? .systemGray5,
                title: row["title"] as? String ?? "",
                subtitle: row["subtitle"] as? String ?? "Milestone Completed"
            )
        }
        return [
            JourneySection(
                title: "Completed Milestones",
                items: items
            )
        ]
        
    }
    
}

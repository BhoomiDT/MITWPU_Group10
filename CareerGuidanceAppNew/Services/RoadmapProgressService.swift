//
//  RoadmapProgressService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 17/02/26.
//

import Supabase
import Foundation

final class RoadmapProgressService {

    static let shared = RoadmapProgressService()
    private init() {}

    func fetchLessonProgress(
        lessonIds: [String]
    ) async throws -> [String: Bool] {

        guard let userId = UserSessionManager.shared.userId else {
            return [:]
        }

        let response = try await SupabaseManager.shared.client
            .from("user_lesson_progress")
            .select("lesson_id, is_completed")
            .eq("user_id", value: userId.uuidString)
            .in("lesson_id", values: lessonIds)
            .execute()

        let rows = try JSONSerialization.jsonObject(
            with: response.data
        ) as? [[String: Any]] ?? []

        var map: [String: Bool] = [:]

        for row in rows {
            if let lessonId = row["lesson_id"] as? String,
               let completed = row["is_completed"] as? Bool {
                map[lessonId] = completed
            }
        }

        return map
    }

    func computeMilestoneProgress(
        milestone: Milestone,
        lessonCompletion: [String: Bool]
    ) -> MilestoneProgress {

        let total = milestone.lessons.count
        let completed = milestone.lessons.filter {
            lessonCompletion[$0.id] == true
        }.count

        return MilestoneProgress(
            milestoneId: milestone.id,
            completedLessons: completed,
            totalLessons: total,
            isCompleted: completed == total
        )
    }

    func computeRoadmapProgress(
        roadmap: Roadmap,
        lessonCompletion: [String: Bool]
    ) -> RoadmapProgress {

        let allLessons = roadmap.milestones.flatMap { $0.lessons }

        let completed = allLessons.filter {
            lessonCompletion[$0.id] == true
        }.count

        let percent = allLessons.isEmpty
            ? 0
            : Int(Double(completed) / Double(allLessons.count) * 100)

        return RoadmapProgress(
            roadmapId: roadmap.id,
            completedLessons: completed,
            totalLessons: allLessons.count,
            percent: percent
        )
    }
}

//
//  RoadmapService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/02/26.
//
//
//  RoadmapService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/02/26.
//
import Foundation
import Supabase

final class RoadmapService {

    static let shared = RoadmapService()
    private init() {}

    // MARK: - Roadmaps

    func fetchRoadmaps() async throws -> [RoadmapDTO] {
        let response = try await SupabaseManager.shared.client
            .from("roadmaps")
            .select()
            .order("created_at", ascending: true)
            .execute()

        return try JSONDecoder().decode([RoadmapDTO].self, from: response.data)
    }

    // MARK: - Milestones

    func fetchMilestones(for roadmapId: UUID) async throws -> [MilestoneDTO] {
        let response = try await SupabaseManager.shared.client
            .from("milestones")
            .select()
            .eq("roadmap_id", value: roadmapId)
            .order("order_index", ascending: true)
            .execute()
        

        return try JSONDecoder().decode([MilestoneDTO].self, from: response.data)
    }

    // MARK: - Lessons

    func fetchLessons(for milestoneId: UUID) async throws -> [LessonDTO] {
        let response = try await SupabaseManager.shared.client
            .from("lessons")
            .select()
            .eq("milestone_id", value: milestoneId)
            .order("order_index", ascending: true)
            .execute()

        return try JSONDecoder().decode([LessonDTO].self, from: response.data)
    }

    // MARK: - COMPOSED FETCH (STEP 2)

    func fetchMilestonesWithLessons(
        for roadmapId: UUID
    ) async throws -> [Milestone] {

        let milestoneDTOs = try await fetchMilestones(for: roadmapId)

        var milestones: [Milestone] = []

        for dto in milestoneDTOs {

            var milestone = MilestoneMapper.fromDTO(dto)

            let lessonDTOs = try await fetchLessons(for: dto.id)
            milestone.lessons = lessonDTOs.map {
                LessonMapper.fromDTO($0)
            }

            milestones.append(milestone)
        }

        return milestones
    }
}

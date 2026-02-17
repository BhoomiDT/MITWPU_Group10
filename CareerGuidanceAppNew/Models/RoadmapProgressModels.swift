//
//  RoadmapProgressModels.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 17/02/26.
//
import Foundation

struct LessonProgress {
    let lessonId: String
    let isCompleted: Bool
}

struct MilestoneProgress {
    let milestoneId: UUID
    let completedLessons: Int
    let totalLessons: Int
    let isCompleted: Bool
}

struct RoadmapProgress {
    let roadmapId: UUID
    let completedLessons: Int
    let totalLessons: Int
    let percent: Int
}

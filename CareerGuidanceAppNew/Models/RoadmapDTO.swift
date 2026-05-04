//
//  DTO.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/02/26.
//

import Foundation
import UIKit

struct RoadmapDTO: Codable, Identifiable {
    let id: UUID
    let title: String
    let subtitle: String?
    let description: String?
    let image_name: String?
    let created_at: String?
}

struct MilestoneDTO: Decodable {
    let id: UUID
    let roadmapId: UUID
    let title: String
    let subtitle: String?
    let orderIndex: Int?
    let iconName: String?
    let iconColor: String?
    let iconBackgroundColor: String?

    enum CodingKeys: String, CodingKey {
        case id
        case roadmapId = "roadmap_id"
        case title
        case subtitle
        case orderIndex = "order_index"
        case iconName = "icon_name"
        case iconColor = "icon_color"
        case iconBackgroundColor = "icon_background_color"
    }
}

struct LessonDTO: Codable, Identifiable {
    let id: String
    let milestone_id: UUID
    let title: String
    let subtitle: String?
    let due_date: String?
    let order_index: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case milestone_id
        case title = "name" // Matches 'name' in SQL
        case subtitle
        case due_date
        case order_index
    }
}

struct VideoDTO: Decodable {
    let id: UUID
    let lesson_id: String
    let title: String
    let duration: String
    let thumbnail_name: String
    let video_url: String
}
struct DocumentDTO: Decodable {
    let id: UUID
    let lesson_id: String
    let title: String
    let doc_url: String
}

//MAPPERS

enum RoadmapMapper {

    static func fromDTO(_ dto: RoadmapDTO) -> Roadmap {
        return Roadmap(
            id: dto.id,
            title: dto.title,
            subtitle: dto.subtitle ?? "",
            description: dto.description ?? "",
            imageName: dto.image_name ?? "",
            percentage: 0,
            milestones: [],     // later
            isStarted: false
        )
    }
}

enum MilestoneMapper {

    static func fromDTO(_ dto: MilestoneDTO) -> Milestone {
        Milestone(
            id: dto.id,
            roadmapId: dto.roadmapId,
            title: dto.title,
            subtitle: dto.subtitle ?? "",
            iconName: dto.iconName ?? "star",
            iconColor: UIColor(hex: dto.iconColor ?? "#000000"),
            iconBackgroundColor: UIColor(hex: dto.iconBackgroundColor ?? "#FFFFFF"),
            lessons: []
        )
    }
}

enum LessonMapper {

    static func fromDTO(_ dto: LessonDTO) -> Lesson {
        Lesson(
            id: dto.id,
            name: dto.title,
            subtitle: dto.subtitle ?? "",
            dueDate: dto.due_date ?? "",
            status: .startTest,
            videos: [],
            documents: []
        )
    }
}

//
//  ResourcesService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 10/03/26.
//

import Foundation
import Supabase

final class ResourcesService {

    static let shared = ResourcesService()
    private init() {}

    func fetchVideos(lessonId: String) async throws -> [VideoDTO] {

        let response = try await SupabaseManager.shared.client
            .from("videos")
            .select()
            .eq("lesson_id", value: lessonId)
            .execute()

        return try JSONDecoder().decode(
            [VideoDTO].self,
            from: response.data
        )
    }

    func fetchDocuments(lessonId: String) async throws -> [DocumentDTO] {

        let response = try await SupabaseManager.shared.client
            .from("documents")
            .select()
            .eq("lesson_id", value: lessonId)
            .execute()

        return try JSONDecoder().decode(
            [DocumentDTO].self,
            from: response.data
        )
    }
}

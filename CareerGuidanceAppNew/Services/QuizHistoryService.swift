//
//  QuizHistoryService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 18/02/26.
//

import Foundation
import Supabase

final class QuizHistoryService {

    static let shared = QuizHistoryService()
    private init() {}

//    func fetchCompletedQuizzes() async throws -> [CompletedQuiz] {
//        guard let userId = UserSessionManager.shared.userId else {
//            return []
//        }
//
//        let response = try await SupabaseManager.shared.client
//            .from("quiz_attempts")
//            .select("""
//                id,
//                lesson_id,
//                score_percent,
//                created_at
//            """)
//            .eq("user_id", value: userId.uuidString)
//            .execute()
//
//        let rows = try JSONSerialization.jsonObject(
//            with: response.data
//        ) as? [[String: Any]] ?? []
//
//        return rows.compactMap { row in
//            guard
//                let lessonId = row["lesson_id"] as? String,
//                let createdAt = row["created_at"] as? String
//            else { return nil }
//
//            return CompletedQuiz(
//                domainTitle: "",
//                moduleTitle: "",
//                lessonId: lessonId,
//                lessonName: "",
//                completedAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),
//                questionResults: []   // We don’t need answers for UI logic
//            )
//        }
//    }
    func fetchCompletedQuizzes() async throws -> [CompletedQuiz] {

        guard let userId = UserSessionManager.shared.userId else {
            return []
        }

        let response = try await SupabaseManager.shared.client
            .from("quiz_attempts")
            .select("""
                lesson_id,
                score_percent,
                completed_at
            """)
            .eq("user_id", value: userId.uuidString)
            .execute()

        let rows = try JSONSerialization.jsonObject(
            with: response.data
        ) as? [[String: Any]] ?? []

        return rows.compactMap { row in

            guard
                let lessonId = row["lesson_id"] as? String,
                let completedAt = row["completed_at"] as? String
            else { return nil }

            return CompletedQuiz(
                domainTitle: "",
                moduleTitle: "",
                lessonId: lessonId,
                lessonName: "",
                completedAt: ISO8601DateFormatter().date(from: completedAt) ?? Date(),
                questionResults: []
            )
        }
    }
    
    func hydrateQuizHistory() async {

        do {

            let quizzes = try await fetchCompletedQuizzes()

            QuizHistoryManager.shared.hydrate(quizzes)

            print("✅ Quiz history hydrated:", quizzes.count)

        } catch {

            print("❌ Failed to hydrate history:", error)

        }
    }
}

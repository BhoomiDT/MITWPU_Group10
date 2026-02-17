//
//  QuizService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 13/02/26.
//


import Foundation
import Supabase

final class QuizService {

    static let shared = QuizService()
    private init() {}
    
    
    func fetchQuizDTO(
        lessonId: String
    ) async throws -> QuizDTO {

        let response = try await SupabaseManager.shared.client
            .from("quizzes")
            .select()
            .eq("lesson_id", value: lessonId)
            .single()
            .execute()

        return try JSONDecoder().decode(
            QuizDTO.self,
            from: response.data
        )
    }

    func fetchQuizQuestions(
        quizId: UUID
    ) async throws -> [QuizQuestionDTO] {

        let response = try await SupabaseManager.shared.client
            .from("quiz_questions")
            .select()
            .eq("quiz_id", value: quizId)
            .order("id", ascending: true)
            .execute()

        return try JSONDecoder().decode(
            [QuizQuestionDTO].self,
            from: response.data
        )
    }
    
    func fetchQuiz(
            lessonId: String
        ) async throws -> Quiz {

            let quizDTO = try await fetchQuizDTO(
                lessonId: lessonId
            )

            let questionDTOs = try await fetchQuizQuestions(
                quizId: quizDTO.id
            )

            return QuizMapper.fromDTO(
                quiz: quizDTO,
                questions: questionDTOs
            )
        }
}

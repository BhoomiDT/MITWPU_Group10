//
//  QuizResultsService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 06/03/26.
//
import Foundation
import Supabase

final class QuizResultsService {

    static let shared = QuizResultsService()
    private init() {}

    func fetchResults(
        attemptId: UUID
    ) async throws -> TestResult {

        let client = SupabaseManager.shared.client

        // Fetch quiz attempt
        let attemptResponse = try await client
            .from("quiz_attempts")
            .select()
            .eq("id", value: attemptId)
            .single()
            .execute()

        let attempt = try JSONDecoder().decode(
            QuizAttemptDTO.self,
            from: attemptResponse.data
        )

        // Temporary insights (same structure as your model)
        let strengths = [
            StrengthItem(title: "Good understanding of concepts"),
            StrengthItem(title: "Strong logical reasoning"),
            StrengthItem(title: "Accurate answer selection")
        ]

        let improvements = [
            ImprovementItem(title: "Review incorrect answers"),
            ImprovementItem(title: "Practice more advanced questions"),
            ImprovementItem(title: "Focus on tricky concepts")
        ]

        return TestResult(
            score: attempt.score_percent ?? 0,
            strengths: strengths,
            improvements: improvements,
            lessonId: attempt.lesson_id
        )
    }
    
    func fetchAnswerResults(
        attemptId: UUID
    ) async throws -> [QuestionResult] {

        let client = SupabaseManager.shared.client

        let response = try await client
            .from("quiz_answers")
            .select("""
                selected_index,
                quiz_questions (
                    question,
                    options,
                    correct_index
                )
            """)
            .eq("attempt_id", value: attemptId)
            .execute()

        let rows = try JSONSerialization.jsonObject(
            with: response.data
        ) as? [[String: Any]] ?? []

        return rows.compactMap { row in

            guard
                let selected = row["selected_index"] as? Int,
                let questionObj = row["quiz_questions"] as? [String: Any],
                let question = questionObj["question"] as? String,
                let options = questionObj["options"] as? [String],
                let correct = questionObj["correct_index"] as? Int
            else { return nil }

            return QuestionResult(
                questionText: question,
                options: options,
                userSelectedIndex: selected,
                correctIndex: correct
            )
        }
    }
}

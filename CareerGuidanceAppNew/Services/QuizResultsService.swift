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
//        let strengths = [
//            StrengthItem(title: "Good understanding of concepts"),
//            StrengthItem(title: "Strong logical reasoning"),
//            StrengthItem(title: "Accurate answer selection")
//        ]
//
//        let improvements = [
//            ImprovementItem(title: "Review incorrect answers"),
//            ImprovementItem(title: "Practice more advanced questions"),
//            ImprovementItem(title: "Focus on tricky concepts")
//        ]
        
        let answers = try await fetchAnswerResults(attemptId: attemptId)
        
        let insights = computeInsights(from: answers)
        
        let strengths = insights.strengths.isEmpty
            ? [StrengthItem(title: "Great performance overall")]
            : insights.strengths.map { StrengthItem(title: formatTopic($0)) }

        let improvements = insights.weaknesses.isEmpty
            ? [ImprovementItem(title: "No major weak areas")]
            : insights.weaknesses.map { ImprovementItem(title: formatTopic($0)) }

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
                    correct_index,
                    question_topic
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
                let correct = questionObj["correct_index"] as? Int,
                let topic = questionObj["question_topic"] as? String
            else { return nil }

            return QuestionResult(
                questionText: question,
                options: options,
                userSelectedIndex: selected,
                correctIndex: correct,
                topic: topic
            )
        }
    }
    
    func computeInsights(from results: [QuestionResult]) -> (strengths: [String], weaknesses: [String]) {

        var correctMap: [String: Int] = [:]
        var wrongMap: [String: Int] = [:]

        for r in results {
            if r.userSelectedIndex == r.correctIndex {
                correctMap[r.topic, default: 0] += 1
            } else {
                wrongMap[r.topic, default: 0] += 1
            }
        }

        let topStrengths = correctMap
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }

        let topWeaknesses = wrongMap
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }

        return (topStrengths, topWeaknesses)
    }
    
    func formatTopic(_ topic: String) -> String {
        return topic
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}

//
//  QuizAttemptService.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 17/02/26.
//

import Supabase
import Foundation

final class QuizAttemptService {
    
    static let shared = QuizAttemptService()
    private init() {}
    
    func submitQuiz(
        quiz: Quiz,
        lesson: Lesson,
        selectedOptionIndices: [Int?]
    ) async throws -> UUID{
        
        let client = SupabaseManager.shared.client
        let userId = UserSessionManager.shared.userId!
        
        print("👤 userId:", userId)
        print("📘 lessonId:", lesson.id)
        print("📝 total questions:", quiz.questions.count)
        
        // 1️⃣ Calculate score
        let correctCount = zip(quiz.questions, selectedOptionIndices).filter {
            $0.1 == $0.0.correctIndex
        }.count
        
        let percentage = Int(
            Double(correctCount) / Double(quiz.questions.count) * 100
        )
        
        // 2️⃣ Insert quiz_attempt
        let attemptDTO = QuizAttemptInsertDTO(
            user_id: userId,
            lesson_id: lesson.id,
            score_percent: percentage,
            correct_count: correctCount,
            total_questions: quiz.questions.count
        )
        
        let attemptResponse = try await client
            .from("quiz_attempts")
            .insert(attemptDTO)
            .select()
            .single()
            .execute()
        
        let attempt = try JSONDecoder()
            .decode(QuizAttemptDTO.self, from: attemptResponse.data)
        
        print("✅ quiz_attempt inserted:", attempt.id)
        
        // 3️⃣ Insert quiz_answers
        for (index, question) in quiz.questions.enumerated() {
            let answerDTO = QuizAnswerInsertDTO(
                attempt_id: attempt.id,
                question_id: question.id,
                selected_index: selectedOptionIndices[index] ?? -1,
            )
            
            try await client
                .from("quiz_answers")
                .insert(answerDTO)
                .execute()
        }
        
        print("✅ quiz_answers inserted")
        
        // 4️⃣ Mark lesson progress
        let progressInsert = UserLessonProgressInsertDTO(
            user_id: userId,
            lesson_id: lesson.id,
            is_completed: true,
            completed_at: Date().ISO8601Format()
        )

        try await client
            .from("user_lesson_progress")
            .upsert(progressInsert)
            .execute()
        
        print("✅ lesson progress saved")
        return attempt.id
    }
    
    func fetchLatestAttempt(
        lessonId: String
    ) async throws -> QuizAttemptDTO? {

        guard let userId = UserSessionManager.shared.userId else {
            return nil
        }

        let response = try await SupabaseManager.shared.client
            .from("quiz_attempts")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("lesson_id", value: lessonId)
            .order("completed_at", ascending: false)
            .limit(1)
            .execute()

        let attempts = try JSONDecoder()
            .decode([QuizAttemptDTO].self, from: response.data)

        return attempts.first
    }
    
}

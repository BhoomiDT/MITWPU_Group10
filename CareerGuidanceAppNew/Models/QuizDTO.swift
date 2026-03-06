//
//  QuizDTO.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 13/02/26.
//

import Foundation

struct QuizDTO: Decodable {
    let id: UUID
    let lessonId: String
    let lessonName: String
    let durationMinutes: Int
    let passingPercent: Int

    enum CodingKeys: String, CodingKey {
        case id
        case lessonId = "lesson_id"
        case lessonName = "lesson_name"
        case durationMinutes = "duration_minutes"
        case passingPercent = "passing_percent"
    }
}

struct QuizQuestionDTO: Decodable {
    let id: UUID
    let quizId: UUID
    let question: String
    let options: [String]
    let correctIndex: Int

    enum CodingKeys: String, CodingKey {
        case id
        case quizId = "quiz_id"
        case question
        case options
        case correctIndex = "correct_index"
    }
}

struct QuizAttemptDTO: Decodable {
    let id: UUID
    let lesson_id: String
    let score_percent: Int?
    let created_at: String?
}
struct QuizAttemptInsertDTO: Encodable {
    let user_id: UUID
    let lesson_id: String
    let score_percent: Int
    let correct_count: Int
    let total_questions: Int
}

struct QuizAnswerInsertDTO: Encodable {
    let attempt_id: UUID
    let question_id: UUID
    let selected_index: Int
}
struct UserLessonProgressInsertDTO: Encodable {
    let user_id: UUID
    let lesson_id: String
    let is_completed: Bool
    let completed_at: String
}

enum QuizState {
    case notStarted
    case completed(score: Int, passed: Bool)
}



enum QuizMapper {

    static func fromDTO(
        quiz: QuizDTO,
        questions: [QuizQuestionDTO]
    ) -> Quiz {

        Quiz(
            lessonId: quiz.lessonId,
            lessonName: quiz.lessonName,
            durationMinutes: quiz.durationMinutes,
            passingPercent: quiz.passingPercent,
            questions: questions.map {
                QuizQuestion(
                    id: $0.id,
                    question: $0.question,
                    options: $0.options,
                    correctIndex: $0.correctIndex
                )
            }
        )
    }
}

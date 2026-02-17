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

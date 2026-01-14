//
//  QuizHistoryManager.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 09/01/26.
//
import Foundation

class QuizHistoryManager {

    static let shared = QuizHistoryManager()
    private init() {}

    private(set) var completedQuizzes: [CompletedQuiz] = []

    func save(_ quiz: CompletedQuiz) {
        completedQuizzes.append(quiz)
    }

    func quizzes(for lessonId: String) -> [CompletedQuiz] {
        completedQuizzes.filter { $0.lessonId == lessonId }
    }
    
    func hasCompletedQuiz(for lessonId: String) -> Bool {
        completedQuizzes.contains { $0.lessonId == lessonId }
    }
}

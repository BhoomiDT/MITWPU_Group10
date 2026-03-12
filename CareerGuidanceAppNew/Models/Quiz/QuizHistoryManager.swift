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

    private(set) var completedLessonIds: Set<String> = []

    func hydrate(_ quizzes: [CompletedQuiz]) {

        completedLessonIds = Set(
            quizzes.map { $0.lessonId }
        )

        print("QuizHistory hydrated:", completedLessonIds)
    }

    func hasCompletedQuiz(for lessonId: String) -> Bool {
        completedLessonIds.contains(lessonId)
    }
}

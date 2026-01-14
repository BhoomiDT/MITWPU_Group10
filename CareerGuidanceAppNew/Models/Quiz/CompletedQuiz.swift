//
//  CompletedQuiz.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 09/01/26.
//
import Foundation

struct CompletedQuiz {

    let domainTitle: String
    let moduleTitle: String
    let lessonId: String
    let lessonName: String
    let completedAt: Date

    let questionResults: [QuestionResult]

    var totalQuestions: Int {
        questionResults.count
    }

    var correctCount: Int {
        questionResults.filter { $0.isCorrect }.count
    }

    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        let percent = Double(correctCount) / Double(totalQuestions) * 100
        return Int(percent.rounded())
    }
}

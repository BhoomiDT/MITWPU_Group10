//
//  QuestionResult.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import Foundation

struct QuestionResult {

    let questionText: String
    let options: [String]

    let userSelectedIndex: Int?
    let correctIndex: Int

    var isCorrect: Bool {
        guard let selected = userSelectedIndex else { return false }
        return selected == correctIndex
    }
}

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

//
//  Quiz.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import Foundation

struct Quiz {
    let lessonName: String
    let durationMinutes: Int
    let passingPercent: Int
    let questions: [QuizQuestion]
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctIndex: Int
}

//
//  JourneyModel.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/01/26.
//


import Foundation

struct JourneyStats {
    var days: Int
    var quizzes: Int
    var quests: Int
    var lastActiveDate: Date?
}

struct JourneyModel {

    static var shared = JourneyStats(
        days: 0,
        quizzes: 0,
        quests: 0,
        lastActiveDate: nil
    )
    
    // MARK: Quiz completed
    static func incrementStatsAfterQuiz() {
        shared.quizzes += 1
    }

    // MARK: Quest completed
    static func incrementQuest() {
        shared.quests += 1
    }

    // MARK: Update Learning Days
    static func updateLearningDay() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = shared.lastActiveDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            if today > lastDay {
                shared.days += 1
                shared.lastActiveDate = today
            }
        } else {
            shared.days = 1
            shared.lastActiveDate = today
        }
    }
}

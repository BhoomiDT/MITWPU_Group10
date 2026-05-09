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
    var articlesRead: Int
    var modulesCompleted: Int
    var bugsFixed: Int
    var fastAnswers: Int
    var sharedActivities: Int
    var creativeSolutions: Int
    var codingChallenges: Int
    var bugsSolved: Int
    var systemArchitectures: Int
    var lastActiveDate: Date?
}

struct JourneyModel {

    static var shared = JourneyStats(
        days: 0,
        quizzes: 0,
        quests: 0,
        articlesRead: 0,
        modulesCompleted: 0,
        bugsFixed: 0,
        fastAnswers: 0,
        sharedActivities: 0,
        creativeSolutions: 0,
        codingChallenges: 0,
        bugsSolved: 0,
        systemArchitectures: 0,
        lastActiveDate: nil
    )
    
    // MARK: Stats Increments
    static func incrementQuizzes() { shared.quizzes += 1 }
    static func incrementQuests() { shared.quests += 1 }
    static func incrementArticles() { shared.articlesRead += 1 }
    static func incrementModules() { shared.modulesCompleted += 1 }
    static func incrementBugsFixed() { shared.bugsFixed += 1 }
    static func incrementFastAnswers() { shared.fastAnswers += 1 }
    static func incrementSharedActivities() { shared.sharedActivities += 1 }
    static func incrementCreativeSolutions() { shared.creativeSolutions += 1 }
    static func incrementCodingChallenges() { shared.codingChallenges += 1 }
    static func incrementBugsSolved() { shared.bugsSolved += 1 }
    static func incrementSystemArchitectures() { shared.systemArchitectures += 1 }

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
    
    // MARK: Sync with Supabase
    static func syncWithProfile(_ profile: UserProfile) {
        shared.days = profile.learning_days ?? 0
        shared.quizzes = profile.completed_quizzes ?? 0
        shared.quests = profile.quests_completed ?? 0
        shared.modulesCompleted = profile.quests_completed ?? 0 // Mapping quests to modules for now
    }
}

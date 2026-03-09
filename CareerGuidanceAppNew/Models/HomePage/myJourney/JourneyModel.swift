import Foundation

struct JourneyStats {
    var days: Int
    var quizzes: Int
    var quests: Int
    var streak: Int
    var lastActiveDate: Date?
}

struct JourneyModel {

    static var shared = JourneyStats(
        days: 0,
        quizzes: 0,
        quests: 0,
        streak: 0,
        lastActiveDate: nil
    )
    static var completedMilestones: Set<String> = []

    // MARK: Quiz completed
    static func incrementStatsAfterQuiz() {
        shared.quizzes += 1
    }

    // MARK: Quest completed
    static func incrementQuest() {
        shared.quests += 1
    }

    // MARK: App opened today
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

    // MARK: XP earned → check streak
    static func updateStreakAfterXP(totalXP: Int) {

        if totalXP < 20 { return }

        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = shared.lastActiveDate {

            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

            if Calendar.current.isDate(lastDate, inSameDayAs: yesterday) {
                shared.streak += 1
            }
            else if !Calendar.current.isDate(lastDate, inSameDayAs: today) {
                shared.streak = 1
            }

        } else {
            shared.streak = 1
        }

        shared.lastActiveDate = today
    }
}

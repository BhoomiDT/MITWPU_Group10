import Foundation

struct JourneyStats {
    var days: Int
    var quizzes: Int
    var quests: Int
}

struct JourneyModel {
    static var shared = JourneyStats(
        days: 0,
        quizzes: 0,
        quests: 0
    )
    
    static func incrementStatsAfterQuiz() {
        shared.quizzes += 1
        
        
    }
}

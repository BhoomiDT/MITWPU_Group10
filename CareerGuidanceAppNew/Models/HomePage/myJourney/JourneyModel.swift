import Foundation

struct JourneyStats {
    var days: Int
    var quizzes: Int
    var quests: Int
}

struct JourneyModel {
    static var shared = JourneyStats(
        days: 17,
        quizzes: 5,
        quests: 3
    )
    
    static func incrementStatsAfterQuiz() {
        shared.quizzes += 1
        
        
    }
}

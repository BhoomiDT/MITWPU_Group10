import Foundation

struct UserProfile: Codable {
    let id: UUID
    var email: String?
    var full_name: String?
    var technical_skills: [String]
    var riasec_scores: [String: Double]
    var onboarding_completed: Bool
    var recommended_domain: String?
    
    // Stats
    var learning_streak: Int
    var completed_quizzes: Int
    var learning_days: Int
    var quests_completed: Int
    var xp: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case full_name
        case technical_skills
        case riasec_scores
        case onboarding_completed
        case recommended_domain
        case learning_streak
        case completed_quizzes
        case learning_days
        case quests_completed
        case xp
    }
}

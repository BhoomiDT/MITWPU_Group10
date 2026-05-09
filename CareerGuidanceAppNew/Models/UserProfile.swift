import Foundation

struct UserProfile: Codable {
    let id: UUID
    var email: String?
    var full_name: String?
    var technical_skills: [String]?
    var riasec_scores: [String: Double]?
    var onboarding_completed: Bool?
    var recommended_domain: String?
    
    // Stats
    var learning_streak: Int?
    var completed_quizzes: Int?
    var learning_days: Int?
    var quests_completed: Int?
    var xp: Int?
    
    // New Fields
    var phone: String?
    var dob: String? // Using String for Date YYYY-MM-DD from DB
    var gender: String?
    var college_degree: String?
    var career_interests: [String]?
    var bio: String?
    var resume_url: String?
    var linkedin_url: String?
    var github_url: String?
    var app_settings: [String: Bool]? // Simple dictionary for JSONB toggles
    
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
        case phone
        case dob
        case gender
        case college_degree
        case career_interests
        case bio
        case resume_url
        case linkedin_url
        case github_url
        case app_settings
    }
}

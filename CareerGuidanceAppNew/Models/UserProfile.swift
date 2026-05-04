import Foundation

struct UserProfile: Codable {
    let id: UUID
    var email: String?
    var full_name: String?
    var technical_skills: [String]
    var riasec_scores: [String: Double]
    var onboarding_completed: Bool
    var recommended_domain: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case full_name
        case technical_skills
        case riasec_scores
        case onboarding_completed
        case recommended_domain
    }
}

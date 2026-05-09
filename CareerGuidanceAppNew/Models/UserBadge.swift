import Foundation

struct UserBadge: Codable {
    let id: UUID
    let user_id: UUID
    let badge_name: String
    let earned_at: String?
}

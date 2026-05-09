import Foundation
import Supabase

class BadgeService {
    static let shared = BadgeService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    func fetchUserBadges() async throws -> [UserBadge] {
        guard let userId = try? await client.auth.session.user.id else {
            return []
        }
        
        return try await client.from("user_badges")
            .select()
            .eq("user_id", value: userId)
            .order("earned_at", ascending: false)
            .execute()
            .value
    }
    
    func awardBadge(badgeName: String) async {
        guard let userId = try? await client.auth.session.user.id else { return }
        
        let newBadge = ["user_id": userId.uuidString, "badge_name": badgeName]
        
        do {
            try await client.from("user_badges")
                .insert(newBadge)
                .execute()
            print("🎉 Earned new badge: \(badgeName)")
        } catch {
            print("Could not award badge or badge already exists: \(error)")
        }
    }
}

import Foundation
import Supabase

class LeaderboardService {
    static let shared = LeaderboardService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    /// Fetches profiles from Supabase sorted by XP descending for the leaderboard
    func fetchLeaderboardProfiles() async throws -> [UserProfile] {
        do {
            let profiles: [UserProfile] = try await client.from("profiles")
                .select()
                .order("xp", ascending: false)
                .limit(100)
                .execute()
                .value
            return profiles
        } catch {
            print("⚠️ Error fetching leaderboard from Supabase: \(error)")
            throw error
        }
    }
}

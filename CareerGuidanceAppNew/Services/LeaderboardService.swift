import Foundation
import Supabase

enum LeaderboardType {
    case daily, weekly, monthly, allTime
}

class LeaderboardService {
    static let shared = LeaderboardService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    func fetchLeaderboard(for type: LeaderboardType) async throws -> [LeaderboardEntry] {
        let xpColumn: String
        switch type {
        case .daily: xpColumn = "daily_xp"
        case .weekly: xpColumn = "weekly_xp"
        case .monthly: xpColumn = "monthly_xp"
        case .allTime: xpColumn = "xp"
        }
        
        var profiles: [UserProfile] = []
        
        do {
            // Attempt to fetch with the requested timeframe column
            profiles = try await client.from("profiles")
                .select()
                .order(xpColumn, ascending: false)
                .limit(100)
                .execute()
                .value
        } catch {
            print("⚠️ Leaderboard column '\(xpColumn)' not found, falling back to 'xp'")
            // Fallback to global XP if columns aren't in Supabase yet
            profiles = try await client.from("profiles")
                .select()
                .order("xp", ascending: false)
                .limit(100)
                .execute()
                .value
        }
        
        // Map to LeaderboardEntry
        var entries: [LeaderboardEntry] = []
        for (index, profile) in profiles.enumerated() {
            let xpValue: Int
            switch type {
            case .daily: xpValue = profile.daily_xp ?? profile.xp ?? 0
            case .weekly: xpValue = profile.weekly_xp ?? profile.xp ?? 0
            case .monthly: xpValue = profile.monthly_xp ?? profile.xp ?? 0
            case .allTime: xpValue = profile.xp ?? 0
            }
            
            let entry = LeaderboardEntry(
                id: profile.id,
                rank: index + 1,
                name: profile.full_name ?? "User",
                xp: xpValue,
                imageName: nil
            )
            entries.append(entry)
        }
        
        return entries
    }
}

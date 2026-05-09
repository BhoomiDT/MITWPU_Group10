//
//  UserStats.swift
//  CareerGuidanceAppNew
//

import Foundation
import Supabase

struct UserStats {
    var xp: Int
    var streak: Int
    var badges: Int
    
    static var shared = UserStats.load()
    
    private static let xpKey = "user_xp"
    private static let streakKey = "user_streak"
    private static let lastActiveKey = "user_last_active"
    private static let badgesKey = "user_badges"
    
    mutating func addXP(_ amount: Int) {
        xp += amount
        save()
        
        // After adding XP, check if we should increment the streak
        updateStreak()
    }
    
    mutating func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        let defaults = UserDefaults.standard
        
        let lastActive = defaults.object(forKey: Self.lastActiveKey) as? Date
        
        if let last = lastActive {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if diff == 1 {
                // It was yesterday! Increment streak.
                streak += 1
            } else if diff > 1 {
                // We missed a day. Reset to 1.
                streak = 1
            }
            // If diff == 0, they already did something today, so do nothing.
            
        } else {
            // First time ever doing an activity
            streak = 1
        }
        
        defaults.set(today, forKey: Self.lastActiveKey)
        save()
    }
    
    private mutating func save() {
        let defaults = UserDefaults.standard
        defaults.set(xp, forKey: Self.xpKey)
        defaults.set(streak, forKey: Self.streakKey)
        defaults.set(badges, forKey: Self.badgesKey)
    }
    
    private static func load() -> UserStats {
        let defaults = UserDefaults.standard
        return UserStats(
            xp: defaults.integer(forKey: xpKey),
            streak: defaults.integer(forKey: streakKey),
            badges: defaults.integer(forKey: badgesKey)
        )
    }

    mutating func syncFromSupabase() async {
        do {
            // Fetch profile for XP and Streak
            let profile = try await ProfileService.shared.fetchProfile()
            self.xp = profile.xp ?? 0
            self.streak = profile.learning_streak ?? 0
            
            // Fetch badge count
            let userBadges = try await BadgeService.shared.fetchUserBadges()
            self.badges = userBadges.count
            
            self.save()
            
            // Also sync JourneyModel while we have the profile
            JourneyModel.syncWithProfile(profile)
        } catch {
            print("Failed to sync stats from Supabase:", error)
        }
    }
}

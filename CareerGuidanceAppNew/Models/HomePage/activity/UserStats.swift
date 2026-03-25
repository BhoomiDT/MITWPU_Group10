//
//  UserStats.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/01/26.
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
    }
    
    mutating func updateStreak() {
        
        let today = Calendar.current.startOfDay(for: Date())
        
        let lastActive = UserDefaults.standard.object(forKey: Self.lastActiveKey) as? Date
        
        if let last = lastActive {
            
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if diff == 1 {
                streak += 1
            } else if diff > 1 {
                streak = 1
            }
            
        } else {
            streak = 1
        }
        
        UserDefaults.standard.set(today, forKey: Self.lastActiveKey)
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

    mutating func syncXpFromSupabase() async {
        guard let userId = UserSessionManager.shared.userId else { return }
        do {
            struct Attempt: Decodable {
                let correct_count: Int?
            }
            
            let response = try await SupabaseManager.shared.client
                .from("quiz_attempts")
                .select("correct_count")
                .eq("user_id", value: userId.uuidString)
                .execute()
                
            let attempts = try JSONDecoder().decode([Attempt].self, from: response.data)
            
            var calculatedXP = 100 // ONBOARDING BASE XP
            for att in attempts {
                let correctCount = att.correct_count ?? 0
                calculatedXP += (correctCount * 10)
            }
            
            // Re-save so it is persistently available fast.
            DispatchQueue.main.async {
                self.xp = calculatedXP
                self.save()
            }
        } catch {
            print("Failed to sync XP from Supabase:", error)
        }
    }
}

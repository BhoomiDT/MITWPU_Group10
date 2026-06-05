import Foundation
import Supabase

class ProfileService {
    static let shared = ProfileService()
    private let client = SupabaseManager.shared.client
    
    /// Cached user display name, populated during sync
    var cachedName: String? {
        get {
            UserDefaults.standard.string(forKey: "kCachedUserFullName")
        }
        set {
            if let newValue = newValue, newValue != "null" && !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: "kCachedUserFullName")
            }
        }
    }
    
    private init() {}
    
    func fetchProfile() async throws -> UserProfile {
        guard let userId = try? await client.auth.session.user.id else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        do {
            return try await client.from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
        } catch let error as PostgrestError where error.code == "PGRST116" {
            // No profile found, return an empty default profile
            return UserProfile(id: userId, email: nil, full_name: nil, technical_skills: [], riasec_scores: [:], onboarding_completed: false, recommended_domain: nil, learning_streak: 0, completed_quizzes: 0, learning_days: 0, quests_completed: 0, xp: 0)
        }
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        try await client.from("profiles")
            .upsert(profile)
            .execute()
    }
    
    func syncLocalToRemote() async {
        guard let session = try? await client.auth.session else { return }
        let userId = session.user.id
        
        // Try to get name from session metadata if available
        let metadata = session.user.userMetadata
        var name = metadata["full_name"]?.description.replacingOccurrences(of: "\"", with: "")
        if name == "null" || name == "" {
            name = nil
        }
        
        let resolvedName = name ?? self.cachedName
        if let resolvedName = resolvedName {
            self.cachedName = resolvedName
        }
        
        let profile = UserProfile(
            id: userId,
            email: session.user.email,
            full_name: resolvedName,
            technical_skills: OnboardingManager.shared.technicalSkills,
            riasec_scores: OnboardingManager.shared.riasecScoresMap,
            onboarding_completed: OnboardingManager.shared.isOnboardingCompleted,
            recommended_domain: UserDefaults.standard.string(forKey: "kRecommendedDomainName"),
            learning_streak: UserStats.shared.streak,
            completed_quizzes: JourneyModel.shared.quizzes,
            learning_days: JourneyModel.shared.days,
            quests_completed: JourneyModel.shared.quests,
            xp: UserStats.shared.xp
        )
        
        do {
            try await updateProfile(profile)
            print("✅ Profile synced to Supabase")
        } catch {
            print("❌ Failed to sync profile: \(error)")
        }
    }
    
    func syncRemoteToLocal() async {
        do {
            let profile = try await fetchProfile()
            
            // Cache name for greeting with Auth metadata fallback
            if let fullName = profile.full_name, !fullName.isEmpty, fullName != "null" {
                self.cachedName = fullName
            } else if let session = try? await client.auth.session {
                let metadata = session.user.userMetadata
                if let name = metadata["full_name"]?.description.replacingOccurrences(of: "\"", with: ""), name != "null", !name.isEmpty {
                    self.cachedName = name
                    var updatedProfile = profile
                    updatedProfile.full_name = name
                    try? await updateProfile(updatedProfile)
                }
            }
            
            // Sync to OnboardingManager/UserDefaults
            OnboardingManager.shared.technicalSkills = profile.technical_skills ?? []
            OnboardingManager.shared.riasecScoresMap = profile.riasec_scores ?? [:]
            OnboardingManager.shared.isOnboardingCompleted = profile.onboarding_completed ?? false
            
            if let domain = profile.recommended_domain {
                UserDefaults.standard.set(domain, forKey: "kRecommendedDomainName")
            }
            
            // Sync Stats back to local managers
            UserStats.shared.xp = profile.xp ?? 0
            UserStats.shared.streak = profile.learning_streak ?? 0
            JourneyModel.shared.quizzes = profile.completed_quizzes ?? 0
            JourneyModel.shared.days = profile.learning_days ?? 0
            JourneyModel.shared.quests = profile.quests_completed ?? 0
            
            print("✅ Profile synced from Supabase")
        } catch {
            print("❌ Failed to fetch profile from Supabase: \(error)")
        }
    }
}

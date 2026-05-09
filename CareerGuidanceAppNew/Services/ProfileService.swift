import Foundation
import Supabase

class ProfileService {
    static let shared = ProfileService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    func fetchProfile() async throws -> UserProfile {
        guard let userId = try? await client.auth.session.user.id else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        return try await client.from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value
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
        let name = metadata["full_name"]?.description.replacingOccurrences(of: "\"", with: "")
        
        let profile = UserProfile(
            id: userId,
            email: session.user.email,
            full_name: name,
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

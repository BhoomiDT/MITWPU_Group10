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
        guard let userId = try? await client.auth.session.user.id else { return }
        
        let profile = UserProfile(
            id: userId,
            email: nil, // Auth handles this mostly
            full_name: nil, // Can be added later
            technical_skills: OnboardingManager.shared.technicalSkills,
            riasec_scores: OnboardingManager.shared.riasecScoresMap,
            onboarding_completed: OnboardingManager.shared.isOnboardingCompleted,
            recommended_domain: UserDefaults.standard.string(forKey: "kRecommendedDomainName")
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
            OnboardingManager.shared.technicalSkills = profile.technical_skills
            OnboardingManager.shared.riasecScoresMap = profile.riasec_scores
            OnboardingManager.shared.isOnboardingCompleted = profile.onboarding_completed
            
            if let domain = profile.recommended_domain {
                UserDefaults.standard.set(domain, forKey: "kRecommendedDomainName")
            }
            
            print("✅ Profile synced from Supabase")
        } catch {
            print("❌ Failed to fetch profile from Supabase: \(error)")
        }
    }
}

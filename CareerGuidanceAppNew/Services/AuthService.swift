import Supabase

final class AuthService {

    static let shared = AuthService()
    private init() {}

    func ensureAnonymousUser() async {
        let client = SupabaseManager.shared.client

        do {
            // 1️⃣ Try to get existing session
            let session = try await client.auth.session

            UserSessionManager.shared.setUserId(session.user.id)
            print("✅ Existing session found")

        } catch {
            // 2️⃣ No session → create anonymous user
            do {
                let response = try await client.auth.signInAnonymously()

                UserSessionManager.shared.setUserId(response.user.id)
                print("🆕 Anonymous user created")

            } catch {
                print("❌ Failed to create anonymous user:", error)
            }
        }
    }
}

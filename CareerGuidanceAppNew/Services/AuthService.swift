import Supabase

final class AuthService {

    static let shared = AuthService()
    private init() {}

    func signUp(email: String, password: String) async throws {
        let client = SupabaseManager.shared.client
        let response = try await client.auth.signUp(email: email, password: password)
        UserSessionManager.shared.setUserId(response.user.id)
        print("✅ User signed up successfully: \(response.user.id)")
    }

    func signIn(email: String, password: String) async throws {
        let client = SupabaseManager.shared.client
        let response = try await client.auth.signIn(email: email, password: password)
        UserSessionManager.shared.setUserId(response.user.id)
        print("✅ User signed in successfully: \(response.user.id)")
    }

    func signOut() async throws {
        let client = SupabaseManager.shared.client
        try await client.auth.signOut()
        UserSessionManager.shared.clear()
        print("✅ User signed out")
    }

    func ensureAnonymousUser() async {
        let client = SupabaseManager.shared.client

        do {
            // 1️⃣ Try to get existing session
            let session = try await client.auth.session

            UserSessionManager.shared.setUserId(session.user.id)
            print("✅ Existing session found: \(session.user.id)")

        } catch {
            // 2️⃣ No session → we don't automatically create anonymous user anymore
            // as the user wants specific data for signed users.
            print("ℹ️ No active session found. User needs to login.")
        }
    }
}

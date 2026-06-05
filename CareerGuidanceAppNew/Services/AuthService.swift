import Supabase
import Foundation
final class AuthService {

    static let shared = AuthService()
    private init() {}

    func signUp(email: String, password: String, fullName: String? = nil) async throws {
        let client = SupabaseManager.shared.client
        var data: [String: AnyJSON] = [:]
        if let name = fullName {
            data["full_name"] = .string(name)
        }
        
        let response = try await client.auth.signUp(
            email: email,
            password: password,
            data: data
        )
        UserSessionManager.shared.setUserId(response.user.id)
        if let name = fullName {
            ProfileService.shared.cachedName = name
        }
        print("✅ User signed up successfully with name: \(fullName ?? "None")")
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

    func sendMFAOTP(email: String, userId: Foundation.UUID) async throws {
        let client = SupabaseManager.shared.client
        let payload = [
            "action": "send",
            "email": email,
            "userId": userId.uuidString.lowercased()
        ]
        
        // Invoke the Edge Function
        _ = try await client.functions.invoke("mfa-otp", options: FunctionInvokeOptions(body: payload))
        print("📲 OTP request sent to Edge Function")
    }

    func verifyMFAOTP(email: String, otp: String) async throws -> Bool {
        let client = SupabaseManager.shared.client
        let payload = [
            "action": "verify",
            "email": email,
            "otp": otp
        ]
        
        do {
            _ = try await client.functions.invoke("mfa-otp", options: FunctionInvokeOptions(body: payload))
            print("✅ OTP Verified successfully")
            return true
        } catch {
            print("❌ OTP Verification failed: \(error)")
            throw error
        }
    }
}

//
//  UserDataManager.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import Foundation

class UserDataManager {
    
    private static var registeredUsers: [String: User] = [:]
    
    static func preloadTestData() {
        let testUser = User(
            username: "JaneDoe",
            email: "janedoe@example.com",
            password: "password123",
            confirmPassword: "Jane Doe"
        )
        registeredUsers[testUser.email] = testUser
    }
        
    static func registerUser(newUser: User) -> Bool {
        if registeredUsers.keys.contains(newUser.email) {
            return false // Registration failed: Email already in use
        }
        
        registeredUsers[newUser.email] = newUser
        print("User registered: \(newUser.email)")
        return true // Registration successful
    }
        
    static func signIn(email: String, passwordAttempt: String) -> User? {
        
        guard let storedUser = registeredUsers[email] else {
            return nil // Sign-in failed: User (email) not found
        }
        
        if storedUser.password == passwordAttempt {
            return storedUser // Sign-in successful
        } else {
            return nil // Sign-in failed: Incorrect password
        }
    }
}

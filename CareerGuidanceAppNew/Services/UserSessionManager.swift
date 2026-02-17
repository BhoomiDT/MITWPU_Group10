//
//  UserSessionManager.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 17/02/26.
//

import Foundation
import Supabase

final class UserSessionManager {

    static let shared = UserSessionManager()
    private init() {}

    private(set) var userId: UUID?

    func setUserId(_ id: UUID) {
        self.userId = id
        print("👤 User ID set:", id)
    }

    func clear() {
        userId = nil
    }
}

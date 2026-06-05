//
//  SupabaseManager.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/02/26.
//

import Foundation
import Supabase

class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    let supabaseKey: String
    private init() {
        // Using hardcoded values as fallback if Info.plist variables are not resolved
        let sbURL = (Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String) ?? ""
        let resolvedURL: String
        
        if sbURL.isEmpty || sbURL == "$(SUPABASE_URL)" {
            resolvedURL = "xffbxethqutrkgwyiick.supabase.co"
        } else {
            resolvedURL = sbURL
        }

        let supabaseURL = "https://\(resolvedURL)"
        print("Initializing Supabase with URL: \(supabaseURL)")

        let sbKey = (Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String) ?? ""
        let resolvedKey: String
        
        if sbKey.isEmpty || sbKey == "$(SUPABASE_KEY)" {
            resolvedKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmZmJ4ZXRocXV0cmtnd3lpaWNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4MDAzNjcsImV4cCI6MjA4NjM3NjM2N30._0gEE8TTSogvf4OrMEc5MBdWqO_MIQeZ8Shp6oAUw1g"
        } else {
            resolvedKey = sbKey
        }

        self.supabaseKey = resolvedKey
        client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: resolvedKey
        )
    }

}


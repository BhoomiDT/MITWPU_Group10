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
    private init() {
        guard let sbURL = Bundle.main.object(
            forInfoDictionaryKey: "SUPABASE_URL"
        ) as? String else {
            fatalError("SUPABASE_URL not found in Info.plist")
        }

        let supabaseURL = "https://\(sbURL)"
        print(supabaseURL)

        client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: Bundle.main.object(
                forInfoDictionaryKey: "SUPABASE_KEY"
            ) as! String
        )
    }

}


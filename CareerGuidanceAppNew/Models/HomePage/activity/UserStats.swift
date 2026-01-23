//import Foundation
//
//struct UserStats {
//    let xp: Int
//    let streak: Int
//    let badges: Int
//    
//   
//    static let demo = UserStats(xp: 120, streak: 7, badges: 15)
//}

import Foundation

struct UserStats {
    var xp: Int  // Changed to var
    let streak: Int
    let badges: Int
    
    // Create a shared instance to manage the global state
    static var shared = UserStats(xp: 120, streak: 7, badges: 15)
    
    // Function to add XP
    mutating func addXP(_ amount: Int) {
        self.xp += amount
    }
}

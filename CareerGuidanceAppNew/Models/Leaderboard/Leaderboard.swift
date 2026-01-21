//
//  Leaderboard.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//
// Data Structure
struct LeaderboardEntry {
    let rank: Int
    let name: String
    let xp: Int
    let imageName: String?
}

// Dummy Data (Ranks 1-10, sorted by XP)
let dailyLeaderboard: [LeaderboardEntry] = [
    // Ranks 1-3 (for Top 3 section)
    LeaderboardEntry(rank: 1, name: "Walter", xp: 540, imageName: "Image 1"),
    LeaderboardEntry(rank: 2, name: "Amanda", xp: 500, imageName: "Image 2"),
    LeaderboardEntry(rank: 3, name: "Jay", xp: 480, imageName: "Image 4"),
    // Ranks 4-10 (for Table View list)
    LeaderboardEntry(rank: 4, name: "Parth", xp: 460, imageName: nil),
    LeaderboardEntry(rank: 5, name: "Amruta", xp: 450, imageName: nil),
    LeaderboardEntry(rank: 6, name: "Atharva", xp: 440, imageName: nil),
    LeaderboardEntry(rank: 7, name: "You", xp: 420, imageName: nil),
    LeaderboardEntry(rank: 8, name: "Vidhi", xp: 400, imageName: nil),
    LeaderboardEntry(rank: 9, name: "Arohi", xp: 390, imageName: nil),
    LeaderboardEntry(rank: 10, name: "John", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 11, name: "Siya", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 12, name: "Reya", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 13, name: "Julia", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 14, name: "Patrick", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 15, name: "Hamza", xp: 360, imageName: nil),
]

let weeklyLeaderboard: [LeaderboardEntry] = [    // Ranks 1-3 (for Top 3 section)
    LeaderboardEntry(rank: 1, name: "Jessica", xp: 540, imageName: "Image"),
    LeaderboardEntry(rank: 2, name: "Walter", xp: 500, imageName: "Image 1"),
    LeaderboardEntry(rank: 3, name: "Amanda", xp: 480, imageName: "Image 2"),
    // Ranks 4-10 (for Table View list)
    LeaderboardEntry(rank: 4, name: "Bhoomi", xp: 470, imageName: nil),
    LeaderboardEntry(rank: 5, name: "You", xp: 460, imageName: nil),
    LeaderboardEntry(rank: 6, name: "Chandler", xp: 450, imageName: nil),
    LeaderboardEntry(rank: 7, name: "Ross", xp: 420, imageName: nil),
    LeaderboardEntry(rank: 8, name: "Phoebe", xp: 400, imageName: nil),
    LeaderboardEntry(rank: 9, name: "Aman", xp: 390, imageName: nil),
    LeaderboardEntry(rank: 10, name: "John", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 11, name: "Kavin", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 12, name: "Rhea", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 13, name: "Anushka", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 14, name: "Yash", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 15, name: "Levis", xp: 360, imageName: nil),
]

let monthlyLeaderboard: [LeaderboardEntry] = [    // Ranks 1-3 (for Top 3 section)
    LeaderboardEntry(rank: 1, name: "Jay", xp: 540, imageName: "Image 4"),
    LeaderboardEntry(rank: 2, name: "Sheldon", xp: 500, imageName: "Image 3"),
    LeaderboardEntry(rank: 3, name: "Jessica", xp: 480, imageName: "Image"),
    // Ranks 4-10 (for Table View list)
    LeaderboardEntry(rank: 4, name: "Varsha", xp: 480, imageName: nil),
    LeaderboardEntry(rank: 5, name: "Parth", xp: 475, imageName: nil),
    LeaderboardEntry(rank: 6, name: "Aman", xp: 460, imageName: nil),
    LeaderboardEntry(rank: 7, name: "Vidhi", xp: 420, imageName: nil),
    LeaderboardEntry(rank: 8, name: "Harsh", xp: 400, imageName: nil),
    LeaderboardEntry(rank: 9, name: "Tanishka", xp: 390, imageName: nil),
    LeaderboardEntry(rank: 10, name: "Arohi", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 11, name: "You", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 12, name: "John", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 13, name: "Jessy", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 14, name: "Tyrion", xp: 360, imageName: nil),
    LeaderboardEntry(rank: 15, name: "Stranger", xp: 360, imageName: nil),
]



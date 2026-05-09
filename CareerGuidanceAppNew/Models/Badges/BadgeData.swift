//
//  BadgeData.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//
import UIKit

enum BadgeType: String, Codable {
    case xpBased = "xp"
    case milestoneBased = "milestone"
}

enum MilestoneType: String, Codable {
    case goalsCompleted
    case articlesRead
    case modulesCompleted
    case quizzesPassed
    case bugsFixed
    case fastAnswers
    case sharedActivities
    case creativeSolutions
    case codingChallenges
    case bugsSolved
    case systemArchitectures
}

struct Badge {
    let id: Int
    let title: String
    let subtitle: String?
    let iconName: String
    let color: UIColor?
    let badgeType: BadgeType
    let milestoneType: MilestoneType?
    let requiredCount: Int
    let unlockReason: String
    
    var requiredXP: Int {
        return badgeType == .xpBased ? requiredCount : 0
    }
    
    func isUnlocked(userXP: Int, stats: JourneyStats) -> Bool {
        switch badgeType {
        case .xpBased:
            return userXP >= requiredCount
        case .milestoneBased:
            let current = getCurrentMilestoneCount(stats: stats)
            return current >= requiredCount
        }
    }
    
    func calculateProgress(userXP: Int, stats: JourneyStats) -> Float {
        let current: Int
        let required: Int = requiredCount
        
        switch badgeType {
        case .xpBased:
            current = userXP
        case .milestoneBased:
            current = getCurrentMilestoneCount(stats: stats)
        }
        
        if required == 0 { return 1.0 }
        return min(Float(current) / Float(required), 1.0)
    }
    
    func getProgressText(userXP: Int, stats: JourneyStats) -> String {
        switch badgeType {
        case .xpBased:
            return "\(userXP) / \(requiredCount) XP"
        case .milestoneBased:
            let current = getCurrentMilestoneCount(stats: stats)
            let unit = getUnitText()
            return "\(current) / \(requiredCount) \(unit)"
        }
    }
    
    private func getCurrentMilestoneCount(stats: JourneyStats) -> Int {
        guard let type = milestoneType else { return 0 }
        switch type {
        case .goalsCompleted: return stats.quests
        case .articlesRead: return stats.articlesRead
        case .modulesCompleted: return stats.modulesCompleted
        case .quizzesPassed: return stats.quizzes
        case .bugsFixed: return stats.bugsFixed
        case .fastAnswers: return stats.fastAnswers
        case .sharedActivities: return stats.sharedActivities
        case .creativeSolutions: return stats.creativeSolutions
        case .codingChallenges: return stats.codingChallenges
        case .bugsSolved: return stats.bugsSolved
        case .systemArchitectures: return stats.systemArchitectures
        }
    }
    
    private func getUnitText() -> String {
        guard let type = milestoneType else { return "" }
        switch type {
        case .goalsCompleted: return "Goals"
        case .articlesRead: return "Articles"
        case .modulesCompleted: return "Modules"
        case .quizzesPassed: return "Quizzes"
        case .bugsFixed: return "Bugs Fixed"
        case .fastAnswers: return "Fast Answers"
        case .sharedActivities: return "Activities"
        case .creativeSolutions: return "Solutions"
        case .codingChallenges: return "Challenges"
        case .bugsSolved: return "Bugs Solved"
        case .systemArchitectures: return "Architectures"
        }
    }
}

struct BadgeSection {
    let title: String
    let badges: [Badge]
}

let customTeal = UIColor(hex: "#f2f2f7")

let allBadgeSections: [BadgeSection] = [
 
    BadgeSection(title: " ", badges: [
        
        Badge(id: 1,
              title: "Path Finder",
              subtitle: "The journey begins!",
              iconName: "map.fill",
              color: UIColor(hex: "#1fa5a1"),
              badgeType: .xpBased,
              milestoneType: nil,
              requiredCount: 0,
              unlockReason: "Awarded for starting your career journey."),

        Badge(id: 2,
              title: "High Achiever",
              subtitle: "Sky-high productivity!",
              iconName: "airplane.up.right",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .goalsCompleted,
              requiredCount: 5,
              unlockReason: "Awarded for completing 5 goals in a single day."),

        Badge(id: 3,
              title: "Eager Learner",
              subtitle: "Thirst for knowledge!",
              iconName: "book.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .articlesRead,
              requiredCount: 10,
              unlockReason: "Awarded for reading 10 career guidance articles."),

        Badge(id: 4,
              title: "Serious Learner",
              subtitle: "Mastering the fundamentals!",
              iconName: "wrench.and.screwdriver.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .modulesCompleted,
              requiredCount: 1,
              unlockReason: "Awarded for finishing your first complete module."),

        Badge(id: 5,
              title: "Confident Reader",
              subtitle: "Knowledge verified!",
              iconName: "flag.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .quizzesPassed,
              requiredCount: 5,
              unlockReason: "Awarded for passing 5 module knowledge checks."),

        Badge(id: 6,
              title: "Error Police",
              subtitle: "No bug left behind!",
              iconName: "shield.lefthalf.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .bugsFixed,
              requiredCount: 3,
              unlockReason: "Awarded for finding and fixing 3 system bugs."),
        
        Badge(id: 7,
              title: "Fast Thinker",
              subtitle: "Lightning-fast responses!",
              iconName: "bolt.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .fastAnswers,
              requiredCount: 10,
              unlockReason: "Awarded for answering 10 questions within time limits."),

        Badge(id: 8,
              title: "Team Player",
              subtitle: "Stronger together!",
              iconName: "person.3.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .sharedActivities,
              requiredCount: 3,
              unlockReason: "Awarded for participating in 3 collaborative activities."),

        Badge(id: 9,
              title: "Creative Mind",
              subtitle: "Outside the box thinker!",
              iconName: "paintbrush.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .creativeSolutions,
              requiredCount: 1,
              unlockReason: "Awarded for proposing your first creative career solution."),

        Badge(id: 10,
              title: "Code Master",
              subtitle: "Algorithmically gifted!",
              iconName: "chevron.left.slash.chevron.right",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .codingChallenges,
              requiredCount: 1,
              unlockReason: "Awarded for successfully finishing a coding challenge."),

        Badge(id: 11,
              title: "Bug Hunter",
              subtitle: "Tracker of the unseen!",
              iconName: "ladybug.fill",
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .bugsSolved,
              requiredCount: 5,
              unlockReason: "Awarded for solving 5 complex technical bugs."),

        Badge(id: 12,
              title: "System Architect",
              subtitle: "Designing for the future!",
              iconName: "cpu.fill",
              color: .systemGray,
              badgeType: .xpBased,
              milestoneType: .systemArchitectures,
              requiredCount: 1200,
              unlockReason: "Awarded for reaching 1200 XP and designing a system architecture."),
    ])
]


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
    case learningDays
    case quizzesPassed
    case articlesRead
    case roadmapProgress
}

struct Badge {
    let id: Int
    let title: String
    let subtitle: String?
    let iconName: String
    let systemIconName: String
    let isCustomImage: Bool
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
        case .learningDays: return stats.days
        case .quizzesPassed: return stats.quizzes
        case .articlesRead: return stats.articlesRead
        case .roadmapProgress: return stats.quests
        }
    }
    
    private func getUnitText() -> String {
        guard let type = milestoneType else { return "" }
        switch type {
        case .learningDays: return "Days"
        case .quizzesPassed: return "Quizzes"
        case .articlesRead: return "Articles"
        case .roadmapProgress: return "Quests"
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
              iconName: "pathfinder",
              systemIconName: "map.fill",
              isCustomImage: true,
              color: UIColor(hex: "#1fa5a1"),
              badgeType: .xpBased,
              milestoneType: nil,
              requiredCount: 0,
              unlockReason: "Awarded for starting your career journey."),

        Badge(id: 2,
              title: "High Achiever",
              subtitle: "Consistency is key!",
              iconName: "highachiever",
              systemIconName: "airplane.up.right",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .learningDays,
              requiredCount: 5,
              unlockReason: "Awarded for staying active for 5 learning days."),

        Badge(id: 3,
              title: "Eager Learner",
              subtitle: "Thirst for knowledge!",
              iconName: "eagerlearner",
              systemIconName: "book.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .articlesRead,
              requiredCount: 5,
              unlockReason: "Awarded for reading 5 career guidance articles."),

        Badge(id: 4,
              title: "Serious Learner",
              subtitle: "Knowledge verified!",
              iconName: "seriouslearner",
              systemIconName: "wrench.and.screwdriver.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .quizzesPassed,
              requiredCount: 3,
              unlockReason: "Awarded for passing 3 module quizzes."),

        Badge(id: 5,
              title: "Confident Reader",
              subtitle: "Mastering the material!",
              iconName: "confidentreader",
              systemIconName: "flag.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .quizzesPassed,
              requiredCount: 10,
              unlockReason: "Awarded for passing 10 knowledge checks."),

        Badge(id: 6,
              title: "Error Police",
              subtitle: "Milestone reached!",
              iconName: "errorpolice",
              systemIconName: "shield.lefthalf.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .roadmapProgress,
              requiredCount: 5,
              unlockReason: "Awarded for completing 5 roadmap milestones."),
        
        Badge(id: 7,
              title: "Fast Thinker",
              subtitle: "Gaining momentum!",
              iconName: "fastthinker",
              systemIconName: "bolt.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .xpBased,
              milestoneType: nil,
              requiredCount: 200,
              unlockReason: "Awarded for reaching 200 total XP."),

        Badge(id: 8,
              title: "Team Player",
              subtitle: "Rising through the ranks!",
              iconName: "teamplayer",
              systemIconName: "person.3.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .xpBased,
              milestoneType: nil,
              requiredCount: 500,
              unlockReason: "Awarded for reaching 500 total XP."),

        Badge(id: 9,
              title: "Creative Mind",
              subtitle: "The visionary!",
              iconName: "creativemind",
              systemIconName: "paintbrush.fill",
              isCustomImage: true,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .roadmapProgress,
              requiredCount: 15,
              unlockReason: "Awarded for completing 15 roadmap tasks."),

        Badge(id: 10,
              title: "Code Master",
              subtitle: "Elite status!",
              iconName: "chevron.left.slash.chevron.right",
              systemIconName: "chevron.left.slash.chevron.right",
              isCustomImage: false,
              color: .systemGray,
              badgeType: .xpBased,
              milestoneType: nil,
              requiredCount: 1000,
              unlockReason: "Awarded for reaching 1000 total XP."),

        Badge(id: 11,
              title: "Bug Hunter",
              subtitle: "The dedicated student!",
              iconName: "ladybug.fill",
              systemIconName: "ladybug.fill",
              isCustomImage: false,
              color: .systemGray,
              badgeType: .milestoneBased,
              milestoneType: .learningDays,
              requiredCount: 20,
              unlockReason: "Awarded for reaching 20 learning days."),

        Badge(id: 12,
              title: "System Architect",
              subtitle: "Grandmaster of career planning!",
              iconName: "cpu.fill",
              systemIconName: "cpu.fill",
              isCustomImage: false,
              color: .systemGray,
              badgeType: .xpBased,
              milestoneType: nil,
              requiredCount: 2500,
              unlockReason: "Awarded for reaching 2500 XP and mastering your roadmap."),
    ])
]


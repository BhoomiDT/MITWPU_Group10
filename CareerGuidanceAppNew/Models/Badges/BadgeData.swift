//
//  BadgeData.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//
import UIKit

struct Badge {
    let id: Int
    let title: String
    let subtitle: String?
    let iconName: String
    let color: UIColor?
    let requiredXP: Int
    
    func isUnlocked(userXP: Int) -> Bool {
        return userXP >= requiredXP
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
              subtitle: "You conquered your first badge!",
              iconName: "map.fill",
              color: UIColor(hex: "#1fa5a1"),
              requiredXP: 0),

        Badge(id: 2,
              title: "High Achiever",
              subtitle: "Completed 5 goals in one day.",
              iconName: "airplane.up.right",
              color: .systemGray,
              requiredXP: 100),

        Badge(id: 3,
              title: "Eager Learner",
              subtitle: "Read 10 learning articles.",
              iconName: "book.fill",
              color: .systemGray,
              requiredXP: 200),

        Badge(id: 4,
              title: "Serious Learner",
              subtitle: "Completed a full learning module.",
              iconName: "wrench.and.screwdriver.fill",
              color: .systemGray,
              requiredXP: 300),

        Badge(id: 5,
              title: "Confident Reader",
              subtitle: "Passed 5 knowledge checks.",
              iconName: "flag.fill",
              color: .systemGray,
              requiredXP: 400),

        Badge(id: 6,
              title: "Error Police",
              subtitle: "Found and fixed 3 bugs.",
              iconName: "shield.lefthalf.fill",
              color: .systemGray,
              requiredXP: 500),
        
        Badge(id: 7,
              title: "Fast Thinker",
              subtitle: "Answered 10 questions quickly.",
              iconName: "bolt.fill",
              color: .systemGray,
              requiredXP: 600),

        Badge(id: 8,
              title: "Team Player",
              subtitle: "Collaborated on shared activities.",
              iconName: "person.3.fill",
              color: .systemGray,
              requiredXP: 700),

        Badge(id: 9,
              title: "Creative Mind",
              subtitle: "Designed a creative solution.",
              iconName: "paintbrush.fill",
              color: .systemGray,
              requiredXP: 800),

        Badge(id: 10,
              title: "Code Master",
              subtitle: "Completed a coding challenge.",
              iconName: "chevron.left.slash.chevron.right",
              color: .systemGray,
              requiredXP: 900),

        Badge(id: 11,
              title: "Bug Hunter",
              subtitle: "Solved 5 tricky bugs.",
              iconName: "ladybug.fill",
              color: .systemGray,
              requiredXP: 1000),

        Badge(id: 12,
              title: "System Architect",
              subtitle: "Designed your first system architecture.",
              iconName: "cpu.fill",
              color: .systemGray,
              requiredXP: 1200),
    ])
]


//
//  journeyModel.swift
//  CareerGuidanceAppNew
//

import Foundation
import UIKit

struct JourneyItem {
    let iconName: String
    let iconColor: UIColor
    let iconBackgroundColor: UIColor
    let title: String
    let subtitle: String
}

struct JourneySection {
    let title: String
    let items: [JourneyItem]
}

enum JourneyData {

    static let milestones: [JourneySection] = [

        JourneySection(
            title: "December",
            items: [
                JourneyItem(
                    iconName: "paperplane.fill",
                    iconColor: UIColor(hex: "#1950A2"),
                    iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                    title: "HTML & CSS Basics",
                    subtitle: "Structure and style the web"
                ),

                JourneyItem(
                    iconName: "target",
                    iconColor: UIColor(hex: "#D4A056"),
                    iconBackgroundColor: UIColor(hex: "#FAF3E7"),
                    title: "3 Goals Achieved!",
                    subtitle: "Consistency in goal completion"
                ),

                JourneyItem(
                    iconName: "flag.2.crossed",
                    iconColor: UIColor(hex: "#D53A6A"),
                    iconBackgroundColor: UIColor(hex: "#FFD4DF"),
                    title: "2 Quests Completed",
                    subtitle: "Consistency in goal completion"
                )
            ]
        ),

        JourneySection(
            title: "November",
            items: [
                JourneyItem(
                    iconName: "chevron.left.slash.chevron.right",
                    iconColor: UIColor(hex: "#A856F7"),
                    iconBackgroundColor: UIColor(hex: "#F6EFFE"),
                    title: "HTML & CSS Basics",
                    subtitle: "Structure and style the web"
                ),

                JourneyItem(
                    iconName: "flame.fill",
                    iconColor: UIColor(hex: "#E8771A"),
                    iconBackgroundColor: UIColor(hex: "#FFE7D4"),
                    title: "First 30-Day Streak Achieved",
                    subtitle: "Uninterrupted learning for a month"
                ),

                JourneyItem(
                    iconName: "checkmark.seal.fill",
                    iconColor: UIColor(hex: "#3E9862"),
                    iconBackgroundColor: UIColor(hex: "#D8FDEB"),
                    title: "Completed Core JavaScript",
                    subtitle: "Part of Web Dev Roadmap"
                )
            ]
        ),
        JourneySection(
            title: "October",
            items: [
                JourneyItem(
                    iconName: "laptopcomputer",
                    iconColor: UIColor(hex: "#0A84FF"),
                    iconBackgroundColor: UIColor(hex: "#E5F1FF"),
                    title: "Started Frontend Journey",
                    subtitle: "First step into development world"
                ),

                JourneyItem(
                    iconName: "book.fill",
                    iconColor: UIColor(hex: "#C46A12"),
                    iconBackgroundColor: UIColor(hex: "#FFEBD8"),
                    title: "Completed Basics of Programming",
                    subtitle: "Understanding logic & syntax"
                ),

                JourneyItem(
                    iconName: "brain.head.profile",
                    iconColor: UIColor(hex: "#B83F77"),
                    iconBackgroundColor: UIColor(hex: "#FFE3F0"),
                    title: "Built Strong Learning Habit",
                    subtitle: "Daily learning without distractions"
                )
            ]
        ),
        JourneySection(
            title: "September",
            items: [
                JourneyItem(
                    iconName: "sparkles",
                    iconColor: UIColor(hex: "#9C47D4"),
                    iconBackgroundColor: UIColor(hex: "#F3E6FF"),
                    title: "Kickstarted Self-Improvement",
                    subtitle: "Mindset shift toward growth"
                ),

                JourneyItem(
                    iconName: "calendar",
                    iconColor: UIColor(hex: "#D49B33"),
                    iconBackgroundColor: UIColor(hex: "#FFF1D9"),
                    title: "Routine & Discipline",
                    subtitle: "Building daily study schedule"
                ),

                JourneyItem(
                    iconName: "person.3.fill",
                    iconColor: UIColor(hex: "#207355"),
                    iconBackgroundColor: UIColor(hex: "#CDF7E6"),
                    title: "Joined Developer Community",
                    subtitle: "First exposure to tech ecosystem"
                )
            ]
        )
    ]

    static let skills: [JourneySection] = [

        JourneySection(
            title: "Web Development",
            items: [

                JourneyItem(
                    iconName: "globe",
                    iconColor: UIColor(hex: "#2563EB"),
                    iconBackgroundColor: UIColor(hex: "#DBEAFE"),
                    title: "React.js",
                    subtitle: "Component-based frontend development"
                ),

                JourneyItem(
                    iconName: "curlybraces",
                    iconColor: UIColor(hex: "#0F766E"),
                    iconBackgroundColor: UIColor(hex: "#CCFBF1"),
                    title: "Tailwind CSS",
                    subtitle: "Utility-first responsive styling"
                ),

                JourneyItem(
                    iconName: "server.rack",
                    iconColor: UIColor(hex: "#7C3AED"),
                    iconBackgroundColor: UIColor(hex: "#EDE9FE"),
                    title: "MongoDB",
                    subtitle: "NoSQL database & CRUD operations"
                )
            ]
        ),

        JourneySection(
            title: "iOS Development",
            items: [

                JourneyItem(
                    iconName: "swift",
                    iconColor: UIColor(hex: "#F97316"),
                    iconBackgroundColor: UIColor(hex: "#FFEDD5"),
                    title: "Swift",
                    subtitle: "Core language & fundamentals"
                ),

                JourneyItem(
                    iconName: "square.stack.3d.up",
                    iconColor: UIColor(hex: "#16A34A"),
                    iconBackgroundColor: UIColor(hex: "#DCFCE7"),
                    title: "SwiftData",
                    subtitle: "Local data persistence"
                ),

                JourneyItem(
                    iconName: "iphone",
                    iconColor: UIColor(hex: "#1D4ED8"),
                    iconBackgroundColor: UIColor(hex: "#DBEAFE"),
                    title: "UIKit",
                    subtitle: "Table views, layouts & navigation"
                )
            ]
        ),

        JourneySection(
            title: "Data & Analytics",
            items: [

                JourneyItem(
                    iconName: "chart.bar.fill",
                    iconColor: UIColor(hex: "#F59E0B"),
                    iconBackgroundColor: UIColor(hex: "#FEF3C7"),
                    title: "Data Visualization",
                    subtitle: "Charts, trends & insights"
                ),

                JourneyItem(
                    iconName: "tablecells",
                    iconColor: UIColor(hex: "#9333EA"),
                    iconBackgroundColor: UIColor(hex: "#F3E8FF"),
                    title: "SQL",
                    subtitle: "Queries, joins & filtering"
                ),

                JourneyItem(
                    iconName: "chart.line.uptrend.xyaxis",
                    iconColor: UIColor(hex: "#DC2626"),
                    iconBackgroundColor: UIColor(hex: "#FEE2E2"),
                    title: "Basic Analytics",
                    subtitle: "Understanding patterns in data"
                )
            ]
        )
    ]
}

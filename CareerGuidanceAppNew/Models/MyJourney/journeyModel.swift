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
                    iconColor: UIColor(hex: "#2563EB"),
                    iconBackgroundColor: UIColor(hex: "#DBEAFE"),
                    title: "Web Foundations",
                    subtitle: "Strengthened HTML & CSS basics"
                ),

                JourneyItem(
                    iconName: "target",
                    iconColor: UIColor(hex: "#F59E0B"),
                    iconBackgroundColor: UIColor(hex: "#FEF3C7"),
                    title: "Goals Unlocked",
                    subtitle: "Completed 3 planned milestones"
                ),

                JourneyItem(
                    iconName: "flag.2.crossed",
                    iconColor: UIColor(hex: "#EC4899"),
                    iconBackgroundColor: UIColor(hex: "#FCE7F3"),
                    title: "Quest Progress",
                    subtitle: "Finished 2 learning quests"
                )
            ]
        ),

        JourneySection(
            title: "November",
            items: [
                JourneyItem(
                    iconName: "chevron.left.slash.chevron.right",
                    iconColor: UIColor(hex: "#7C3AED"),
                    iconBackgroundColor: UIColor(hex: "#EDE9FE"),
                    title: "Code Beginnings",
                    subtitle: "Started hands-on web coding"
                ),

                JourneyItem(
                    iconName: "flame.fill",
                    iconColor: UIColor(hex: "#F97316"),
                    iconBackgroundColor: UIColor(hex: "#FFEDD5"),
                    title: "30-Day Streak",
                    subtitle: "One full month of consistency"
                ),

                JourneyItem(
                    iconName: "checkmark.seal.fill",
                    iconColor: UIColor(hex: "#16A34A"),
                    iconBackgroundColor: UIColor(hex: "#DCFCE7"),
                    title: "JavaScript Core",
                    subtitle: "Completed core JS concepts"
                )
            ]
        ),

        JourneySection(
            title: "October",
            items: [
                JourneyItem(
                    iconName: "laptopcomputer",
                    iconColor: UIColor(hex: "#1D4ED8"),
                    iconBackgroundColor: UIColor(hex: "#DBEAFE"),
                    title: "Frontend Journey",
                    subtitle: "First steps into development"
                ),

                JourneyItem(
                    iconName: "book.fill",
                    iconColor: UIColor(hex: "#0F766E"),
                    iconBackgroundColor: UIColor(hex: "#CCFBF1"),
                    title: "Programming Basics",
                    subtitle: "Built logic and fundamentals"
                ),

                JourneyItem(
                    iconName: "brain.head.profile",
                    iconColor: UIColor(hex: "#9333EA"),
                    iconBackgroundColor: UIColor(hex: "#F3E8FF"),
                    title: "Learning Discipline",
                    subtitle: "Formed a daily learning habit"
                )
            ]
        ),

        JourneySection(
            title: "September",
            items: [
                JourneyItem(
                    iconName: "sparkles",
                    iconColor: UIColor(hex: "#6366F1"),
                    iconBackgroundColor: UIColor(hex: "#E0E7FF"),
                    title: "New Beginning",
                    subtitle: "Mindset shift toward growth"
                ),

                JourneyItem(
                    iconName: "calendar",
                    iconColor: UIColor(hex: "#F59E0B"),
                    iconBackgroundColor: UIColor(hex: "#FEF3C7"),
                    title: "Routine Building",
                    subtitle: "Created a steady study rhythm"
                ),

                JourneyItem(
                    iconName: "person.3.fill",
                    iconColor: UIColor(hex: "#059669"),
                    iconBackgroundColor: UIColor(hex: "#D1FAE5"), 
                    title: "Community Entry",
                    subtitle: "Joined the dev ecosystem"
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

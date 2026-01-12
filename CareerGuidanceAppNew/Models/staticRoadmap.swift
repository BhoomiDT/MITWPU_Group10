//
//  staticRoadmap.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/12/25.
//
import UIKit   // Needed for UIColor

// MARK: - Milestone Model
struct Milestone {
    let title: String
    let subtitle: String
    let iconName: String          // SF Symbol name
    let iconColor: UIColor?       // Icon tint color
    let iconBackgroundColor: UIColor?
}

// MARK: - Static Roadmap Model
struct StaticRoadmap {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String?
    let percentage: Int
    let modules: [Module]?        // Kept optional so nothing breaks
    let milestones: [Milestone]
}

// MARK: - Static Roadmap Data
let staticRoadmaps: [StaticRoadmap] = [

    StaticRoadmap(
        title: "Web Development",
        subtitle: "Personalised Roadmap",
        description: "Master core web languages, specialize in front- or back-end, then learn architecture and deployment.",
        imageName: nil,
        percentage: 90,
        modules: nil,
        milestones: [

            Milestone(
                title: "HTML & CSS Basics",
                subtitle: "Structure and style the web",
                iconName: "building.columns",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC")
            ),

            Milestone(
                title: "JavaScript Essentials",
                subtitle: "Add logic and interactivity",
                iconName: "shippingbox.fill",
                iconColor: UIColor(hex: "#D4A056"),
                iconBackgroundColor: UIColor(hex: "#FAF3E7")
            ),

            Milestone(
                title: "Frontend Frameworks",
                subtitle: "Build dynamic user interfaces",
                iconName: "star",
                iconColor: UIColor(hex: "#D53A6A"),
                iconBackgroundColor: UIColor(hex: "#FFD4DF")
            ),

            Milestone(
                title: "Backend Development",
                subtitle: "Power your apps with servers",
                iconName: "xserve.raid",
                iconColor: UIColor(hex: "#A856F7"),
                iconBackgroundColor: UIColor(hex: "#F6EFFE")
            ),

            Milestone(
                title: "APIs & Databases",
                subtitle: "Connect data and services",
                iconName: "cloud",
                iconColor: UIColor(hex: "#E8771A"),
                iconBackgroundColor: UIColor(hex: "#FFE7D4")
            )
        ]
    ),
    StaticRoadmap(
        title: "iOS Development",
        subtitle: "Career Path",
        description: "Build native iOS apps using Swift, UIKit/SwiftUI, and Apple frameworks.",
        imageName: nil,
        percentage: 45,
        modules: nil,
        milestones: [

            Milestone(
                title: "Swift Fundamentals",
                subtitle: "Learn syntax, types, and control flow",
                iconName: "swift",
                iconColor: UIColor(hex: "#F05138"),
                iconBackgroundColor: UIColor(hex: "#FFE5DF")
            ),

            Milestone(
                title: "UIKit Basics",
                subtitle: "Understand views, view controllers, and Auto Layout",
                iconName: "iphone",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E6F0FF")
            ),

            Milestone(
                title: "Navigation & Data Flow",
                subtitle: "Work with navigation controllers and tab bars",
                iconName: "arrow.triangle.branch",
                iconColor: UIColor(hex: "#30B0C7"),
                iconBackgroundColor: UIColor(hex: "#E4F7FA")
            ),

            Milestone(
                title: "Networking & APIs",
                subtitle: "Fetch and display remote data",
                iconName: "network",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#E7F8EC")
            ),

            Milestone(
                title: "Persistence & Deployment",
                subtitle: "Store data and publish apps",
                iconName: "externaldrive.fill",
                iconColor: UIColor(hex: "#AF52DE"),
                iconBackgroundColor: UIColor(hex: "#F3E8FA")
            )
        ]
    ),
    StaticRoadmap(
        title: "UI / UX Design",
        subtitle: "Skill Builder",
        description: "Design intuitive, accessible, and visually appealing digital experiences.",
        imageName: nil,
        percentage: 10,
        modules: nil,
        milestones: [

            Milestone(
                title: "Design Principles",
                subtitle: "Learn layout, color, typography, and hierarchy",
                iconName: "paintbrush.fill",
                iconColor: UIColor(hex: "#FF9F0A"),
                iconBackgroundColor: UIColor(hex: "#FFF2DD")
            ),

            Milestone(
                title: "User Research",
                subtitle: "Understand user needs and pain points",
                iconName: "person.text.rectangle",
                iconColor: UIColor(hex: "#5E5CE6"),
                iconBackgroundColor: UIColor(hex: "#EAEAFF")
            ),

            Milestone(
                title: "Wireframing",
                subtitle: "Create low-fidelity screen layouts",
                iconName: "rectangle.split.3x1",
                iconColor: UIColor(hex: "#64D2FF"),
                iconBackgroundColor: UIColor(hex: "#E6F7FF")
            ),

            Milestone(
                title: "Prototyping",
                subtitle: "Build interactive design flows",
                iconName: "cursorarrow.click",
                iconColor: UIColor(hex: "#FF375F"),
                iconBackgroundColor: UIColor(hex: "#FFE3EA")
            ),

            Milestone(
                title: "Usability & Accessibility",
                subtitle: "Test and improve user experience",
                iconName: "checkmark.seal.fill",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#E7F8EC")
            )
        ]
    ),

    StaticRoadmap(
        title: "Backend Engineering",
        subtitle: "Advanced Track",
        description: "Build scalable server-side systems, APIs, and databases.",
        imageName: nil,
        percentage: 0,
        modules: nil,
        milestones: [

            Milestone(
                title: "Programming Basics",
                subtitle: "Master one backend language",
                iconName: "terminal.fill",
                iconColor: UIColor(hex: "#8E8E93"),
                iconBackgroundColor: UIColor(hex: "#F2F2F7")
            ),

            Milestone(
                title: "Server Frameworks",
                subtitle: "Develop RESTful applications",
                iconName: "server.rack",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E6F0FF")
            ),

            Milestone(
                title: "Databases",
                subtitle: "Design and manage data storage",
                iconName: "cylinder.fill",
                iconColor: UIColor(hex: "#FF9F0A"),
                iconBackgroundColor: UIColor(hex: "#FFF2DD")
            ),

            Milestone(
                title: "Authentication & Security",
                subtitle: "Protect data and users",
                iconName: "lock.shield.fill",
                iconColor: UIColor(hex: "#FF453A"),
                iconBackgroundColor: UIColor(hex: "#FFE5E3")
            ),

            Milestone(
                title: "Deployment & Scaling",
                subtitle: "Deploy and monitor applications",
                iconName: "cloud.fill",
                iconColor: UIColor(hex: "#30B0C7"),
                iconBackgroundColor: UIColor(hex: "#E4F7FA")
            )
        ]
    )
]

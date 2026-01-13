//
//  Quiz.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import Foundation
import UIKit

enum LessonStatus: String {
    case startTest = "Start Test"
    case seeResults = "See Results"
}

struct Lesson {
    let id: String
    let name: String
    let dueDate: String
    let status: LessonStatus
}

struct Module {
    let title: String
    let lessons: [Lesson]
}

struct Roadmap {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let percentage: Int
    let modules: [Module]
    let milestones: [Milestone]
    var isStarted: Bool
}

struct Milestone {
    let title: String
    let subtitle: String
    let iconName: String          // SF Symbol name
    let iconColor: UIColor?       // Icon tint color
    let iconBackgroundColor: UIColor?
}

// Describes a quiz for a lesson (NO user state here)
struct Quiz: Codable {
    let lessonId: String          // Links quiz to Lesson.id
    let lessonName: String
    let durationMinutes: Int
    let passingPercent: Int
    let questions: [QuizQuestion]
}

// Describes a single question (immutable)
struct QuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctIndex: Int
}

// MARK: - Quiz Session (USER STATE)

// Tracks a user's attempt for a specific lesson quiz
struct QuizSession {
    let domainTitle: String       // Roadmap.title
    let moduleTitle: String       // Module.title
    let lessonId: String          // Lesson.id
    let quiz: Quiz

    // Index = question index, Value = selected option index
    var selectedOptionIndices: [Int?]
}

// MARK: - Quiz Factory (STATIC DATA SOURCE)

struct TestFactory {

    static func makeQuiz(
        lessonId: String,
        lessonName: String
    ) -> Quiz {

        switch lessonName {

        case "Data Cleaning Basics":
            return Quiz(
                lessonId: lessonId,
                lessonName: lessonName,
                durationMinutes: 30,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which of the following is NOT a visual design principle?",
                        options: [
                            "Contrast",
                            "Repetition",
                            "Alignment",
                            "Compilation"
                        ],
                        correctIndex: 3
                    ),
                    QuizQuestion(
                        question: "Which principle creates hierarchy?",
                        options: [
                            "Balance",
                            "Contrast",
                            "Unity",
                            "Flow"
                        ],
                        correctIndex: 1
                    )
                ]
            )

        case "Color Theory & Typography":
            return Quiz(
                lessonId: lessonId,
                lessonName: lessonName,
                durationMinutes: 25,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which color mode is used for print?",
                        options: [
                            "RGB",
                            "CMYK",
                            "HSB",
                            "Pantone"
                        ],
                        correctIndex: 1
                    )
                ]
            )

        default:
            // Fallback quiz
            return Quiz(
                lessonId: lessonId,
                lessonName: lessonName,
                durationMinutes: 20,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Placeholder question?",
                        options: ["A", "B", "C", "D"],
                        correctIndex: 0
                    )
                ]
            )
        }
    }
}


var allRoadmapsData: [Roadmap] = [

    // MARK: - Data Analytics
    Roadmap(
        title: "Data Analytics",
        subtitle: "Personalised Roadmap",
        description: "Learn to collect, clean, analyze, and visualize data to drive informed business decisions.",
        imageName: "data-analytics-role",
        percentage: 90,
        modules: [

            // MARK: - Module 1
            Module(
                title: "Module 1: Data Foundations",
                lessons: [
                    Lesson(
                        id: "data_types",
                        name: "Understanding Data Types",
                        dueDate: "Dec 18",
                        status: .seeResults
                    ),
                    Lesson(
                        id: "data_collection",
                        name: "Data Collection Methods",
                        dueDate: "Dec 18",
                        status: .startTest
                    ),
                    Lesson(
                        id: "data_cleaning",
                        name: "Data Cleaning & Preprocessing",
                        dueDate: "Dec 19",
                        status: .startTest
                    )
                ]
            ),

            // MARK: - Module 2
            Module(
                title: "Module 2: Analytics Tools & Techniques",
                lessons: [
                    Lesson(
                        id: "excel_analytics",
                        name: "Excel for Data Analysis",
                        dueDate: "Dec 22",
                        status: .startTest
                    ),
                    Lesson(
                        id: "sql_analytics",
                        name: "SQL Queries & Joins",
                        dueDate: "Dec 22",
                        status: .startTest
                    ),
                    Lesson(
                        id: "python_analytics",
                        name: "Python for Data Analytics",
                        dueDate: "Dec 23",
                        status: .startTest
                    )
                ],
            ),

            // MARK: - Module 3
            Module(
                title: "Module 3: Exploratory Analysis",
                lessons: [
                    Lesson(
                        id: "eda_basics",
                        name: "Exploratory Data Analysis (EDA)",
                        dueDate: "Dec 26",
                        status: .startTest
                    ),
                    Lesson(
                        id: "statistics_analytics",
                        name: "Statistics for Analytics",
                        dueDate: "Dec 27",
                        status: .startTest
                    ),
                    Lesson(
                        id: "hypothesis_testing",
                        name: "Hypothesis Testing",
                        dueDate: "Dec 28",
                        status: .startTest
                    )
                ]
            ),

            // MARK: - Module 4
            Module(
                title: "Module 4: Visualization & Reporting",
                lessons: [
                    Lesson(
                        id: "data_visualization",
                        name: "Data Visualization Principles",
                        dueDate: "Dec 30",
                        status: .startTest
                    ),
                    Lesson(
                        id: "tableau_powerbi",
                        name: "Dashboards with Tableau & Power BI",
                        dueDate: "Dec 30",
                        status: .startTest
                    ),
                    Lesson(
                        id: "storytelling_data",
                        name: "Data Storytelling & Insights",
                        dueDate: "Dec 31",
                        status: .startTest
                    )
                ]
            )
        ],

        milestones: [
            Milestone(
                title: "Data Fundamentals",
                subtitle: "Understand and prepare data",
                iconName: "tray.full.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC")
            ),

            Milestone(
                title: "Analytics Tools",
                subtitle: "Excel, SQL, Python",
                iconName: "hammer.fill",
                iconColor: UIColor(hex: "#D4A056"),
                iconBackgroundColor: UIColor(hex: "#FAF3E7")
            ),

            Milestone(
                title: "Exploratory Analysis",
                subtitle: "Discover patterns & trends",
                iconName: "chart.bar.xaxis",
                iconColor: UIColor(hex: "#D53A6A"),
                iconBackgroundColor: UIColor(hex: "#FFD4DF")
            ),

            Milestone(
                title: "Visualization & Reporting",
                subtitle: "Communicate insights clearly",
                iconName: "chart.pie.fill",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#E7F8EC")
            ),

            Milestone(
                title: "Business Insights",
                subtitle: "Support decision-making",
                iconName: "briefcase.fill",
                iconColor: UIColor(hex: "#A856F7"),
                iconBackgroundColor: UIColor(hex: "#F6EFFE")
            )
        ],
        isStarted: false,
    ),


    // MARK: - AI & Machine Learning
    Roadmap(
        title: "AI & Machine Learning",
        subtitle: "Advanced Career Track",
        description: "Learn machine learning, deep learning, and AI systems to build intelligent applications.",
        imageName: "aiml-role",
        percentage: 40,
        modules: [

            Module(
                title: "Module 1: ML Foundations",
                lessons: [
                    Lesson(id: "ml_intro", name: "Introduction to Machine Learning", dueDate: "Jan 5", status: .startTest),
                    Lesson(id: "ml_math", name: "Math for ML (Linear Algebra)", dueDate: "Jan 6", status: .startTest),
                    Lesson(id: "ml_probability", name: "Probability & Statistics", dueDate: "Jan 7", status: .startTest)
                ]
            ),

            Module(
                title: "Module 2: Supervised & Unsupervised Learning",
                lessons: [
                    Lesson(id: "regression_models", name: "Regression Models", dueDate: "Jan 10", status: .startTest),
                    Lesson(id: "classification_models", name: "Classification Models", dueDate: "Jan 10", status: .startTest),
                    Lesson(id: "clustering", name: "Clustering Algorithms", dueDate: "Jan 11", status: .startTest)
                ]
            ),

            Module(
                title: "Module 3: Deep Learning & AI",
                lessons: [
                    Lesson(id: "neural_networks", name: "Neural Networks Basics", dueDate: "Jan 15", status: .startTest),
                    Lesson(id: "cnn_rnn", name: "CNNs & RNNs", dueDate: "Jan 16", status: .startTest),
                    Lesson(id: "model_deployment", name: "Model Deployment", dueDate: "Jan 18", status: .startTest)
                ]
            )
        ],
        milestones: [
            Milestone(
                title: "Python for ML",
                subtitle: "Core programming skills",
                iconName: "terminal.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC")
            ),
            Milestone(
                title: "ML Algorithms",
                subtitle: "Train predictive models",
                iconName: "brain.head.profile",
                iconColor: UIColor(hex: "#8E44AD"),
                iconBackgroundColor: UIColor(hex: "#F1E6F8")
            ),
            Milestone(
                title: "Deep Learning",
                subtitle: "Neural networks mastery",
                iconName: "cpu",
                iconColor: UIColor(hex: "#D53A6A"),
                iconBackgroundColor: UIColor(hex: "#FFD4DF")
            ),
            Milestone(
                title: "AI Deployment",
                subtitle: "Real-world AI systems",
                iconName: "cloud.fill",
                iconColor: UIColor(hex: "#2AA6A1"),
                iconBackgroundColor: UIColor(hex: "#E3F6F5")
            )
        ],

        isStarted: false,
    ),


    // MARK: - App Development
    Roadmap(
        title: "App Development",
        subtitle: "Full Stack Builder",
        description: "Build modern mobile and web applications from frontend to backend.",
        imageName: "appdev-role 1",
        percentage: 65,
        modules: [

            Module(
                title: "Module 1: Programming Basics",
                lessons: [
                    Lesson(id: "programming_basics", name: "Programming Fundamentals", dueDate: "Jan 3", status: .seeResults),
                    Lesson(id: "oop_concepts", name: "Object-Oriented Programming", dueDate: "Jan 4", status: .startTest),
                    Lesson(id: "version_control", name: "Git & GitHub", dueDate: "Jan 5", status: .startTest)
                ]
            ),

            Module(
                title: "Module 2: Frontend Development",
                lessons: [
                    Lesson(id: "ui_design", name: "UI Design Principles", dueDate: "Jan 8", status: .startTest),
                    Lesson(id: "frontend_frameworks", name: "Frontend Frameworks", dueDate: "Jan 9", status: .startTest),
                    Lesson(id: "state_management", name: "State Management", dueDate: "Jan 10", status: .startTest)
                ]
            ),

            Module(
                title: "Module 3: Backend & Deployment",
                lessons: [
                    Lesson(id: "api_development", name: "API Development", dueDate: "Jan 14", status: .startTest),
                    Lesson(id: "database_design", name: "Database Design", dueDate: "Jan 15", status: .startTest),
                    Lesson(id: "app_deployment", name: "App Deployment", dueDate: "Jan 16", status: .startTest)
                ]
            )
        ],
        milestones: [
            Milestone(
                title: "UI Development",
                subtitle: "Build app interfaces",
                iconName: "iphone",
                iconColor: UIColor(hex: "#007AFF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF")
            ),
            Milestone(
                title: "Backend Logic",
                subtitle: "Server-side code",
                iconName: "server.rack",
                iconColor: UIColor(hex: "#7B61FF"),
                iconBackgroundColor: UIColor(hex: "#EFEAFF")
            ),
            Milestone(
                title: "Databases",
                subtitle: "Persistent data",
                iconName: "cylinder.fill",
                iconColor: UIColor(hex: "#FF9F0A"),
                iconBackgroundColor: UIColor(hex: "#FFF2DD")
            ),
            Milestone(
                title: "Deployment",
                subtitle: "Publish applications",
                iconName: "cloud.upload.fill",
                iconColor: UIColor(hex: "#34C759"),
                iconBackgroundColor: UIColor(hex: "#E7F8EC")
            )
        ],

        isStarted: false,
    ),


    // MARK: - Cyber Security
    Roadmap(
        title: "Cyber Security",
        subtitle: "Security Specialist Track",
        description: "Protect systems, networks, and applications from cyber threats.",
        imageName: "cyber-security-role",
        percentage: 20,
        modules: [

            Module(
                title: "Module 1: Security Fundamentals",
                lessons: [
                    Lesson(id: "security_basics", name: "Cyber Security Basics", dueDate: "Jan 6", status: .startTest),
                    Lesson(id: "networking_basics", name: "Networking Fundamentals", dueDate: "Jan 7", status: .startTest),
                    Lesson(id: "threat_models", name: "Threat Modeling", dueDate: "Jan 8", status: .startTest)
                ]
            ),

            Module(
                title: "Module 2: Ethical Hacking",
                lessons: [
                    Lesson(id: "linux_security", name: "Linux Security", dueDate: "Jan 12", status: .startTest),
                    Lesson(id: "web_vulnerabilities", name: "Web Vulnerabilities (OWASP)", dueDate: "Jan 13", status: .startTest),
                    Lesson(id: "penetration_testing", name: "Penetration Testing", dueDate: "Jan 14", status: .startTest)
                ]
            ),

            Module(
                title: "Module 3: Security Operations",
                lessons: [
                    Lesson(id: "incident_response", name: "Incident Response", dueDate: "Jan 18", status: .startTest),
                    Lesson(id: "security_tools", name: "Security Tools & SIEM", dueDate: "Jan 19", status: .startTest),
                    Lesson(id: "cloud_security", name: "Cloud Security", dueDate: "Jan 20", status: .startTest)
                ]
            )
        ],
        milestones: [
            Milestone(
                title: "Network Security",
                subtitle: "Protect infrastructure",
                iconName: "network",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF")
            ),
            Milestone(
                title: "Ethical Hacking",
                subtitle: "Offensive security skills",
                iconName: "lock.open.fill",
                iconColor: UIColor(hex: "#FF453A"),
                iconBackgroundColor: UIColor(hex: "#FFE5E3")
            ),
            Milestone(
                title: "Incident Response",
                subtitle: "Handle attacks",
                iconName: "exclamationmark.shield.fill",
                iconColor: UIColor(hex: "#FF9F0A"),
                iconBackgroundColor: UIColor(hex: "#FFF2DD")
            ),
            Milestone(
                title: "Cloud Security",
                subtitle: "Secure cloud systems",
                iconName: "cloud.fill",
                iconColor: UIColor(hex: "#2AA6A1"),
                iconBackgroundColor: UIColor(hex: "#E3F6F5")
            )
        ],
        isStarted: false,
    )

]

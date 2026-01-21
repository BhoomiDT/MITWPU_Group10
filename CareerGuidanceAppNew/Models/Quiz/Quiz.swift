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
    let subtitle: String
    let dueDate: String
    let status: LessonStatus
    var videos: [VideoResource]?
    var documents: [DocResource]?
}

struct VideoResource {
    let lessonId: String?
    let title: String
    let duration: String
    let thumbnailName: String
    let videoURL: String
}

struct DocResource {
    let lessonId: String?
    let title: String
    let readTime: String
    let docURL: String
}


struct ModuleNew {
    let title: String
    let lessons: [Lesson]
}

struct Roadmap {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let percentage: Int
    let milestones: [Milestone]
    var isStarted: Bool
}

struct Milestone {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: UIColor?
    let iconBackgroundColor: UIColor?
    let lessons: [Lesson]
}

struct Quiz: Codable {
    let lessonId: String
    let lessonName: String
    let durationMinutes: Int
    let passingPercent: Int
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct QuizSession {
    let domainTitle: String
    let moduleTitle: String
    let lessonId: String
    let quiz: Quiz

    var selectedOptionIndices: [Int?]
}

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
            //Fallback quiz
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

    //Data Analytics
    Roadmap(
        title: "Data Analytics",
        subtitle: "Personalised Roadmap",
        description: "Learn to collect, clean, and visualize data.",
        imageName: "data-analytics-role",
        percentage: 90,
        milestones: [
            Milestone(
                title: "Data Fundamentals",
                subtitle: "Understand and prepare data",
                iconName: "tray.full.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                lessons: [
                    Lesson(
                        id: "data_types",
                        name: "Data Cleaning Basics",
                        subtitle: "Categorize quantitative and qualitative data.",
                        dueDate: "Dec 18",
                        status: .seeResults,
                        videos: [
                            VideoResource(lessonId: "data_types", title: "Quantitative vs Qualitative", duration: "10:20", thumbnailName: "vid_thumb_1", videoURL: "https://www.youtube.com/watch?v=7bsNWqBAyk8")
                        ],
                        documents: [
                            DocResource(lessonId: "data_types", title: "Data Classification Guide", readTime: "5 min read", docURL: "https://en.wikipedia.org/wiki/Statistical_data_type")
                        ]
                    ),
                    Lesson(
                        id: "data_collection",
                        name: "Data Collection Methods",
                        subtitle: "Surveys, APIs, and web scraping basics.",
                        dueDate: "Dec 18",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "data_collection", title: "Introduction to APIs", duration: "15:45", thumbnailName: "vid_thumb_2", videoURL: "https://www.youtube.com/watch?v=ov7vS0X2_50")
                        ],
                        documents: [
                            DocResource(lessonId: "data_collection", title: "Web Scraping 101", readTime: "10 min read", docURL: "https://www.scrapingbee.com/blog/web-scraping-101/")
                        ]
                    )
                ]
            ),
            Milestone(
                title: "Analytics Tools",
                subtitle: "Excel, SQL, Python",
                iconName: "hammer.fill",
                iconColor: UIColor(hex: "#D4A056"),
                iconBackgroundColor: UIColor(hex: "#FAF3E7"),
                lessons: [
                    Lesson(
                        id: "excel_basics",
                        name: "Excel Mastery",
                        subtitle: "Pivot tables and advanced lookups.",
                        dueDate: "Dec 22",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "excel_basics", title: "Advanced Excel for Data", duration: "22:10", thumbnailName: "vid_excel", videoURL: "https://www.youtube.com/watch?v=0nbkaYsR94c")
                        ]
                    ),
                    Lesson(
                        id: "sql_queries",
                        name: "SQL Queries & Joins",
                        subtitle: "Relational database querying essentials.",
                        dueDate: "Dec 22",
                        status: .startTest,
                        documents: [
                            DocResource(lessonId: "sql_queries", title: "The SQL Joins Handbook", readTime: "12 min read", docURL: "https://www.sqlshack.com/sql-join-overview-and-tutorial/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),
    
    //AI & Machine Learning
    Roadmap(
        title: "AI & Machine Learning",
        subtitle: "Advanced Career Track",
        description: "Learn machine learning, deep learning, and AI systems.",
        imageName: "aiml-role",
        percentage: 40,
        milestones: [
            Milestone(
                title: "Python for ML",
                subtitle: "Core programming skills",
                iconName: "terminal.fill",
                iconColor: UIColor(hex: "#1950A2"),
                iconBackgroundColor: UIColor(hex: "#E0ECFC"),
                lessons: [
                    Lesson(
                        id: "ml_intro",
                        name: "Introduction to ML",
                        subtitle: "Understanding supervised vs unsupervised learning.",
                        dueDate: "Jan 5",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ml_intro", title: "The Map of Machine Learning", duration: "12:00", thumbnailName: "vid_ml_map", videoURL: "https://www.youtube.com/watch?v=HcqpanDadyQ")
                        ],
                        documents: [
                            DocResource(lessonId: "ml_intro", title: "Supervised vs Unsupervised Study", readTime: "8 min read", docURL: "https://towardsdatascience.com/supervised-vs-unsupervised-learning-140455914805")
                        ]
                    ),
                    Lesson(
                        id: "ml_math",
                        name: "Math for ML",
                        subtitle: "Linear Algebra and Calculus for optimization.",
                        dueDate: "Jan 6",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ml_math", title: "Linear Algebra Essence", duration: "25:00", thumbnailName: "vid_math", videoURL: "https://www.youtube.com/watch?v=fNk_zzaMoSs")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    //App Development
    Roadmap(
        title: "App Development",
        subtitle: "Full Stack Builder",
        description: "Build modern mobile and web applications.",
        imageName: "appdev-role 1",
        percentage: 65,
        milestones: [
            Milestone(
                title: "UI Development",
                subtitle: "Build app interfaces",
                iconName: "iphone",
                iconColor: UIColor(hex: "#007AFF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "ui_design",
                        name: "UI Design Principles",
                        subtitle: "Typography, spacing, and accessibility.",
                        dueDate: "Jan 8",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "ui_design", title: "Principles of Clean UI", duration: "08:30", thumbnailName: "vid_ui", videoURL: "https://www.youtube.com/watch?v=7ZfKovNAtpw")
                        ],
                        documents: [
                            DocResource(lessonId: "ui_design", title: "Apple Human Interface Guidelines", readTime: "20 min read", docURL: "https://developer.apple.com/design/human-interface-guidelines/")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    ),

    //Cyber Security
    Roadmap(
        title: "Cyber Security",
        subtitle: "Security Specialist Track",
        description: "Protect systems and networks from cyber threats.",
        imageName: "cyber-security-role",
        percentage: 20,
        milestones: [
            Milestone(
                title: "Network Security",
                subtitle: "Protect infrastructure",
                iconName: "network",
                iconColor: UIColor(hex: "#0A84FF"),
                iconBackgroundColor: UIColor(hex: "#E5F0FF"),
                lessons: [
                    Lesson(
                        id: "networking_basics",
                        name: "Networking Fundamentals",
                        subtitle: "TCP/IP models and network protocols.",
                        dueDate: "Jan 7",
                        status: .startTest,
                        videos: [
                            VideoResource(lessonId: "networking_basics", title: "How the Internet Works", duration: "14:20", thumbnailName: "vid_net", videoURL: "https://www.youtube.com/watch?v=Dxcc6ycZ73M")
                        ]
                    )
                ]
            )
        ],
        isStarted: false
    )
]

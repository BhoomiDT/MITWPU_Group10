//
//  onboarding.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 27/11/25.
//

import Foundation

struct Section {
    let symbolName: String
    let title: String
    let subtitle: String
    let questions: [Question]
}

struct Question {
    let qText: String
    let options: [String]
}

let psychometricAnswers: [String] = [
    "Strongly Disagree",
    "Disagree",
    "Neutral",
    "Agree",
    "Strongly Agree"
]

class Questionnaire {
    let sections: [Section]

    init() {
        sections = [

            // MARK: - Section 0: Intro / Roadmap
            Section(
                symbolName: "figure.walk",
                title: "Your Personal Roadmap",
                subtitle: "Let's create a personalized career path tailored just for you.",
                questions: []
            ),

            // MARK: - Section 1: Technical Skills
            Section(
                symbolName: "terminal.fill",
                title: "Technical Skills",
                subtitle: "Add your technical skills to get a personalized roadmap",
                questions: []
            ),

            // MARK: - Section 2: Practical & Analytical
            Section(
                symbolName: "lightbulb.fill",
                title: "Practical & Analytical Thinking",
                subtitle: "Your approach to logic and problem solving",
                questions: [
                    Question(
                        qText: "I enjoy solving complex problems.",
                        options: psychometricAnswers
                    ),
                    Question(
                        qText: "I think logically before acting.",
                        options: psychometricAnswers
                    ),
                    Question(
                        qText: "I like working with data or numbers.",
                        options: psychometricAnswers
                    )
                ]
            ),

            // MARK: - Section 3: Creative
            Section(
                symbolName: "paintpalette.fill",
                title: "Creative & Focused Interests",
                subtitle: "Your creativity and communication style",
                questions: [
                    Question(
                        qText: "I enjoy creative or design work.",
                        options: psychometricAnswers
                    ),
                    Question(
                        qText: "I like expressing ideas visually.",
                        options: psychometricAnswers
                    ),
                    Question(
                        qText: "I communicate my ideas clearly.",
                        options: psychometricAnswers
                    )
                ]
            ),

            // MARK: - Section 4: Business
            Section(
                symbolName: "briefcase.fill",
                title: "Business & Organizational Skills",
                subtitle: "Your leadership and planning comfort",
                questions: [
                    Question(
                        qText: "I enjoy planning tasks or projects.",
                        options: psychometricAnswers
                    ),
                    Question(
                        qText: "I am comfortable leading a team.",
                        options: psychometricAnswers
                    ),
                    Question(
                        qText: "I take responsibility in group work.",
                        options: psychometricAnswers
                    )
                ]
            )
        ]
    }
}


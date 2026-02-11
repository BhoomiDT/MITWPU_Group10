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
            // MARK: - SECTION 1: Mixed RIASEC Set 1 & 2
            Section(
                symbolName: "1.circle.fill",
                title: "Discovery Phase 1",
                subtitle: "Exploring your diverse interests in tech and design",
                questions: [
                    // Set 1
                    Question(qText: "I enjoy assembling hardware components of a computer.", options: psychometricAnswers), // R
                    Question(qText: "I love solving complex algorithmic puzzles.", options: psychometricAnswers), // I
                    Question(qText: "I enjoy creating visually appealing user interfaces.", options: psychometricAnswers), // A
                    Question(qText: "I enjoy teaching others how to use software.", options: psychometricAnswers), // S
                    Question(qText: "I enjoy leading a project team to meet a deadline.", options: psychometricAnswers), // E
                    Question(qText: "I enjoy organizing code into a strict, clean structure.", options: psychometricAnswers), // C
                    
                    // Set 2
                    Question(qText: "I like working with networking cables and physical servers.", options: psychometricAnswers), // R
                    Question(qText: "I enjoy analyzing large datasets to find hidden patterns.", options: psychometricAnswers), // I
                    Question(qText: "I like experimenting with colors, fonts, and layouts.", options: psychometricAnswers), // A
                    Question(qText: "I like collaborating in large teams to reach a goal.", options: psychometricAnswers), // S
                    Question(qText: "I like pitching new product ideas to stakeholders.", options: psychometricAnswers), // E
                    Question(qText: "I like following established industry standards and protocols.", options: psychometricAnswers) // C
                ]
            ),

            // MARK: - SECTION 2: Mixed RIASEC Set 3 & 4
            Section(
                symbolName: "2.circle.fill",
                title: "Discovery Phase 2",
                subtitle: "Diving deeper into your professional preferences",
                questions: [
                    // Set 3
                    Question(qText: "I prefer building tangible prototypes over theoretical designs.", options: psychometricAnswers), // R
                    Question(qText: "I like researching new technologies and how they work.", options: psychometricAnswers), // I
                    Question(qText: "I enjoy brainstorming creative solutions for app interactions.", options: psychometricAnswers), // A
                    Question(qText: "I enjoy conducting user interviews to understand needs.", options: psychometricAnswers), // S
                    Question(qText: "I enjoy the business side of software development.", options: psychometricAnswers), // E
                    Question(qText: "I enjoy writing detailed documentation and logs.", options: psychometricAnswers), // C
                    
                    // Set 4
                    Question(qText: "I enjoy troubleshooting mechanical or hardware failures.", options: psychometricAnswers), // R
                    Question(qText: "I prefer backend logic over user interface design.", options: psychometricAnswers), // I
                    Question(qText: "I like creating digital art or animations for games.", options: psychometricAnswers), // A
                    Question(qText: "I like mentoring junior developers.", options: psychometricAnswers), // S
                    Question(qText: "I like making high-level decisions about project direction.", options: psychometricAnswers), // E
                    Question(qText: "I prefer tasks with clear, step-by-step instructions.", options: psychometricAnswers) // C
                ]
            ),

            // MARK: - SECTION 3: Mixed RIASEC Set 5 & 6
            Section(
                symbolName: "3.circle.fill",
                title: "Final Assessment",
                subtitle: "Finalizing your personalized career roadmap",
                questions: [
                    // Set 5
                    Question(qText: "I like setting up IoT devices and sensors.", options: psychometricAnswers), // R
                    Question(qText: "I enjoy debugging code to find the root cause of a bug.", options: psychometricAnswers), // I
                    Question(qText: "I value 'look and feel' as much as functionality.", options: psychometricAnswers), // A
                    Question(qText: "I prefer pair-programming over working alone.", options: psychometricAnswers), // S
                    Question(qText: "I enjoy negotiating features and project scopes.", options: psychometricAnswers), // E
                    Question(qText: "I like managing database schemas and data integrity.", options: psychometricAnswers), // C
                    
                    // Set 6
                    Question(qText: "I enjoy optimizing the physical performance of a system.", options: psychometricAnswers), // R
                    Question(qText: "I like designing mathematical models for software.", options: psychometricAnswers), // I
                    Question(qText: "I enjoy writing creative content or documentation.", options: psychometricAnswers), // A
                    Question(qText: "I enjoy organizing community tech events or meetups.", options: psychometricAnswers), // S
                    Question(qText: "I am interested in starting my own tech startup.", options: psychometricAnswers), // E
                    Question(qText: "I enjoy performing repetitive tests to ensure quality.", options: psychometricAnswers) // C
                ]
            )
        ]
    }
}

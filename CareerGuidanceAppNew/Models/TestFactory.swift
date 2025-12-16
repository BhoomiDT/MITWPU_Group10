//
//  TestFactory.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import Foundation

struct TestFactory {

    static func makeQuiz(for lessonName: String) -> Quiz {

        switch lessonName {

        case "Visual Design Principles":
            return Quiz(
                lessonName: lessonName,
                durationMinutes: 30,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which of the following is NOT a visual design principle?",
                        options: ["Contrast", "Repetition", "Alignment", "Compilation"],
                        correctIndex: 3
                    ),
                    QuizQuestion(
                        question: "Which principle creates hierarchy?",
                        options: ["Balance", "Contrast", "Unity", "Flow"],
                        correctIndex: 1
                    )
                ]
            )

        case "Color Theory & Typography":
            return Quiz(
                lessonName: lessonName,
                durationMinutes: 25,
                passingPercent: 70,
                questions: [
                    QuizQuestion(
                        question: "Which color mode is used for print?",
                        options: ["RGB", "CMYK", "HSB", "Pantone"],
                        correctIndex: 1
                    )
                ]
            )

        default:
            // fallback quiz
            return Quiz(
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

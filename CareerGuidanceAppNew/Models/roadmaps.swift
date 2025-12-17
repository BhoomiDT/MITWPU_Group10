//
//  roadmaps.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import Foundation

enum LessonStatus: String, Codable {
    case startTest = "Start Test"
    case seeResults = "See Results"
}

struct Lesson: Codable {
    let name: String
    let dueDate: String
    let status: LessonStatus
}

struct Module: Codable {
    let title: String
    let lessons: [Lesson]
}

struct Roadmap: Codable {
    let title: String
    let description: String
    let imageName: String
    let modules: [Module]
}

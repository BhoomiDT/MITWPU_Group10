import Foundation
import UIKit

class OnboardingManager {
    static let shared = OnboardingManager()
    private let defaults = UserDefaults.standard
    
    // Keys
    private let kOnboardingCompleted = "kOnboardingCompleted"
    private let kLastVisitedSection = "kLastVisitedSection"
    private let kTechSkillsCompleted = "kTechSkillsCompleted"
    private let kCompletedSections = "kCompletedSections"
    private let kUserTechSkills = "kUserTechSkills"
    // Add this to OnboardingManager.swift
    var recommendedDomain: String? {
        get { UserDefaults.standard.string(forKey: "saved_recommended_domain") }
        set { UserDefaults.standard.set(newValue, forKey: "saved_recommended_domain") }
    }
    // The questionnaire only contains the 3 question sets
    let questionnaire = Questionnaire()
    // Add this to your OnboardingManager.swift
    var completedLessonIds: Set<String> {
        get {
            let array = UserDefaults.standard.stringArray(forKey: "completed_lessons") ?? []
            return Set(array)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: "completed_lessons")
        }
    }

    func markLessonComplete(id: String) {
        var ids = completedLessonIds
        ids.insert(id)
        completedLessonIds = ids
    }
    // We need 3 slots for the question answers (one for each data section)
    var userSelectedAnswers: [[String]] = [[], [], []]
    
    var lastVisitedSectionIndex: Int {
        get { defaults.integer(forKey: kLastVisitedSection) }
        set { defaults.set(newValue, forKey: kLastVisitedSection) }
    }

    var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: kOnboardingCompleted) }
        set { defaults.set(newValue, forKey: kOnboardingCompleted) }
    }
    
    var isTechSkillsCompleted: Bool {
        get { return defaults.bool(forKey: kTechSkillsCompleted) }
        set { defaults.set(newValue, forKey: kTechSkillsCompleted) }
    }
    
    var completedSectionIndexes: [Int] {
        get { return defaults.array(forKey: kCompletedSections) as? [Int] ?? [] }
        set { defaults.set(newValue, forKey: kCompletedSections) }
    }

    private init() {}
    
    // Updated: Logic to handle Technical Skills at index 1
    func saveTechSkills(_ skills: [String]) {
        defaults.set(skills, forKey: kUserTechSkills)
        isTechSkillsCompleted = true
        markSectionCompleted(index: 1)
    }
    
    func markSectionCompleted(index: Int) {
        // We now allow indexing up to 4 (0: Welcome, 1: Tech, 2-4: Questions)
        var completed = completedSectionIndexes
        if !completed.contains(index) {
            completed.append(index)
            completedSectionIndexes = completed
            print("Section \(index) marked as completed.")
            print("Completed sections: \(completed)")
        }
        
        // Final Completion Check: If we finished index 4 (the last question set)
        if index == 4 {
            isOnboardingCompleted = true
            print("Onboarding fully marked as complete.")
        }
    }

    // Updated: Progress bar calculation (Total 4 actual tasks: Tech + 3 Question Sets)
    func getProgress() -> Float {
        let totalSteps = 4.0 // Tech Skills + 3 Question Sections
        let completedSteps = Float(completedSectionIndexes.filter { $0 >= 1 }.count)
        return completedSteps / Float(totalSteps)
    }

    // Updated: Decides where to send the user if they close and reopen the app
    func getNextViewController() -> UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 1. If everything is done, go to results or home (return nil to handle in SceneDelegate)
        if isOnboardingCompleted { return nil }
        
        // 2. Resume from last visited if not completed
        let resumeIndex = lastVisitedSectionIndex
        
        // 3. Find the first incomplete section
        // Indices: 1 (Tech), 2 (Set 1), 3 (Set 2), 4 (Set 3)
        for index in 1...4 {
            if !completedSectionIndexes.contains(index) {
                let introVC = mainStoryboard.instantiateViewController(withIdentifier: "introVC") as! onboardingSectionIntroViewController
                introVC.sectionIndex = index
                return introVC
            }
        }
        return nil
    }

    func resetOnboarding() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        userSelectedAnswers = [[], [], []]
        defaults.synchronize()
        print("Onboarding Reset")
    }
}

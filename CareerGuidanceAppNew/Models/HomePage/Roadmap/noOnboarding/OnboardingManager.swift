import Foundation
import UIKit

class OnboardingManager {
    static let shared = OnboardingManager()
    //added T
    private let kOnboardingCompleted = "kOnboardingCompleted"
    private let kLastVisitedSection = "kLastVisitedSection"

    //added t
    var lastVisitedSectionIndex: Int {
        get { defaults.integer(forKey: kLastVisitedSection) }
        set { defaults.set(newValue, forKey: kLastVisitedSection) }
    }


    
    private let defaults = UserDefaults.standard
    private let kTechSkillsCompleted = "kTechSkillsCompleted"
    private let kCompletedSections = "kCompletedSections"
    private let kUserTechSkills = "kUserTechSkills"
    
    //added T
    var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: kOnboardingCompleted) }
        set { defaults.set(newValue, forKey: kOnboardingCompleted) }
    }

    
    // Reference to your existing data model
    let questionnaire = Questionnaire()
    
    private init() {}
    
    // MARK: - State Properties
    
    var isTechSkillsCompleted: Bool {
        get { return defaults.bool(forKey: kTechSkillsCompleted) }
        set { defaults.set(newValue, forKey: kTechSkillsCompleted) }
    }
    
    var completedSectionIndexes: [Int] {
        get { return defaults.array(forKey: kCompletedSections) as? [Int] ?? [] }
        set { defaults.set(newValue, forKey: kCompletedSections) }
    }
    
    // MARK: - Actions
    
    func saveTechSkills(_ skills: [String]) {
        defaults.set(skills, forKey: kUserTechSkills)
        isTechSkillsCompleted = true
        markSectionCompleted(index: 1)
    }
    //changed T
//    func markSectionCompleted(index: Int) {
//        var completed = completedSectionIndexes
//        if !completed.contains(index) {
//            completed.append(index)
//            completedSectionIndexes = completed
//            print("✅ Section \(index) marked as completed.")
//        }
//    }
    func markSectionCompleted(index: Int) {

        // 🚫 NEVER allow intro section to be completed
        guard index != 0 else {
            print("🚫 Attempt to mark intro section ignored")
            return
        }

        var completed = completedSectionIndexes
        if !completed.contains(index) {
            completed.append(index)
            completedSectionIndexes = completed
            print("✅ Section \(index) marked as completed.")
        }
    }

    
    // MARK: - Logic & Routing
    
    //changed T
//    func getProgress() -> Float {
//        let totalSteps = Float(questionnaire.sections.count)
//        guard totalSteps > 0 else { return 0.0 }
//        let stepsCompleted = Float(completedSectionIndexes.count)
//        return stepsCompleted / totalSteps
//    }
    
    func getProgress() -> Float {
        // 🚫 Exclude intro section (index 0)
        let validSections = questionnaire.sections.indices.filter { $0 != 0 }
        let completed = completedSectionIndexes.filter { $0 != 0 }

        return validSections.count > 0
            ? Float(completed.count) / Float(validSections.count)
            : 0
    }

    // chnaged T
//    func isOnboardingFullyComplete() -> Bool {
//        return getProgress() >= 1.0
//    }
    func isOnboardingFullyComplete() -> Bool {
        return isOnboardingCompleted
    }

    
    // FIX: Removed the 'from storyboard' parameter.
    // We explicitly load the "Main" storyboard inside this function now.
    
    //changed T
//    func getNextViewController() -> UIViewController? {
//        
//        // 1. Force load from Main.storyboard, where IntroVC and TechnicalSkills live
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        // 2. Iterate to find the first INCOMPLETE section
//        for (index, _) in questionnaire.sections.enumerated() {
//            
//            if !completedSectionIndexes.contains(index) {
//                
//                // Case: Tech Skills (Index 1) needs special handling if you want to skip Intro
//                // But generally, we route to IntroVC first
//                if let introVC = mainStoryboard.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
//                    introVC.sectionIndex = index
//                    return introVC
//                }
//            }
//        }
//        
//        return nil // Onboarding is done
//    }
    func getNextViewController() -> UIViewController? {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        // 1️⃣ Resume from last visited section if valid
        let resumeIndex = lastVisitedSectionIndex

        if resumeIndex > 0 &&
           resumeIndex < questionnaire.sections.count &&
           !completedSectionIndexes.contains(resumeIndex) {

            let introVC = mainStoryboard.instantiateViewController(
                withIdentifier: "introVC"
            ) as! onboardingSectionIntroViewController

            introVC.sectionIndex = resumeIndex
            return introVC
        }

        // 2️⃣ Fallback → first incomplete section
        for index in questionnaire.sections.indices {

            if index == 0 { continue }

            if !completedSectionIndexes.contains(index) {
                let introVC = mainStoryboard.instantiateViewController(
                    withIdentifier: "introVC"
                ) as! onboardingSectionIntroViewController

                introVC.sectionIndex = index
                return introVC
            }
        }

        return nil
    }

    
    // MARK: - Debugging
    func resetOnboarding() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print("⚠️ Onboarding Reset")
    }
}

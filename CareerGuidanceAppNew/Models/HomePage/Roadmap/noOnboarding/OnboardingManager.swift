import Foundation
import UIKit

class OnboardingManager {
    static let shared = OnboardingManager()
    private let kOnboardingCompleted = "kOnboardingCompleted"
    private let kLastVisitedSection = "kLastVisitedSection"

    var lastVisitedSectionIndex: Int {
        get { defaults.integer(forKey: kLastVisitedSection) }
        set { defaults.set(newValue, forKey: kLastVisitedSection) }
    }

    private let defaults = UserDefaults.standard
    private let kTechSkillsCompleted = "kTechSkillsCompleted"
    private let kCompletedSections = "kCompletedSections"
    private let kUserTechSkills = "kUserTechSkills"
    
    var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: kOnboardingCompleted) }
        set { defaults.set(newValue, forKey: kOnboardingCompleted) }
    }

    let questionnaire = Questionnaire()
    
    private init() {}
    
    var isTechSkillsCompleted: Bool {
        get { return defaults.bool(forKey: kTechSkillsCompleted) }
        set { defaults.set(newValue, forKey: kTechSkillsCompleted) }
    }
    
    var completedSectionIndexes: [Int] {
        get { return defaults.array(forKey: kCompletedSections) as? [Int] ?? [] }
        set { defaults.set(newValue, forKey: kCompletedSections) }
    }
    
    func saveTechSkills(_ skills: [String]) {
        defaults.set(skills, forKey: kUserTechSkills)
        isTechSkillsCompleted = true
        markSectionCompleted(index: 1)
    }
    
    func markSectionCompleted(index: Int) {

        guard index != 0 else {
            print("Attempt to mark intro section ignored")
            return
        }

        var completed = completedSectionIndexes
        if !completed.contains(index) {
            completed.append(index)
            completedSectionIndexes = completed
            print("Section \(index) marked as completed.")
        }
    }

    func getProgress() -> Float {
        let validSections = questionnaire.sections.indices.filter { $0 != 0 }
        let completed = completedSectionIndexes.filter { $0 != 0 }

        return validSections.count > 0
            ? Float(completed.count) / Float(validSections.count)
            : 0
    }

    func isOnboardingFullyComplete() -> Bool {
        return isOnboardingCompleted
    }

    func getNextViewController() -> UIViewController? {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

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

    
    func resetOnboarding() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        print("Onboarding Reset")
    }
}

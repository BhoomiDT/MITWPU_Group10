//
//  onboardingSectionIntroViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit

class onboardingSectionIntroViewController: UIViewController {
    
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    var userSelectedAnswers: [[String]] = [[], [], []]
    var questionnaire: Questionnaire?
    
    var sectionIndex: Int = 0
    var questionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
        //setupBackChevron()
        navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.height / 2
        iconBackgroundView.layer.masksToBounds = true
    }
    private var hasShownWelcomeModal = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if sectionIndex == 0 && !hasShownWelcomeModal {
            presentWelcomePage()
        }
    }

    private func presentWelcomePage() {
        let storyboard = UIStoryboard(name: "WelcomePage", bundle: nil)
        if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomePage") as? WelcomeViewController {
            welcomeVC.modalPresentationStyle = .pageSheet
            hasShownWelcomeModal = true
            
            self.present(welcomeVC, animated: true, completion: nil)
        }
    }
    
    func configureContent() {
        let sections = OnboardingManager.shared.questionnaire.sections
        guard sectionIndex < sections.count else { return }
        let sectionData = sections[sectionIndex]
        
        titleLabel.text = sectionData.title
        subtitleLabel.text = sectionData.subtitle
        
        if let image = UIImage(systemName: sectionData.symbolName) {
            imageView.image = image
            imageView.tintColor = .appTeal
        }
        
        btnSkip.isHidden = (sectionIndex == 0)
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        //added T
        OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
        
        if sectionIndex == 0 {
            //change commented this
            //            OnboardingManager.shared.markSectionCompleted(index: 0)
            if let nextIntro = storyboard?.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
                nextIntro.sectionIndex = 1
                navigationController?.pushViewController(nextIntro, animated: true)
            }
        }
        else if sectionIndex == 1 {
            if let techVC = storyboard?.instantiateViewController(withIdentifier: "technicalSkills") as? SkillsViewController {
                navigationController?.pushViewController(techVC, animated: true)
            }
        }
        if sectionIndex >= 3 { //3 sections of questions
                     calculateAndPushResults()
                     return
                }
        else {
            if let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as? onboardingQuestionViewController {
                
                
                questionVC.questionnaire = OnboardingManager.shared.questionnaire
                
                questionVC.sectionIndex = self.sectionIndex
                questionVC.userSelectedAnswers = self.userSelectedAnswers
                navigationController?.pushViewController(questionVC, animated: true)
            }
        }
    }
    func calculateAndPushResults() {
            var finalScores: [Double] = [0, 0, 0, 0, 0, 0] // R, I, A, S, E, C
            
            let scoreMap: [String: Double] = [
                "Strongly Disagree": 1.0,
                "Disagree": 2.0,
                "Neutral": 3.0,
                "Agree": 4.0,
                "Strongly Agree": 5.0
            ]
        let allAnswers = OnboardingManager.shared.userSelectedAnswers

            // Math for the Interleaved Set (R,I,A,S,E,C, R,I,A,S,E,C)
            for section in allAnswers {
                for (qIndex, answer) in section.enumerated() {
                    let points = scoreMap[answer] ?? 0.0
                    let riasecIndex = qIndex % 6
                    finalScores[riasecIndex] += points
                }
            }

            // Get ML Prediction
            if let domain = CareerPredictionManager.shared.getRecommendation(scores: finalScores) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let analysisVC = storyboard.instantiateViewController(withIdentifier: "path") as? AnalysisTable {
                    
                    // 1. Set the Path (Title)
                    analysisVC.recommendedPath = domain.replacingOccurrences(of: "_", with: " ")
                    
                    // 2. Prepare the RIASEC Progress Bars
                    let labels = ["Realistic", "Investigative", "Artistic", "Social", "Enterprising", "Conventional"]
                    let colors: [UIColor] = [.systemRed, .systemBlue, .systemPurple, .systemGreen, .systemOrange, .systemTeal]
                    
                    analysisVC.riasecData = finalScores.enumerated().map { (i, score) in
                        // Max score for 6 questions is 30.0
                        return (label: labels[i], score: Float(score / 30.0), color: colors[i])
                    }
                    
                    navigationController?.pushViewController(analysisVC, animated: true)
                }
            }
        }
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        //changed T
        //        let homeStoryboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
        //
        //        if let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
        //            navigationController?.setViewControllers([homeVC], animated: true)
        //        }
        

        OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
        
        let homeStoryboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
        
        if let homeVC = homeStoryboard.instantiateViewController(
            withIdentifier: "HomePageViewController"
        ) as? HomePageViewController {
            
            navigationController?.setViewControllers([homeVC], animated: true)
        }
        
        
    }
}
   

    


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
    // Add this property to store the name
    var recommendedDomainName: String? {
        get { UserDefaults.standard.string(forKey: "kRecommendedDomainName") }
        set { UserDefaults.standard.set(newValue, forKey: "kRecommendedDomainName") }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
        navigationItem.hidesBackButton = (sectionIndex != 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard checkAuthentication() else { return }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.height / 2
        iconBackgroundView.layer.masksToBounds = true
    }

    
    func configureContent() {
        let questionnaire = OnboardingManager.shared.questionnaire
        
        if sectionIndex == 0 {
            titleLabel.text = "Your Personal Roadmap"
            subtitleLabel.text = "Let's create a personalized career path tailored just for you"
            imageView.image = UIImage(systemName: "figure.walk")
        } else if sectionIndex == 1 {
            titleLabel.text = "Technical Skills"
            subtitleLabel.text = "Add your technical skills to get a personalized roadmap"
            imageView.image = UIImage(systemName: "terminal.fill")
        } else {
            let dataIndex = sectionIndex - 2
            guard dataIndex < questionnaire.sections.count else { return }
            
            let sectionData = questionnaire.sections[dataIndex]
            titleLabel.text = sectionData.title
            subtitleLabel.text = sectionData.subtitle
            imageView.image = UIImage(systemName: sectionData.symbolName)
        }
        
        btnSkip.isHidden = (sectionIndex == 0)
    }
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
            
            switch sectionIndex {
            case 0:
                navigateToSectionIntro(index: 1)
                
            case 1:
                if let techVC = storyboard?.instantiateViewController(withIdentifier: "technicalSkills") as? SkillsViewController {
                    navigationController?.pushViewController(techVC, animated: true)
                }
                
            case 2, 3, 4:
                if let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as? onboardingQuestionViewController {
                    questionVC.questionnaire = OnboardingManager.shared.questionnaire
                   
                    questionVC.sectionIndex = self.sectionIndex - 2
                    
                    navigationController?.pushViewController(questionVC, animated: true)
                }
                
            default:
                calculateAndPushResults()
            }        }

        private func navigateToSectionIntro(index: Int) {
            if let nextIntro = storyboard?.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
                nextIntro.sectionIndex = index
                navigationController?.pushViewController(nextIntro, animated: true)
            }
    }
 
//    func calculateAndPushResults() {
//        OnboardingManager.shared.isOnboardingCompleted = true
//        let allAnswers = OnboardingManager.shared.userSelectedAnswers
//            
//            guard allAnswers.flatMap({ $0 }).count > 0 else {
//                print("Error: No answers found to calculate results")
//                return
//            }
//        
//            var finalScores: [Double] = [0, 0, 0, 0, 0, 0] // R, I, A, S, E, C
//            
//            let scoreMap: [String: Double] = [
//                "Strongly Disagree": 1.0,
//                "Disagree": 2.0,
//                "Neutral": 3.0,
//                "Agree": 4.0,
//                "Strongly Agree": 5.0
//            ]
//   
//            for section in allAnswers {
//                for (qIndex, answer) in section.enumerated() {
//                    let points = scoreMap[answer] ?? 0.0
//                    let riasecIndex = qIndex % 6
//                    finalScores[riasecIndex] += points
//                }
//            }
//
//            // Get ML Prediction
//            if let domain = CareerPredictionManager.shared.getRecommendation(scores: finalScores) {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let analysisVC = storyboard.instantiateViewController(withIdentifier: "path") as? AnalysisTable {
//                    
//                    analysisVC.recommendedPath = domain.replacingOccurrences(of: "_", with: " ")
//                    
//                    let labels = ["Realistic", "Investigative", "Artistic", "Social", "Enterprising", "Conventional"]
//                    let colors: [UIColor] = [.systemRed, .systemBlue, .systemPurple, .systemGreen, .systemOrange, .systemTeal]
//                    
//                    analysisVC.riasecData = finalScores.enumerated().map { (i, score) in
//                        return (label: labels[i], score: Float(score / 30.0), color: colors[i])
//                    }
//                    
//                    navigationController?.pushViewController(analysisVC, animated: true)
//                }
//            }
//        }
    func calculateAndPushResults() {
        OnboardingManager.shared.isOnboardingCompleted = true
        
        let scores = OnboardingManager.shared.calculateRIASEC()
        let selectedSkills = UserDefaults.standard.stringArray(forKey: "kUserTechSkills") ?? []
        
        // 1. Call the TOP THREE function, not the single recommendation one
        if let top3 = CareerPredictionManager.shared.getTopThreeRecommendations(scores: scores, skills: selectedSkills) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let analysisVC = storyboard.instantiateViewController(withIdentifier: "path") as? AnalysisTable {
                
                // 2. Assign the WHOLE ARRAY (This fixes the 'get-only' property error)
                analysisVC.recommendations = top3
                
                let labels = ["Realistic", "Investigative", "Artistic", "Social", "Enterprising", "Conventional"]
                let colors: [UIColor] = [.systemRed, .systemBlue, .systemPurple, .systemGreen, .systemOrange, .systemTeal]
                
                analysisVC.riasecData = scores.enumerated().map { (i, score) in
                    return (label: labels[i], score: Float(score / 30.0), color: colors[i])
                }
                
                // Save and sync
                if let topPath = top3.first {
                    OnboardingManager.shared.recommendedDomain = topPath.domain
                    Task {
                        await ProfileService.shared.syncLocalToRemote()
                    }
                }
                
                navigationController?.pushViewController(analysisVC, animated: true)
            }
        }
    }
    @IBAction func skipButtonTapped(_ sender: UIButton) {
       
        OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
        
        let homeStoryboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
        
        if let homeVC = homeStoryboard.instantiateViewController(
            withIdentifier: "HomePageViewController"
        ) as? HomePageViewController {
            
            navigationController?.setViewControllers([homeVC], animated: true)
        }
        
        
    }
}
   

    


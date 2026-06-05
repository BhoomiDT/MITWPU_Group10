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
    private let sheetView = UIView()
    private let sheetTitleLabel = UILabel()
    private let sheetSubtitleLabel = UILabel()
    private let sheetContinueBtn = UIButton(type: .system)
    private let sheetSkipBtn = UIButton(type: .system)
    
    private let topIconContainer = UIView()
    private let topIconView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = (sectionIndex != 1)
        setupCustomUI()
        configureContent()
    }
    
    private func setupCustomUI() {
        // Hide original storyboards UI
        iconBackgroundView?.isHidden = true
        imageView?.isHidden = true
        titleLabel?.isHidden = true
        subtitleLabel?.isHidden = true
        btnContinue?.isHidden = true
        btnSkip?.isHidden = true
        
        view.backgroundColor = .themeBg
        
        // Setup top animated icon
        let colors: [UIColor] = [.systemPink, .systemTeal, .systemOrange, .systemPurple, .systemGreen]
        let color = colors[sectionIndex % colors.count]
        
        topIconContainer.backgroundColor = color.withAlphaComponent(0.3)
        topIconContainer.layer.cornerRadius = 60
        topIconContainer.layer.masksToBounds = true
        topIconContainer.layer.borderWidth = 2
        topIconContainer.layer.borderColor = color.cgColor
        topIconContainer.alpha = 0
        topIconContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        topIconView.tintColor = color
        topIconView.contentMode = .scaleAspectFit
        
        view.addSubview(topIconContainer)
        topIconContainer.addSubview(topIconView)
        
        topIconContainer.translatesAutoresizingMaskIntoConstraints = false
        topIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup Bottom Sheet
        sheetView.backgroundColor = .cardBg
        sheetView.layer.cornerRadius = 40
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // Push it down initially for animation
        sheetView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        // Sheet Content
        sheetTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        sheetTitleLabel.textColor = .textPrimary
        sheetTitleLabel.numberOfLines = 0
        sheetTitleLabel.textAlignment = .center
        
        sheetSubtitleLabel.font = .systemFont(ofSize: 16)
        sheetSubtitleLabel.textColor = .textSecondary
        sheetSubtitleLabel.numberOfLines = 0
        sheetSubtitleLabel.textAlignment = .center
        
        sheetContinueBtn.backgroundColor = .accentTeal
        sheetContinueBtn.setTitle("Continue", for: .normal)
        sheetContinueBtn.setTitleColor(.white, for: .normal)
        sheetContinueBtn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        sheetContinueBtn.layer.cornerRadius = 14
        sheetContinueBtn.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        sheetSkipBtn.setTitle("Skip for now", for: .normal)
        sheetSkipBtn.setTitleColor(.textSecondary, for: .normal)
        sheetSkipBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        sheetSkipBtn.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
        sheetView.addSubview(sheetTitleLabel)
        sheetView.addSubview(sheetSubtitleLabel)
        sheetView.addSubview(sheetContinueBtn)
        sheetView.addSubview(sheetSkipBtn)
        
        sheetTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetContinueBtn.translatesAutoresizingMaskIntoConstraints = false
        sheetSkipBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topIconContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topIconContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            topIconContainer.widthAnchor.constraint(equalToConstant: 120),
            topIconContainer.heightAnchor.constraint(equalToConstant: 120),
            
            topIconView.centerXAnchor.constraint(equalTo: topIconContainer.centerXAnchor),
            topIconView.centerYAnchor.constraint(equalTo: topIconContainer.centerYAnchor),
            topIconView.widthAnchor.constraint(equalToConstant: 60),
            topIconView.heightAnchor.constraint(equalToConstant: 60),
            
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            sheetTitleLabel.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 40),
            sheetTitleLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            sheetTitleLabel.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            
            sheetSubtitleLabel.topAnchor.constraint(equalTo: sheetTitleLabel.bottomAnchor, constant: 16),
            sheetSubtitleLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            sheetSubtitleLabel.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            
            sheetContinueBtn.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            sheetContinueBtn.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            sheetContinueBtn.heightAnchor.constraint(equalToConstant: 54),
            sheetContinueBtn.bottomAnchor.constraint(equalTo: sheetSkipBtn.topAnchor, constant: -16),
            
            sheetSkipBtn.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            sheetSkipBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sheetSkipBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.topIconContainer.alpha = 1
            self.topIconContainer.transform = .identity
            self.sheetView.transform = .identity
        }
    }
    
    @objc private func continueTapped() {
        continueButtonTapped(UIButton())
    }
    
    @objc private func skipTapped() {
        skipButtonTapped(UIButton())
    }
    
    func configureContent() {
        let questionnaire = OnboardingManager.shared.questionnaire
        
        if sectionIndex == 0 {
            sheetTitleLabel.text = "Your Personal Roadmap"
            sheetSubtitleLabel.text = "Let's create a personalized career path tailored just for you"
            topIconView.image = UIImage(systemName: "figure.walk")
        } else if sectionIndex == 1 {
            sheetTitleLabel.text = "Technical Skills"
            sheetSubtitleLabel.text = "Add your technical skills to get a personalized roadmap"
            topIconView.image = UIImage(systemName: "terminal.fill")
        } else {
            let dataIndex = sectionIndex - 2
            guard dataIndex < questionnaire.sections.count else { return }
            
            let sectionData = questionnaire.sections[dataIndex]
            sheetTitleLabel.text = sectionData.title
            sheetSubtitleLabel.text = sectionData.subtitle
            topIconView.image = UIImage(systemName: sectionData.symbolName)
        }
        
        sheetSkipBtn.isHidden = (sectionIndex == 0)
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
   

    


//
//  onboardingQuestionViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit

class onboardingQuestionViewController: UIViewController {
    
    var questionnaire: Questionnaire!
    var sectionIndex: Int = 0
    var questionIndex: Int = 0
    var userSelectedAnswers: [[String]] = [[], [], []]
    var currentSectionAnswers: [String] = []

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var optionButton1: UIButton!
    @IBOutlet weak var optionButton2: UIButton!
    @IBOutlet weak var optionButton3: UIButton!
    @IBOutlet weak var optionButton4: UIButton!
    
    @IBOutlet weak var optionButton5: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let sheetView = UIView()
    private let sheetQuestionLabel = UILabel()
    private let bottomCurveView = UIView()
    private let bottomNextBtn = UIButton(type: .system)
    
    private var optionButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Question \(questionIndex+1)"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if questionIndex == 0 {
            currentSectionAnswers = Array(repeating: "", count: questionnaire.sections[sectionIndex].questions.count)
        }
        
        setupCustomUI()
        configureUI()
        setupBackChevron()
    }
    
    private func setupCustomUI() {
        // Hide IBOutlets
        questionLabel?.isHidden = true
        optionButton1?.isHidden = true
        optionButton2?.isHidden = true
        optionButton3?.isHidden = true
        optionButton4?.isHidden = true
        optionButton5?.isHidden = true
        nextButton?.isHidden = true
        
        view.backgroundColor = .themeBg
        
        // Style progress view
        progressView.progressTintColor = UIColor.accentTeal
        progressView.trackTintColor = UIColor.dividerColor
        
        // Sheet View
        sheetView.backgroundColor = .cardBg
        sheetView.layer.cornerRadius = 40
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        // Bottom Curve
        bottomCurveView.backgroundColor = .themeBg
        bottomCurveView.layer.cornerRadius = 40
        bottomCurveView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(bottomCurveView)
        bottomCurveView.translatesAutoresizingMaskIntoConstraints = false
        
        // Next Button
        bottomNextBtn.setTitleColor(.white, for: .normal)
        bottomNextBtn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bottomNextBtn.isEnabled = false
        bottomNextBtn.alpha = 0.5
        bottomNextBtn.addTarget(self, action: #selector(bottomNextTapped), for: .touchUpInside)
        bottomCurveView.addSubview(bottomNextBtn)
        bottomNextBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Question Label
        sheetQuestionLabel.font = .systemFont(ofSize: 22, weight: .bold)
        sheetQuestionLabel.textColor = .textPrimary
        sheetQuestionLabel.numberOfLines = 0
        sheetQuestionLabel.textAlignment = .center
        sheetView.addSubview(sheetQuestionLabel)
        sheetQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Options Stack
        let optionsStack = UIStackView()
        optionsStack.axis = .vertical
        optionsStack.spacing = 16
        sheetView.addSubview(optionsStack)
        optionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<5 {
            let btn = UIButton(type: .system)
            btn.backgroundColor = UIColor.progressTrackBg
            btn.setTitleColor(.textPrimary, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            btn.layer.cornerRadius = 16
            btn.heightAnchor.constraint(equalToConstant: 54).isActive = true
            btn.addTarget(self, action: #selector(customOptionTapped(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(btn)
            optionButtons.append(btn)
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            sheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sheetQuestionLabel.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 40),
            sheetQuestionLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            sheetQuestionLabel.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            
            optionsStack.topAnchor.constraint(equalTo: sheetQuestionLabel.bottomAnchor, constant: 40),
            optionsStack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            optionsStack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            
            bottomCurveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCurveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCurveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCurveView.heightAnchor.constraint(equalToConstant: 100),
            
            bottomNextBtn.centerXAnchor.constraint(equalTo: bottomCurveView.centerXAnchor),
            bottomNextBtn.topAnchor.constraint(equalTo: bottomCurveView.topAnchor, constant: 20),
            bottomNextBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Animation
        sheetView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.sheetView.transform = .identity
        }
    }
    
    @objc private func bottomNextTapped() {
        nextTapped(UIButton())
    }
    
    @objc private func customOptionTapped(_ sender: UIButton) {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Animation
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        
        optionTapped(sender)
    }
    
        func setupBackChevron() {
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(backChevronTapped)
            )
            navigationItem.leftBarButtonItem = backButton
        }
    @objc func backChevronTapped() {
        if questionIndex > 0 {
            navigationController?.popViewController(animated: true)
            return
        }
        let alert = UIAlertController(
            title: "Go Back?",
            message: "If you go back now, this section won’t be completed.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Stay", style: .cancel))

        alert.addAction(UIAlertAction(title: "Go Back", style: .destructive) { _ in
            self.goToCurrentSectionIntro()
        })

        present(alert, animated: true)
    }

    private func goToCurrentSectionIntro() {
        OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
        
        let expectedIntroIndex = sectionIndex + 2
        
        if let nav = navigationController {
            for vc in nav.viewControllers {
                if let introVC = vc as? onboardingSectionIntroViewController {
                    if introVC.sectionIndex == expectedIntroIndex {
                        nav.popToViewController(introVC, animated: true)
                        return
                    }
                }
            }
            
            nav.popViewController(animated: true)
        }
    }

    private func configureUI() {
        let section = questionnaire.sections[sectionIndex]
        let question = section.questions[questionIndex]
        
        sheetQuestionLabel.text = String(question.qText)
        
        let options = question.options
        
        for i in 0..<optionButtons.count {
            if i < options.count {
                optionButtons[i].setTitle(options[i], for: .normal)
                optionButtons[i].isHidden = false
            } else {
                optionButtons[i].isHidden = true
            }
        }
        
        let isLastQuestionInSection = questionIndex == section.questions.count - 1
        let isLastSection = sectionIndex == questionnaire.sections.count - 1
        
        bottomNextBtn.setTitle(isLastQuestionInSection && isLastSection ? "Finish" : "Next", for: .normal)
        
        let totalQuestions = section.questions.count
        let current = questionIndex + 1
        let progress = Float(current) / Float(totalQuestions)
        progressView.setProgress(progress, animated: true)
    }
    private func resetOptionButtonBorders() {
        for button in optionButtons {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
            button.backgroundColor = UIColor.progressTrackBg
        }
    }
    
    @IBAction func optionTapped(_ sender: UIButton) {
        resetOptionButtonBorders()
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor(hex:"1fa5a1").cgColor
        sender.layer.cornerRadius = 16
        sender.backgroundColor = .cardBg
        sender.clipsToBounds = true
        print("Selected option: \(sender.currentTitle ?? "")")
                if let answer = sender.currentTitle {
                    if currentSectionAnswers.count > questionIndex {
                        currentSectionAnswers[questionIndex] = answer
                    }
                }
        bottomNextBtn.isEnabled = true
        bottomNextBtn.alpha = 1.0
    }
    private func finishSection() {
        OnboardingManager.shared.userSelectedAnswers[sectionIndex] = currentSectionAnswers
        OnboardingManager.shared.markSectionCompleted(index: sectionIndex)
        routeAfterSectionCompletion()
    }
    
    private func routeAfterSectionCompletion() {

        let completedIndex = self.sectionIndex + 2
        OnboardingManager.shared.markSectionCompleted(index: completedIndex)
        
        let nextDataIndex = sectionIndex + 1
        let totalDataSections = OnboardingManager.shared.questionnaire.sections.count
        
        if nextDataIndex < totalDataSections {
            if let introVC = storyboard?.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
                introVC.sectionIndex = nextDataIndex + 2
                navigationController?.pushViewController(introVC, animated: true)
            }
        } else {
            goToResults()
        }
    }
    private func goToResults() {
        if let nav = navigationController {
            for vc in nav.viewControllers {
                if let introVC = vc as? onboardingSectionIntroViewController {
                    introVC.calculateAndPushResults()
                    return
                }
            }
        }
    }
        
@IBAction func nextTapped(_ sender: UIButton)  {
    OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
            let section = questionnaire.sections[sectionIndex]
            
            if questionIndex < section.questions.count - 1 {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as? onboardingQuestionViewController else { return }
                
                vc.questionnaire = questionnaire
                vc.sectionIndex = sectionIndex
                vc.questionIndex = questionIndex + 1
                vc.userSelectedAnswers = self.userSelectedAnswers
                vc.currentSectionAnswers = self.currentSectionAnswers
                
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            userSelectedAnswers[sectionIndex] = currentSectionAnswers
            finishSection()
        }
    }


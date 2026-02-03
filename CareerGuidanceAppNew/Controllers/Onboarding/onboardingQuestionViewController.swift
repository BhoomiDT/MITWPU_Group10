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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        self.title = String("Question \(questionIndex+1)")
        navigationController?.navigationBar.prefersLargeTitles = true
        if questionIndex == 0 {
                    currentSectionAnswers = Array(repeating: "", count: questionnaire.sections[sectionIndex].questions.count)
                }
        configureUI()
        setupBackChevron()
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
        
        questionLabel.text = String(question.qText)
        
        let options = question.options
        let buttons = [optionButton1, optionButton2, optionButton3, optionButton4,optionButton5]
        
        for i in 0..<buttons.count {
            if i < options.count {
                buttons[i]?.setTitle(options[i], for: .normal)
                buttons[i]?.isHidden = false
            } else {
                buttons[i]?.isHidden = true
            }
        }
        
        let isLastQuestionInSection = questionIndex == section.questions.count - 1
        let isLastSection = sectionIndex == questionnaire.sections.count - 1
        
        nextButton.setTitle(isLastQuestionInSection && isLastSection ? "Finish" : "Next", for: .normal)
        
        let totalQuestions = section.questions.count
        let current = questionIndex + 1
        let progress = Float(current) / Float(totalQuestions)
        progressView.setProgress(progress, animated: true)
    }
    private func resetOptionButtonBorders() {
        let buttons = [
            optionButton1,
            optionButton2,
            optionButton3,
            optionButton4,
            optionButton5
        ]
        
        for button in buttons {
            button?.layer.borderWidth = 0
            button?.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBAction func optionTapped(_ sender: UIButton) {
        resetOptionButtonBorders()
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor(hex:"1fa5a1").cgColor
        sender.layer.cornerRadius = 8
        sender.clipsToBounds = true
        print("Selected option: \(sender.currentTitle ?? "")")
                if let answer = sender.currentTitle {
                    if currentSectionAnswers.count > questionIndex {
                        currentSectionAnswers[questionIndex] = answer
                    }
                }
        nextButton.isEnabled = true
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


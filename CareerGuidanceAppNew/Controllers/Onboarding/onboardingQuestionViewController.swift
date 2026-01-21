import UIKit

class onboardingQuestionViewController: UIViewController {
    
    var questionnaire: Questionnaire!
    var sectionIndex: Int = 0      // section
    var questionIndex: Int = 0     // which question in section
    
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
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
        //aded t
        nextButton.isEnabled = false
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

        // If NOT first question → normal back
        if questionIndex > 0 {
            navigationController?.popViewController(animated: true)
            return
        }

        // FIRST question → ask confirmation
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

        // Look for existing intro VC for this section in stack
        if let nav = navigationController {
            for vc in nav.viewControllers {
                if let introVC = vc as? onboardingSectionIntroViewController,
                   introVC.sectionIndex == sectionIndex {
                    
                    nav.popToViewController(introVC, animated: true)
                    return
                }
            }
        }

        // Fallback
        guard let introVC = storyboard?.instantiateViewController(
            withIdentifier: "introVC"
        ) as? onboardingSectionIntroViewController else {
            return
        }

        introVC.sectionIndex = sectionIndex
        navigationController?.popViewController(animated: true)
    }

    private func configureUI() {
        let section = questionnaire.sections[sectionIndex]
        let question = section.questions[questionIndex]
        
        subtitleLabel.text = String("Question \(questionIndex+1)")
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
        //added T
        nextButton.isEnabled = true
    }
    // added fucntion
    private func finishSection() {
        OnboardingManager.shared.markSectionCompleted(index: sectionIndex)
        routeAfterSectionCompletion()
    }
    
    private func routeAfterSectionCompletion() {

        let nextSectionIndex = sectionIndex + 1
        let lastSectionIndex = questionnaire.sections.count - 1

        if sectionIndex == lastSectionIndex {

            OnboardingManager.shared.isOnboardingCompleted = true

            if let analysisVC = storyboard?.instantiateViewController(
                withIdentifier: "path"
            ) {
                navigationController?.pushViewController(analysisVC, animated: true)
            } else {
                navigationController?.popToRootViewController(animated: true)
            }
            return
        }

        if let introVC = storyboard?.instantiateViewController(
            withIdentifier: "introVC"
        ) as? onboardingSectionIntroViewController {

            introVC.sectionIndex = nextSectionIndex
            navigationController?.pushViewController(introVC, animated: true)
        }
    }

        
@IBAction func nextTapped(_ sender: UIButton)  {
            //            let section = questionnaire.sections[sectionIndex]
            //
            //            if questionIndex + 1 < section.questions.count {
            //                guard let vc = storyboard?.instantiateViewController(
            //                    withIdentifier: "QuestionVC"
            //                ) as? onboardingQuestionViewController else { return }
            //
            //                vc.questionnaire = questionnaire
            //                vc.sectionIndex = sectionIndex
            //                vc.questionIndex = questionIndex + 1
            //
            //                navigationController?.pushViewController(vc, animated: true)
            //                return
            //            }
            //
            //
            //            OnboardingManager.shared.markSectionCompleted(index: sectionIndex)
            //
            //
            //            let nextSectionIndex = sectionIndex + 1
            //
            //            if nextSectionIndex < questionnaire.sections.count {
            //
            //                if let introVC = storyboard?.instantiateViewController(
            //                    withIdentifier: "introVC"
            //                ) as? onboardingSectionIntroViewController {
            //
            //                    introVC.sectionIndex = nextSectionIndex
            //                    navigationController?.pushViewController(introVC, animated: true)
            //                }
            //            } else {
            //
            //
            //                if let pathVC = storyboard?.instantiateViewController(withIdentifier: "path") {
            //                    navigationController?.pushViewController(pathVC, animated: true)
            //                } else {
            //
            //                    print(" Error: Could not find ViewController with identifier 'path' in this storyboard")
            //                    navigationController?.popToRootViewController(animated: true)
            //                }
            //            }
            //        }
            OnboardingManager.shared.lastVisitedSectionIndex = sectionIndex
            
            nextButton.isEnabled = false
            
            let section = questionnaire.sections[sectionIndex]
            
            if questionIndex < section.questions.count - 1 {
                guard let vc = storyboard?.instantiateViewController(
                    withIdentifier: "QuestionVC"
                ) as? onboardingQuestionViewController else { return }
                
                vc.questionnaire = questionnaire
                vc.sectionIndex = sectionIndex
                vc.questionIndex = questionIndex + 1
                
                navigationController?.pushViewController(vc, animated: true)
                nextButton.isEnabled = true
                
                return
            }
            
            finishSection()}
    }


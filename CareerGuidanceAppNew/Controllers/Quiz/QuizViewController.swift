//
//  QuizViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 10/12/25.
//

import UIKit

class QuizViewController: UIViewController {
    var lesson: Lesson?
    var quiz: Quiz?
    var onRoadmapStarted: (() -> Void)?
    var roadmapStatus: Roadmap?
    var onQuizCompleted: (() -> Void)?
    var questionIndex: Int = 0

    @IBOutlet weak var QuestionTextLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var optionStack: UIStackView!
    @IBOutlet weak var optionButton1: UIButton!
    @IBOutlet weak var optionButton2: UIButton!
    @IBOutlet weak var optionButton3: UIButton!
    @IBOutlet weak var optionButton4: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    private var selectedOptionIndices: [Int?] = []
    private var currentQuestionIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        nextButton.layer.cornerRadius = 20
        optionStack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        optionButton1.tag = 0
        optionButton2.tag = 1
        optionButton3.tag = 2
        optionButton4.tag = 3
        guard let quiz = quiz else { return }
        
            selectedOptionIndices = Array(
                repeating: nil,
                count: quiz.questions.count
            )
        loadQuestion()
        setupBackChevron()
    }
    private func goToMilestoneScreen() {
        if let nav = navigationController {
            for vc in nav.viewControllers {
                if let milestoneVC = vc as? NewModuleScreen {
                    nav.popToViewController(milestoneVC, animated: true)
                    return
                }
            }
        }
        navigationController?.popViewController(animated: true)
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
        if currentQuestionIndex > 0 {
                currentQuestionIndex -= 1
                loadQuestion()
                return
            }
        let alert = UIAlertController(
            title: "Exit Quiz?",
            message: "If you go back now, your progress in this test will be lost.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Exit", style: .destructive) { _ in
            self.goToMilestoneScreen()
        })

        present(alert, animated: true)
    }
    
    @IBAction func optionTapped(_ sender: UIButton) {
        print("Tapped index:", sender.tag)
        let selectedIndex = sender.tag
        selectedOptionIndices[currentQuestionIndex] = selectedIndex
        updateSelectionUI(selectedIndex: selectedIndex)
        
    }
    private func loadQuestion() {
        guard let quiz = quiz else { return }
        self.title = String("Question \(currentQuestionIndex+1)")

        let question = quiz.questions[currentQuestionIndex]

        QuestionTextLabel.text = question.question

        optionButton1.setTitle(question.options[0], for: .normal)
        optionButton2.setTitle(question.options[1], for: .normal)
        optionButton3.setTitle(question.options[2], for: .normal)
        optionButton4.setTitle(question.options[3], for: .normal)
        
        if let selectedIndex = selectedOptionIndices[currentQuestionIndex] {
                updateSelectionUI(selectedIndex: selectedIndex)
            } else {
                resetOptionUI()
            }
        updateNextButtonTitle()
        updateProgressBar()
    }
    private func updateProgressBar() {
        guard let quiz = quiz else { return }

        let progress = Float(currentQuestionIndex + 1) / Float(quiz.questions.count)
        progressBar.setProgress(progress, animated: true)
    }
    private func updateNextButtonTitle() {
        guard let quiz = quiz else { return }

        if currentQuestionIndex == quiz.questions.count - 1 {
            nextButton.setTitle("Submit", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }
    
    private func isCurrentQuestionAnswered() -> Bool {
        return selectedOptionIndices[currentQuestionIndex] != nil
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let quiz = quiz else { return }
        print("Next Button tapped")
        guard let selectedIndex = selectedOptionIndices[currentQuestionIndex] else { return }
        selectedOptionIndices[currentQuestionIndex] = selectedIndex
        guard isCurrentQuestionAnswered() else {
            showAlert(
                title: "Select an option",
                message: "Please select an answer before continuing."
            )
            return
        }

        if currentQuestionIndex == quiz.questions.count - 1 {
            showSubmitConfirmation()
        } else {
            currentQuestionIndex += 1
            loadQuestion()
        }
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
    
    private func showSubmitConfirmation() {
        let alert = UIAlertController(
            title: "Submit Test?",
            message: "Your test is being submitted.",
            preferredStyle: .alert
        )
        
        self.onQuizCompleted?()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            let completedQuiz = self.generateCompletedQuiz()
            
            let correctAnswers = completedQuiz.correctCount
            
            let earnedXP = correctAnswers * 10
            
            UserStats.shared.addXP(earnedXP)
            JourneyModel.incrementStatsAfterQuiz()
            
            QuizHistoryManager.shared.save(completedQuiz)
            
            if let roadmap = self.roadmapStatus, roadmap.isStarted == false {
                self.onRoadmapStarted?()
            }

            self.navigateToResults(completedQuiz: completedQuiz)
        })

        present(alert, animated: true)
    }
    
    private func updateSelectionUI(selectedIndex: Int) {
        let buttons = [optionButton1, optionButton2, optionButton3, optionButton4]
        let selectedColor = UIColor(hex: "#1FA5A1")

        for (index, button) in buttons.enumerated() {
            guard let button = button else { continue }
            if index == selectedIndex {
                button.layer.borderWidth = 2
                button.layer.borderColor = selectedColor.cgColor
                button.setTitleColor(selectedColor, for: .normal)
            } else {
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
                button.setTitleColor(.label, for: .normal)
                button.backgroundColor = .systemGray6
            }
        }
    }

    private func resetOptionUI() {
        let buttons = [optionButton1, optionButton2, optionButton3, optionButton4]
        buttons.forEach {
            $0?.backgroundColor = .systemGray6
            $0?.layer.borderColor = UIColor.clear.cgColor
            $0?.layer.borderWidth = 0
            $0?.setTitleColor(.label, for: .normal)
        }
    }
    func calculateScore() -> Int {
        guard let quiz = quiz else { return 0 }

        var correct = 0
        for (index, question) in quiz.questions.enumerated() {
            if selectedOptionIndices[index] == question.correctIndex {
                correct += 1
            }
        }

        return Int(
            (Double(correct) / Double(quiz.questions.count)) * 100
        )
    }

    private func generateCompletedQuiz() -> CompletedQuiz {
        guard let quiz = quiz else {
            fatalError("Quiz missing")
        }
        
        guard let lesson = lesson else {
            fatalError("Lesson missing")
        }

        var results: [QuestionResult] = []

        for (index, question) in quiz.questions.enumerated() {

            let result = QuestionResult(
                questionText: question.question,
                options: question.options,
                userSelectedIndex: selectedOptionIndices[index],
                correctIndex: question.correctIndex
            )
            results.append(result)
        }

        return CompletedQuiz(
            domainTitle: "Data Analytics", 
            moduleTitle: "Module 1: Foundations of Data",
            lessonId: lesson.id,
            lessonName: lesson.name,
            completedAt: Date(),
            questionResults: results
        )
    }

    private func navigateToResults(completedQuiz: CompletedQuiz) {
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "TestResultsVC"
        ) as! TestResultsViewController

        vc.completedQuiz = completedQuiz
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  StartTestModalViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

protocol StartTestModalDelegate: AnyObject {
    func didTapStartTest(quiz: Quiz, lesson: Lesson)
}

class StartTestModalViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var closeButtonContainer: UIView!
    @IBOutlet weak var closeImageView: UIImageView!

    @IBOutlet weak var durationIconBackground: UIView!
    @IBOutlet weak var durationIcon: UIImageView!
    @IBOutlet weak var durationTitleLabel: UILabel!
    @IBOutlet weak var durationSubtitleLabel: UILabel!

    @IBOutlet weak var modalView: UIView!

    @IBOutlet weak var questionsIconBackground: UIView!
    @IBOutlet weak var questionsIcon: UIImageView!
    @IBOutlet weak var questionsTitleLabel: UILabel!
    @IBOutlet weak var questionsSubtitleLabel: UILabel!

    @IBOutlet weak var passingIconBackground: UIView!
    @IBOutlet weak var passingIcon: UIImageView!
    @IBOutlet weak var passingTitleLabel: UILabel!
    @IBOutlet weak var passingSubtitleLabel: UILabel!

    @IBOutlet weak var attemptsIconBackground: UIView!
    @IBOutlet weak var attemptsIcon: UIImageView!
    @IBOutlet weak var attemptsTitleLabel: UILabel!
    @IBOutlet weak var attemptsSubtitleLabel: UILabel!

    @IBOutlet weak var infoLabel: UILabel!

    weak var delegate: StartTestModalDelegate?
    var lesson: Lesson!
    private var quiz: Quiz!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        loadQuiz()
        setupCloseButton()
    }


    private func setupStyling() {
        closeButtonContainer.layer.cornerRadius = closeButtonContainer.frame.height / 2
        closeButtonContainer.backgroundColor = UIColor.systemGray5
        
        [durationIconBackground,
         questionsIconBackground,
         passingIconBackground,
         attemptsIconBackground].forEach { bg in
            bg?.layer.cornerRadius = 14
            bg?.clipsToBounds = true
        }
        startButton.layer.cornerRadius = 22
        infoLabel.textColor = .gray
    }

    private func setupCloseButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        
        let image = UIImage(
            systemName: "xmark",
            withConfiguration: config
        )
        
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.08
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
       
        view.addSubview(button)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
    NSLayoutConstraint.activate([
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        button.widthAnchor.constraint(equalToConstant: 40),
        button.heightAnchor.constraint(equalToConstant: 40)
    ])
    }

    private func loadQuiz() {
        quiz = TestFactory.makeQuiz(
            lessonId: lesson.id,
            lessonName: lesson.name
        )
        durationTitleLabel.text = "Duration"
        durationSubtitleLabel.text = "\(quiz.durationMinutes) mins"

        questionsTitleLabel.text = "Questions"
        questionsSubtitleLabel.text = "\(quiz.questions.count) Multiple Choice"

        passingTitleLabel.text = "Passing Score"
        passingSubtitleLabel.text = "\(quiz.passingPercent)% or higher"

        attemptsTitleLabel.text = "Attempts Remaining"
        attemptsSubtitleLabel.text = "3 of 3"
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @IBAction func startTapped(_ sender: UIButton) {
        print("Start button tapped")
        print("Delegate is nil?", delegate == nil)

        dismiss(animated: true) {
            print("Modal dismissed, calling delegate")
            self.delegate?.didTapStartTest(quiz: self.quiz, lesson: self.lesson)
        }
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


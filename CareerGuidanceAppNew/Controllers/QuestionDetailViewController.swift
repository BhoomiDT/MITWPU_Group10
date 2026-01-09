//
//  QuestionDetailViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 09/01/26.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    var questionResult: QuestionResult!
    var allOptions: [String] = []

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        questionLabel.text = questionResult.questionText

        for (index, option) in allOptions.enumerated() {
            let label = UILabel()
            label.text = option
            label.numberOfLines = 0
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true
            //label.padding(12)

            if index == questionResult.correctIndex {
                label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            } else if index == questionResult.userSelectedIndex {
                label.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            } else {
                label.backgroundColor = .systemGray6
            }

            stackView.addArrangedSubview(label)
        }
    }
}

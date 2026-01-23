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
    var questionIndex: Int = 0
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.title = String("Question \(questionIndex+1)")
    }

    private func setupUI() {
        questionLabel.text = questionResult.questionText

        optionsStackView.arrangedSubviews.forEach {
            optionsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for (index, option) in questionResult.options.enumerated() {
            let label = makeOptionView(
                text: option,
                index: index
            )
            optionsStackView.addArrangedSubview(label)
        }
    }
    
    private func makeOptionView(
        text: String,
        index: Int
    ) -> UIView {

        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.translatesAutoresizingMaskIntoConstraints = false

        container.heightAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true

        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
        ])

        if index == questionResult.correctIndex {
            container.layer.borderColor = UIColor(hex: "1fa5a1").cgColor
        } else if index == questionResult.userSelectedIndex {
            container.layer.borderColor = UIColor(hex: "#E35D5B").cgColor
        } else {
            container.layer.borderColor = UIColor.clear.cgColor
        }

        return container
    }
}

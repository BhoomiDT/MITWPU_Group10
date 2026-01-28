//
//  AnswerStatusCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

class AnswerStatusCell: UITableViewCell {

    @IBOutlet weak var statusBackgroundView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        statusBackgroundView.layer.cornerRadius = 8
        statusBackgroundView.layer.masksToBounds = true
    }
    
    @IBAction func chevronTapped(_ sender: Any) {
    }

    func configure(with result: QuestionResult, index: Int) {
        questionLabel.text = "Question \(index + 1)"
        
        if result.isCorrect {
                statusImageView.image = UIImage(systemName: "checkmark")
                statusImageView.tintColor = UIColor(hex: "1FA5A1")
                statusBackgroundView.backgroundColor =
                    UIColor(hex: "1FA5A1").withAlphaComponent(0.15)
            } else {
                statusImageView.image = UIImage(systemName: "xmark")
                statusImageView.tintColor = .systemRed
                statusBackgroundView.backgroundColor =
                    UIColor.systemRed.withAlphaComponent(0.15)
            }
    }
}

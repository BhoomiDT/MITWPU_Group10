//
//  RoadmapsDetailsCollectionViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class RoadmapsDetailsCollectionViewCell: UITableViewCell {

    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .systemBackground
        
        statusButton.layer.cornerRadius = 14
        statusButton.clipsToBounds = true
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    func configure(with lesson: Lesson) {
        lessonTitleLabel.text = lesson.name
        dueDateLabel.text = "Due \(lesson.dueDate)"
        
        let buttonTitle = lesson.status.rawValue
        statusButton.setTitle(buttonTitle, for: .normal)
        
        if lesson.status == .seeResults {
            statusButton.backgroundColor = UIColor(named: "AppTeal")
            statusButton.setTitleColor(.white, for: .normal)
            statusButton.isHidden = false
        } else if lesson.status == .startTest {
            statusButton.backgroundColor = .systemGray5
            statusButton.setTitleColor(.darkGray, for: .normal)
            statusButton.isHidden = false
        } else {
            // Handle other statuses if necessary
            statusButton.isHidden = true
        }
    }
    @IBAction func statusButtonTapped(_ sender: UIButton) {
        print("Status button tapped!")
    }
}

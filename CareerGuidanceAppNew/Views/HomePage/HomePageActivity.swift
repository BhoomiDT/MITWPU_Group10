//
//  HomePageActivity.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class HomePageActivity: UICollectionViewCell {

    @IBOutlet weak var totalXPLabel: UILabel!
    @IBOutlet weak var scoresTable: UIStackView!
    @IBOutlet weak var dayStreaksLabel: UILabel!
    @IBOutlet weak var badgesLabel: UILabel!
    @IBOutlet weak var activityHeading: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Ensure the stack view lays out views horizontally
            scoresTable.axis = .horizontal
            scoresTable.distribution = .fillEqually
            scoresTable.spacing = 10

            // Cell styling to match the image
            self.contentView.backgroundColor = .white
            self.contentView.layer.cornerRadius = 16
            self.contentView.layer.masksToBounds = true
        }
        
        // Configuration logic
        func configure(with data: ActivityData) {
            activityHeading.text = "Activity"
            totalXPLabel.text = "\(data.xp) ⭐"
            dayStreaksLabel.text = "\(data.streaks) 🔥"
            badgesLabel.text = "\(data.badges) 🛡️"
        }
}

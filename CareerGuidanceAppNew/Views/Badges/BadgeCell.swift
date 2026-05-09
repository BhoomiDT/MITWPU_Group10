//
//  FeaturesCollectionViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class BadgeCell: UICollectionViewCell {

    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with badge: Badge) {

        titleLabel.text = badge.title

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        iconImageView.image = UIImage(systemName: badge.iconName, withConfiguration: config)

        let unlocked = badge.isUnlocked(userXP: UserStats.shared.xp, stats: JourneyModel.shared)

        iconBackgroundView.layoutIfNeeded()
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.height / 2
        iconBackgroundView.layer.masksToBounds = true

        cardBackgroundView.layer.cornerRadius = 12

        if unlocked {
            iconBackgroundView.backgroundColor = UIColor(hex: "#1fa5a1")
            iconImageView.tintColor = .white
            titleLabel.textColor = .label
            cardBackgroundView.alpha = 1.0

        } else {
            iconBackgroundView.backgroundColor = UIColor(hex: "#7C7C7C") // darker gray
            iconImageView.tintColor = .white
            titleLabel.textColor = UIColor(hex: "#3A3A3A")
            cardBackgroundView.alpha = 0.6
        }
    }

}

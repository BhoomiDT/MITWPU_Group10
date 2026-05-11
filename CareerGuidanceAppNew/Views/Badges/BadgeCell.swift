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

        // We use SF Symbols for the grid listing to keep the UI clean and consistent
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        iconImageView.image = UIImage(systemName: badge.systemIconName, withConfiguration: config)
        iconImageView.contentMode = .center

        let unlocked = badge.isUnlocked(userXP: UserStats.shared.xp, stats: JourneyModel.shared)

        iconBackgroundView.layoutIfNeeded()
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.height / 2
        iconBackgroundView.layer.masksToBounds = true
        iconBackgroundView.backgroundColor = unlocked ? UIColor(hex: "#1fa5a1") : UIColor(hex: "#E5E5EA")

        cardBackgroundView.layer.cornerRadius = 16
        cardBackgroundView.layer.cornerCurve = .continuous
        
        applyPremiumEffects(isUnlocked: unlocked)

        if unlocked {
            iconImageView.tintColor = .white
            titleLabel.textColor = .label
            cardBackgroundView.alpha = 1.0
        } else {
            iconImageView.tintColor = .systemGray
            titleLabel.textColor = .secondaryLabel
            cardBackgroundView.alpha = 0.7
        }
    }
    
    private func applyPremiumEffects(isUnlocked: Bool) {
        cardBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cardBackgroundView.layer.shadowOpacity = isUnlocked ? 0.1 : 0.05
        cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardBackgroundView.layer.shadowRadius = 8
        cardBackgroundView.layer.masksToBounds = false
    }

}

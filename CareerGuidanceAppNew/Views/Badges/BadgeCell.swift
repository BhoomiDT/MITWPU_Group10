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
        cardBackgroundView.layer.cornerRadius = 18
        cardBackgroundView.layer.borderWidth = 1
        cardBackgroundView.layer.borderColor = UIColor.cardBorder.cgColor
        cardBackgroundView.backgroundColor = .cardBg
        
        // Remove fixed width constraint to prevent text truncation
        if let widthConstraint = titleLabel.constraints.first(where: { $0.firstAttribute == .width }) {
            titleLabel.removeConstraint(widthConstraint)
        }
        
        // Constrain titleLabel dynamically to fill cell width with padding
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -8)
        ])
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        cardBackgroundView.layer.borderColor = UIColor.cardBorder.cgColor
    }
    
    func configure(with badge: Badge) {
        titleLabel.text = badge.title
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        iconImageView.image = UIImage(systemName: badge.iconName, withConfiguration: config)
        
        let unlocked = badge.isUnlocked(userXP: UserStats.shared.xp, stats: JourneyModel.shared)
        
        iconBackgroundView.layoutIfNeeded()
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.height / 2
        iconBackgroundView.layer.masksToBounds = true
        
        if unlocked {
            iconBackgroundView.backgroundColor = badge.color ?? UIColor(hex: "#1fa5a1")
            iconImageView.tintColor = .white
            titleLabel.textColor = .textPrimary
            cardBackgroundView.alpha = 1.0
        } else {
            let isDark = traitCollection.userInterfaceStyle == .dark
            iconBackgroundView.backgroundColor = isDark ? UIColor(white: 0.22, alpha: 1.0) : UIColor(white: 0.9, alpha: 1.0)
            iconImageView.tintColor = isDark ? UIColor(white: 0.55, alpha: 1.0) : UIColor(white: 0.55, alpha: 1.0)
            titleLabel.textColor = .textSecondary
            cardBackgroundView.alpha = 0.8 // High enough to be clearly visible, low enough to indicate locked state
        }
    }

}

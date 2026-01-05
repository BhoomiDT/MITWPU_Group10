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
            iconImageView.image = UIImage(systemName: badge.iconName)
            iconBackgroundView.backgroundColor = badge.color
            iconImageView.tintColor = .white
            
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            let symbolImage = UIImage(systemName: badge.iconName, withConfiguration: config)
        iconImageView.image = symbolImage
            self.alpha = badge.isUnlocked ? 1.0 : 0.4
            iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.height / 2
            iconBackgroundView.layer.masksToBounds = true
            if let cardView = cardBackgroundView {
                 cardView.layer.cornerRadius = 12
            }
        }

}

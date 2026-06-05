//
//  MilestonesTableViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/12/25.
//

import UIKit

class MilestonesTableViewCell: UITableViewCell {
    
        @IBOutlet weak var containerView: UIView!
        @IBOutlet weak var iconBackgroundView: UIView!
        @IBOutlet weak var iconImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var subtitleLabel: UILabel!

        override func awakeFromNib() {
            super.awakeFromNib()
            containerView.layer.cornerRadius = 16
            containerView.clipsToBounds = true
            selectionStyle = .none
            iconBackgroundView.layer.cornerRadius = 8
            iconBackgroundView.clipsToBounds = true
            
            backgroundColor = .clear
            contentView.backgroundColor = .clear
            containerView.backgroundColor = .cardBg
            titleLabel.textColor = .textPrimary
            subtitleLabel.textColor = .textSecondary
            
            containerView.layer.borderWidth = 1
            updateBorders()
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateBorders()
        }
        
        private func updateBorders() {
            containerView.layer.borderColor = UIColor.cardBorder.cgColor
        }
    override func setSelected(_ selected: Bool, animated: Bool) { }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) { }
    func configure(title: String,
                       subtitle: String,
                       iconName: String,
                       iconColor: UIColor,
                       bgColor: UIColor) {

            titleLabel.text = title
            subtitleLabel.text = subtitle
            iconImageView.image = UIImage(systemName: iconName)
            iconImageView.tintColor = iconColor
            iconBackgroundView.backgroundColor = bgColor
        }
}

//
//  JourneyTableViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class JourneyTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        //cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true

        iconBackgroundView.layer.cornerRadius = 20
        iconBackgroundView.clipsToBounds = true
        
        separatorView.backgroundColor = .separator

        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        iconImageView.preferredSymbolConfiguration = config
    }

    func configure(with item: JourneyItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        iconImageView.image = UIImage(systemName: item.iconName)
        iconImageView.tintColor = item.iconColor
        iconBackgroundView.backgroundColor = item.iconBackgroundColor
    }
    
    func applyCorners(isFirst: Bool, isLast: Bool) {
        let radius: CGFloat = 16

        if isFirst && isLast {
            cardView.layer.cornerRadius = radius
            cardView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else if isFirst {
            cardView.layer.cornerRadius = radius
            cardView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
        } else if isLast {
            cardView.layer.cornerRadius = radius
            cardView.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        } else {
            cardView.layer.cornerRadius = 0
        }
    }
    
    func showSeparator(_ show: Bool) {
        separatorView.isHidden = !show
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  RoadmapsCollectionViewCell.swift
//  CareerGuidance1
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit

class RoadmapsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .cardBg
        self.contentView.layer.borderWidth = 1
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.titleLabel.textColor = .textPrimary
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.descriptionLabel.textColor = .textSecondary
        
        updateBorders()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorders()
    }
    
    private func updateBorders() {
        self.contentView.layer.borderColor = UIColor.cardBorder.cgColor
    }
    
    func configure(image: UIImage, title: String, description: String) {
        illustrationImageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

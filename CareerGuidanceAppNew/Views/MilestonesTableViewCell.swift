//
//  MilestonesTableViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/12/25.
//

import UIKit

class MilestonesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func configure(with milestone: Milestone) {
        
        titleLabel.text = milestone.title
        subtitleLabel.text = milestone.subtitle
        
        iconImageView.image = UIImage(systemName: milestone.iconName)
        
        if let systemColor = UIColor(named: milestone.iconBackgroundColor) {
             iconBackgroundView.backgroundColor = systemColor
             iconImageView.tintColor = .white
        } else {
             iconBackgroundView.backgroundColor = .lightGray
             iconImageView.tintColor = .darkGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        iconBackgroundView.layer.cornerRadius = 8
        iconBackgroundView.clipsToBounds = true
        
        self.selectionStyle = .none
    }
}

//
//  DocCollectionViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class DocCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "DocCell"

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .clear
        
        if let containerView = contentView.subviews.first {
            containerView.backgroundColor = .cardBg
            containerView.layer.cornerRadius = 12
            containerView.layer.borderColor = UIColor.cardBorder.cgColor
            containerView.layer.borderWidth = 1
            containerView.clipsToBounds = true
        }
        
        titleLabel.textColor = .textPrimary
        metaLabel.textColor = .textSecondary
    }

    func configure(title: String, meta: String) {
        titleLabel.text = title
        metaLabel.text = meta
    }
}

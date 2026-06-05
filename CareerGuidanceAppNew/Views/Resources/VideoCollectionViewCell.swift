//
//  VideoCollectionViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "VideoCell"

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var youtubeIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // UI polish
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill

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

    func configure(title: String, meta: String, thumbnail: UIImage?) {
        titleLabel.text = title
        metaLabel.text = meta
        thumbnailImageView.image = thumbnail
    }
}

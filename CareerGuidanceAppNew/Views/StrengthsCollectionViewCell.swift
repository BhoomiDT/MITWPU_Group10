//
//  StrengthsCollectionViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

class StrengthsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    private let separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemGray5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        addSeparator()
    }

    private func setupUI() {
        // Card container styling
        cardContainerView.layer.cornerRadius = 12
        cardContainerView.clipsToBounds = true

        // Icon background rounded
        iconBackgroundView.layer.cornerRadius = 8
        iconBackgroundView.clipsToBounds = true
    }

    private func addSeparator() {
        cardContainerView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 60),
            separatorLine.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -16),
            separatorLine.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor)
        ])
    }

    func configure(with item: StrengthItem, isLast: Bool) {
        titleLabel.text = item.title

        // Hide separator for last row
        separatorLine.isHidden = isLast
    }
}

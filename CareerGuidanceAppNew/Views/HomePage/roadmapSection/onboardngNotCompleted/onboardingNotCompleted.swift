//
//  onboardingNotCompleted.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class onboardingNotCompleted: UICollectionViewCell {

    @IBOutlet weak var progressBarOnboarding: UIProgressView!
    @IBOutlet weak var continuePersonalisationButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        continuePersonalisationButton.tintColor = .appTeal
        progressBarOnboarding.progressTintColor = .appTeal
    }
}

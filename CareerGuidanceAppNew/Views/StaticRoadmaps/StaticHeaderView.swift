//
//  StaticHeaderView.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class StaticHeaderView: UIView {
    
    
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var onStartTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cardContainer.layer.cornerRadius = 16
        cardContainer.clipsToBounds = true
        startButton.layer.cornerRadius = 28
        startButton.clipsToBounds = true
        
        self.backgroundColor = .clear
        cardContainer.backgroundColor = .cardBg
        titleLabel.textColor = .textPrimary
        bodyLabel.textColor = .textSecondary
        
        startButton.backgroundColor = .accentTeal
        startButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
            onStartTapped?()
        }
}

extension UIView {
    func sizedForTableHeader() -> UIView {
        let screenWidth = self.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
        let targetSize = CGSize(width: screenWidth,
                                        height: UIView.layoutFittingCompressedSize.height)
        let height = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        frame.size.height = height
        return self
    }
}

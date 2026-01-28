//
//  viewBadges.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class viewBadges: UICollectionViewCell {
    
    @IBOutlet weak var badgesChevron: UIButton!
    @IBOutlet weak var badgesIcon: UIImageView!
    
    var onChevronTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
        @IBAction func badgesOpen(_ sender: Any) {
            onChevronTapped?()
        }
    }


//
//  showLeaderboard.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class showLeaderboard: UICollectionViewCell {

    @IBOutlet weak var leaderboardIcon: UIImageView!
    @IBOutlet weak var leaderboardChevron: UIButton!
    
    var onChevronTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func leaderboardact(_ sender: Any) {
        onChevronTapped?()
    }
}

//
//  WeaknessCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class WeaknessCell: UITableViewCell {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var weaknessLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text:String){
        imageContainerView.layer.cornerRadius = 8
        imageContainerView.clipsToBounds = true
        weaknessLabel.text = text
    }

}

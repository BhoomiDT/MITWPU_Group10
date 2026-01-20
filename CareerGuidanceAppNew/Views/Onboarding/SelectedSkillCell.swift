//
//  SelectedSkillCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

protocol SelectedSkillCellDelegate: AnyObject {
    func selectedCellDidTapRemove(_ cell: SelectedSkillCell)
}

class SelectedSkillCell: UITableViewCell {
    @IBOutlet weak var leftButton: UIButton!  
    @IBOutlet weak var titleLabel: UILabel!

    weak var delegate: SelectedSkillCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        leftButton.layer.cornerRadius = 18
        leftButton.clipsToBounds = true
        leftButton.adjustsImageWhenHighlighted = true
    }

    @IBAction func leftButtonTapped(_ sender: UIButton) {
        delegate?.selectedCellDidTapRemove(self)
    }
}

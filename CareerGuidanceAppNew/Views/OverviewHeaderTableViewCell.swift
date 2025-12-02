//
//  OverviewHeaderTableViewCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/12/25.
//

import UIKit

class OverviewHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionHeaderLabel: UILabel! // For the text "Description"
    @IBOutlet weak var descriptionContentLabel: UILabel! // For the descriptive paragraph
    @IBOutlet weak var startRoadmapButton: UIButton! // The large teal button
    
    // Optional: Connect a tap handler for the button
    // @IBAction func startButtonTapped(_ sender: UIButton) { ... }

    // MARK: - Configure Function
    
    func configure(description: String) {
        // 1. Set the static header text
        descriptionHeaderLabel.text = "Description"
        
        // 2. Set the dynamic description content
        descriptionContentLabel.text = description
        
        // 3. Set the button text (assuming it's always "Start Roadmap")
        startRoadmapButton.setTitle("Start Roadmap", for: .normal)
        
        // Optional: Apply button styling (if not already done in awakeFromNib)
        startRoadmapButton.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.4, alpha: 1) // Teal color
        startRoadmapButton.setTitleColor(.white, for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Good place for styling like cornerRadius for the button
        startRoadmapButton.layer.cornerRadius = 12
        startRoadmapButton.clipsToBounds = true
    }
}

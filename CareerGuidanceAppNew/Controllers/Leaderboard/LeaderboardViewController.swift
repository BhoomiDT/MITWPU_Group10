//
//  LeaderboardViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var firstPlaceImageView: UIImageView!
    @IBOutlet weak var firstPlaceNameLabel: UILabel!
    @IBOutlet weak var firstPlaceXPLabel: UILabel!
    
    
    @IBOutlet weak var secondPlaceImageView: UIImageView!
    @IBOutlet weak var secondPlaceNameLabel: UILabel!
    @IBOutlet weak var secondPlaceXPLabel: UILabel!
    
    
    @IBOutlet weak var thirdPlaceImageView: UIImageView!
    @IBOutlet weak var thirdPlaceNameLabel: UILabel!
    @IBOutlet weak var thirdPlaceXPLabel: UILabel!
    
    @IBOutlet weak var crownImageView: UIImageView!
    
    var currentData: [LeaderboardEntry] = dailyLeaderboard

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        segmentedControl.selectedSegmentIndex = 0
        
        updateUI()
        configureSegmentedControlAppearance()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        
        let firstPlace = currentData.count > 0 ? currentData[0] : nil
        let secondPlace = currentData.count > 1 ? currentData[1] : nil
        let thirdPlace = currentData.count > 2 ? currentData[2] : nil

        firstPlaceNameLabel.text = firstPlace?.name ?? "N/A"
        firstPlaceXPLabel.text = "\(firstPlace?.xp ?? 0) XP"
        configureProfileImage(imageView: firstPlaceImageView, entry: firstPlace)

        secondPlaceNameLabel.text = secondPlace?.name ?? "N/A"
        secondPlaceXPLabel.text = "\(secondPlace?.xp ?? 0) XP"
        configureProfileImage(imageView: secondPlaceImageView, entry: secondPlace)

        thirdPlaceNameLabel.text = thirdPlace?.name ?? "N/A"
        thirdPlaceXPLabel.text = "\(thirdPlace?.xp ?? 0) XP"
        configureProfileImage(imageView: thirdPlaceImageView, entry: thirdPlace)

        let shouldShowCrown = firstPlace != nil
        crownImageView.isHidden = !shouldShowCrown
        // 5. Reload Table View
        tableView.reloadData()
    }
    
    func configureSegmentedControlAppearance() {
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            
            .foregroundColor: UIColor.white,
            
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]

        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ]

        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        
    }
    
    @IBAction func segmentdControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                currentData = dailyLeaderboard
            case 1:
                currentData = weeklyLeaderboard
            case 2:
                currentData = monthlyLeaderboard
            default:
                break
            }
            
            updateUI()
    }
    
    func configureProfileImage(imageView: UIImageView, entry: LeaderboardEntry?) {
        guard let entry = entry else {
            imageView.image = UIImage(systemName: "person.circle.fill")
            imageView.layer.borderWidth = 0
            return
        }

        if let imageName = entry.imageName, let image = UIImage(named: imageName) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "person.circle.fill")
        }
        imageView.layer.masksToBounds = true
        
        var borderColor: UIColor? = nil
        var borderWidth: CGFloat = 0.0

        switch entry.rank {
        case 1:
            borderColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
            borderWidth = 6.0
        case 2:
            borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
            borderWidth = 5.0
        case 3:
            borderColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
            borderWidth = 4.0
        default:
            borderColor = nil
            borderWidth = 0.0
        }

        if let color = borderColor {
            imageView.layer.borderColor = color.cgColor
            imageView.layer.borderWidth = borderWidth
        } else {
            imageView.layer.borderWidth = 0.0
        }
    }
    
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(0, currentData.count - 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {
            return UITableViewCell()
        }
        let dataIndex = indexPath.row + 3
        
        guard dataIndex < currentData.count else {
            return UITableViewCell()
        }
        
        let entry = currentData[dataIndex]
        
        cell.contentView.backgroundColor = .clear
            cell.nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            cell.xpLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            cell.rankLabel.textColor = .label
            cell.contentView.layer.cornerRadius = 0
        cell.nameLabel.textColor = .label
        cell.xpLabel.textColor = .label
        
        cell.rankLabel.text = "\(entry.rank)"
        if entry.name == "You" {
            cell.contentView.backgroundColor = UIColor(hex: "7FD3CF")
                    cell.contentView.layer.cornerRadius = 12
                    cell.contentView.layer.masksToBounds = true

            cell.nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            cell.xpLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                    cell.rankLabel.textColor = .white
            cell.nameLabel.textColor = .white
            cell.xpLabel.textColor = .white
        }
        cell.nameLabel.text = entry.name
        cell.xpLabel.text = "\(entry.xp) XP"
        
        return cell
    }
}

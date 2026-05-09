//
//  LeaderboardViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import UIKit
import Supabase

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
    
    private var entries: [LeaderboardEntry] = []
    private var currentUserId: UUID?
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        segmentedControl.selectedSegmentIndex = 0
        configureSegmentedControlAppearance()
        
        updateUI() // Clear placeholders immediately
        loadLeaderboardData()
    }
    
    @objc private func refreshData() {
        loadLeaderboardData()
    }
    
    private func loadLeaderboardData() {
        let type: LeaderboardType
        switch segmentedControl.selectedSegmentIndex {
        case 0: type = .daily
        case 1: type = .weekly
        case 2: type = .monthly
        default: type = .allTime
        }
        
        Task {
            do {
                let fetchedEntries = try await LeaderboardService.shared.fetchLeaderboard(for: type)
                let userId = try? await SupabaseManager.shared.client.auth.session.user.id
                await MainActor.run {
                    self.entries = fetchedEntries
                    self.currentUserId = userId
                    self.refreshControl.endRefreshing()
                    self.updateUI()
                }
            } catch {
                print("❌ Failed to fetch leaderboard: \(error)")
                await MainActor.run {
                    self.refreshControl.endRefreshing()
                    self.updateUI() // Still call updateUI to clear placeholders and show empty state
                }
            }
        }
    }
    
    func updateUI() {
        let firstPlace = entries.count > 0 ? entries[0] : nil
        let secondPlace = entries.count > 1 ? entries[1] : nil
        let thirdPlace = entries.count > 2 ? entries[2] : nil

        firstPlaceNameLabel.text = firstPlace?.name ?? "—"
        firstPlaceNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        firstPlaceXPLabel.text = (firstPlace != nil && firstPlace!.xp > 0) ? "\(firstPlace!.xp) XP" : "0 XP"
        firstPlaceXPLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        firstPlaceXPLabel.textColor = (firstPlace?.xp ?? 0 > 0) ? UIColor(hex: "#1fa5a1") : .secondaryLabel
        configureProfileImage(imageView: firstPlaceImageView, entry: firstPlace, rank: 1)

        secondPlaceNameLabel.text = secondPlace?.name ?? "—"
        secondPlaceNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        secondPlaceXPLabel.text = (secondPlace != nil && secondPlace!.xp > 0) ? "\(secondPlace!.xp) XP" : "0 XP"
        secondPlaceXPLabel.font = .systemFont(ofSize: 13, weight: .medium)
        secondPlaceXPLabel.textColor = (secondPlace?.xp ?? 0 > 0) ? UIColor(hex: "#1fa5a1") : .secondaryLabel
        configureProfileImage(imageView: secondPlaceImageView, entry: secondPlace, rank: 2)

        thirdPlaceNameLabel.text = thirdPlace?.name ?? "—"
        thirdPlaceNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        thirdPlaceXPLabel.text = (thirdPlace != nil && thirdPlace!.xp > 0) ? "\(thirdPlace!.xp) XP" : "0 XP"
        thirdPlaceXPLabel.font = .systemFont(ofSize: 13, weight: .medium)
        thirdPlaceXPLabel.textColor = (thirdPlace?.xp ?? 0 > 0) ? UIColor(hex: "#1fa5a1") : .secondaryLabel
        configureProfileImage(imageView: thirdPlaceImageView, entry: thirdPlace, rank: 3)

        // Show crown ONLY if 1st place has > 0 XP
        crownImageView.isHidden = (firstPlace?.xp ?? 0) <= 0
        
        tableView.reloadData()
    }
    
    func configureSegmentedControlAppearance() {
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]

        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]

        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.selectedSegmentTintColor = UIColor(hex: "#1fa5a1")
    }
    
    @IBAction func segmentdControlChanged(_ sender: UISegmentedControl) {
        loadLeaderboardData()
    }
    
    func configureProfileImage(imageView: UIImageView, entry: LeaderboardEntry?, rank: Int) {
        // iOS Native Style: Grey for empty, Teal for active
        let isActive = (entry != nil && entry!.xp > 0)
        
        imageView.backgroundColor = isActive ? UIColor(hex: "#1fa5a1").withAlphaComponent(0.1) : .systemGray6
        imageView.contentMode = .center
        
        let iconName = isActive ? "person.fill" : "person.fill"
        let config = UIImage.SymbolConfiguration(pointSize: rank == 1 ? 40 : 30, weight: .medium)
        imageView.image = UIImage(systemName: iconName, withConfiguration: config)
        imageView.tintColor = isActive ? UIColor(hex: "#1fa5a1") : .systemGray4
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        var borderColor: UIColor? = nil
        var borderWidth: CGFloat = 0.0

        if isActive {
            switch rank {
            case 1:
                borderColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Gold
                borderWidth = 5.0
                imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            case 2:
                borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0) // Silver
                borderWidth = 3.0
                imageView.transform = .identity
            case 3:
                borderColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0) // Bronze
                borderWidth = 3.0
                imageView.transform = .identity
            default:
                break
            }
            imageView.alpha = 1.0
        } else {
            borderColor = .systemGray5
            borderWidth = 1.0
            imageView.transform = .identity
            imageView.alpha = entry == nil ? 0.5 : 1.0
        }

        imageView.layer.borderColor = borderColor?.cgColor
        imageView.layer.borderWidth = borderWidth
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {
            return UITableViewCell()
        }
        let dataIndex = indexPath.row
        
        guard dataIndex < entries.count else {
            return UITableViewCell()
        }
        
        let entry = entries[dataIndex]
        
        // Reset cell styles
        cell.contentView.backgroundColor = .clear
        cell.nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        cell.xpLabel.font = .systemFont(ofSize: 14, weight: .medium)
        cell.xpLabel.textColor = UIColor(hex: "#1fa5a1")
        cell.rankLabel.font = .systemFont(ofSize: 14, weight: .bold)
        cell.rankLabel.textColor = .secondaryLabel
        
        cell.rankLabel.text = "\(entry.rank)"
        cell.nameLabel.text = entry.name
        cell.nameLabel.textColor = .label
        cell.xpLabel.text = "\(entry.xp) XP"
        
        // Highlight current user
        if entry.id == currentUserId {
            cell.contentView.backgroundColor = UIColor(hex: "#1fa5a1").withAlphaComponent(0.1)
            cell.contentView.layer.cornerRadius = 12
            cell.contentView.layer.masksToBounds = true
            
            cell.nameLabel.textColor = UIColor(hex: "#1fa5a1")
            cell.rankLabel.textColor = UIColor(hex: "#1fa5a1")
        } else {
            cell.contentView.backgroundColor = .clear
            cell.contentView.layer.cornerRadius = 0
            cell.contentView.layer.masksToBounds = false
            
            cell.nameLabel.textColor = .label
            cell.rankLabel.textColor = .secondaryLabel
        }
        
        return cell
    }
}

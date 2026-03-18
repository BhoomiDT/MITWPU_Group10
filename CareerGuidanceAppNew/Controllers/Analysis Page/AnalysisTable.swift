//
//  AnalysisTable.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class AnalysisTable: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewAnalysis: UITableView!
    //var recommendedPath: String = "Calculating..."
    // Updated properties
        var recommendations: [(domain: String, confidence: Double)] = []
        var selectedIndex: Int = 0
    var recommendedPath: String {
            return recommendations.indices.contains(selectedIndex) ? recommendations[selectedIndex].domain : "Calculating..."
        }
    var riasecData: [(label: String, score: Float, color: UIColor)] = []
        var interests: [String] = [
            "Problem Solving",
            "Technical Analysis",
            "System Design"
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .appBackground
        tableViewAnalysis.backgroundColor = .appBackground
        tableViewAnalysis.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        tableViewAnalysis.dataSource = self
        tableViewAnalysis.delegate = self
        
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell3", bundle: nil), forCellReuseIdentifier: "cell3")
        
        tableViewAnalysis.separatorStyle = .none
        tableViewAnalysis.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewAnalysis.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return recommendations.count } // Show 3 rows for 3 choices
        else if section == 1 { return riasecData.count }
        else { return interests.count }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        else { return 45 }
        
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {

        guard indexPath.section == 0 else { return }

        let horizontalPadding: CGFloat = 16

        cell.contentView.frame = cell.contentView.frame.inset(
            by: UIEdgeInsets(top: 0,
                             left: horizontalPadding,
                             bottom: 0,
                             right: horizontalPadding)
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            selectedIndex = indexPath.row
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 185
        }
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! AnalysisTableViewCell1
            let item = recommendations[indexPath.row]
            let isSelected = indexPath.row == selectedIndex
            
            // Set text labels
            cell.domainName.text = item.domain.replacingOccurrences(of: "_", with: " ")
            cell.domainDescription.text = String(format: "Confidence Match: %.0f%%", item.confidence * 100)
            
            // FIX THE BUTTON ERROR: Use 'domainExplore' instead of 'btnExplore'
            let btnTitle = isSelected ? "Confirm & Explore Path" : "Select This Path"
            cell.domainExplore.setTitle(btnTitle, for: .normal)
            
            // visual feedback for selection
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .white
            
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 16

            if isSelected {
                cell.contentView.layer.borderWidth = 2
                cell.contentView.layer.borderColor = UIColor(hex: "1fa5a1").cgColor
            } else {
                cell.contentView.layer.borderWidth = 0
            }
            cell.onExploreTapped = { [weak self] in
                if isSelected {
                    // 1. Save data and mark onboarding as truly finished
                    OnboardingManager.shared.recommendedDomain = self?.recommendedPath
                    OnboardingManager.shared.isOnboardingCompleted = true
                    
                    // 2. Set the alert flag for the Home Page
                    OnboardingManager.shared.shouldShowCelebrationAlert = true
                    
                    // 3. Navigate directly to Home
                    let storyboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
                    if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
                        self?.navigationController?.pushViewController(homeVC, animated: true)
                    }
                } else {
                    self?.selectedIndex = indexPath.row
                    tableView.reloadData()
                }
            }
            return cell
        }
        
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! AnalysisTableViewCell2

            let data = riasecData[indexPath.row]

            cell.labelCategory.text = data.label
            cell.progressBar.progress = data.score
            cell.progressBar.progressTintColor = data.color
            cell.labelScore.text = "\(Int(data.score * 100))%"

            let isFirst = indexPath.row == 0
            let isLast  = indexPath.row == riasecData.count - 1

            cell.labelTopConstraint.constant = isFirst ? 16 : 8
            cell.progressBottomConstraint.constant = isLast ? 16 : 8

            applyRoundedCorners(for: cell, indexPath: indexPath, numberOfRows: riasecData.count)
            return cell
        }
        
        if section == 2 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell3",
                for: indexPath
            ) as! AnalysisTableViewCell3

            let interest = interests[indexPath.row]
            cell.interestLabel.text = interest

            let isFirst = indexPath.row == 0
            let isLast  = indexPath.row == interests.count - 1

            cell.labelTopConstraint.constant = isFirst ? 16 : 8
            cell.labelBottomConstraint.constant = isLast ? 16 : 8
            applyRoundedCorners(for: cell,
                                indexPath: indexPath,
                                numberOfRows: interests.count)

            return cell
        }
        
        return UITableViewCell()
    }
    

    
    private func applyRoundedCorners(for cell: UITableViewCell,
                                     indexPath: IndexPath,
                                     numberOfRows: Int) {
        
        if numberOfRows == 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner,
                                         .layerMinXMaxYCorner,
                                         .layerMaxXMaxYCorner]
        }
        else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner]
        }
        else if indexPath.row == numberOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner,
                                         .layerMaxXMaxYCorner]
        }
        else {
            cell.layer.cornerRadius = 0
        }
        
        cell.clipsToBounds = true
    }
    
    
    
//    func tableView(_ tableView: UITableView,
//                    viewForHeaderInSection section: Int) -> UIView? {
//        
//        if section == 0 { return nil }
//        
//        let headerView = UIView()
//        let label = UILabel()
//        
//        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
//        label.textColor = .label
//        
//        if section == 1 { label.text = "RIASEC Analysis" }
//        else { label.text = "Other Analysis" }
//        
//        headerView.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 4),
//            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
//            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
//        ])
//        
//        return headerView
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        
        switch section {
        case 0: label.text = "Top Career Matches"
        case 1: label.text = "Your RIASEC Profile"
        case 2: label.text = "Key Interests"
        default: return nil
        }
        
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0 {
            return 10   // gap between cards
        }

        return section == 2 ? 0 : 16
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
}

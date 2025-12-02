//
//  StaticRoadmapsViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 02/12/25.
//

import UIKit

// Use a simple enum to define the sections for clarity
enum StaticRoadmapSection: Int, CaseIterable {
    case overview = 0
    case milestones = 1
}

class StaticRoadmapViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Data property to hold the roadmap data passed from the initial screen
    var staticRoadmapData: StaticRoadmap!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStaticRoadmapData()
        self.title = staticRoadmapData.title
        
        setupTableView()
    }
    private func loadStaticRoadmapData() {
            // 1. Find the URL for the JSON file (assuming it's named StaticRoadmapData.json)
            guard let url = Bundle.main.url(forResource: "StaticRoadmapData", withExtension: "json") else {
                fatalError("StaticRoadmapData.json not found in the main bundle.")
            }
            
            do {
                // 2. Load the data and decode it
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                // Assign the decoded object to the property
                self.staticRoadmapData = try decoder.decode(StaticRoadmap.self, from: data)
                
            } catch {
                // Log the error and set a fallback/empty data state
                print("Error loading or decoding static roadmap data: \(error)")
                // ⚠️ If data fails, setting a minimal default is critical to prevent a later crash.
                self.staticRoadmapData = StaticRoadmap(
                    title: "Error",
                    description: "Failed to load roadmap data.",
                    imageName: nil,
                    modules: nil,
                    milestones: []
                )
            }
        }
    private func setupTableView() {
        // 1. Register Custom Cells
        tableView.register(UINib(nibName: "OverviewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "overview_cell")
        tableView.register(UINib(nibName: "MilestonesTableViewCell", bundle: nil), forCellReuseIdentifier: "milestone_cell")

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none // No lines between rows
        tableView.backgroundColor = .systemGroupedBackground
    }
}

// MARK: - UITableViewDataSource

extension StaticRoadmapViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // We have two main conceptual sections: Overview and Milestones
        return StaticRoadmapSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch StaticRoadmapSection(rawValue: section) {
        case .overview:
            return 1 // Only one cell for the description and Start button
        case .milestones:
            // Assuming your Roadmap struct has a property for milestones
            return staticRoadmapData.milestones.count // You'll need to define this property
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            switch StaticRoadmapSection(rawValue: indexPath.section) {
            case .overview:
                // Use the custom cell for the description and button
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "overview_cell", for: indexPath) as? OverviewHeaderTableViewCell else { return UITableViewCell() }
                
                // NOTE: The cell must implement configure(description: String)
                cell.configure(description: staticRoadmapData.description)
                return cell
                
            case .milestones:
                // Use the custom cell for the milestones list
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "milestone_cell", for: indexPath) as? MilestonesTableViewCell else { return UITableViewCell() }
                
                let milestone = staticRoadmapData.milestones[indexPath.row]
                
                // NOTE: The cell must implement configure(with: Milestone)
                cell.configure(with: milestone)
                return cell
                
            case .none:
                return UITableViewCell()
            }
        }
    
    // MARK: - Milestones Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Only show the header for the Milestones section
        guard StaticRoadmapSection(rawValue: section) == .milestones else { return nil }
        
        let headerView = UIView()
        let label = UILabel()
        label.text = "Milestones"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Pin the header label to the left with padding
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return StaticRoadmapSection(rawValue: section) == .milestones ? 60 : 0
    }
}

// MARK: - UITableViewDelegate (for interaction)

extension StaticRoadmapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle tapping on a Milestone cell if needed
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  JourneyViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit

class JourneyViewController: UIViewController,UITableViewDelegate{


    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var sections: [JourneySection] = []
    private var fetchingMilestones: [JourneySection] = []
    private var isLoading = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        setupUI()
        setupTableView()
        fetchMilestones()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMilestones()
    }
    
    private func fetchMilestones() {
        Task {
            do {
                let fetchedSections = try await MyJourneyService.shared.fetchCompletedMilestonesHistory()
                DispatchQueue.main.async {
                    self.fetchingMilestones = fetchedSections
                    self.isLoading = false
                    self.updateDisplayedSections()
                }
            } catch {
                print("Error fetching milestones: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.updateDisplayedSections()
                }
            }
        }
    }

  
    private func setupUI() {
        if segmentedControl.numberOfSegments == 2 {
            segmentedControl.setTitle("Milestone History", forSegmentAt: 0)
            segmentedControl.setTitle("Learned Skills", forSegmentAt: 1)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.label
        ], for: .normal)

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .selected)
    }

    private func setupTableView() {
        let nib = UINib(nibName: "JourneyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "JourneyTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 8
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
    }


    private func updateDisplayedSections() {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.sections = self.fetchingMilestones.filter { $0.title == "Milestone History" }
            if self.sections.isEmpty && !isLoading {
                self.sections = [createEmptySection(title: "No Milestones Yet", subtitle: "Complete lessons to unlock milestones", icon: "sparkles")]
            }
        } else {
            self.sections = self.fetchingMilestones.filter { $0.title == "Skills Learned" }
            if self.sections.isEmpty && !isLoading {
                self.sections = [createEmptySection(title: "No Skills Yet", subtitle: "Finish milestones to earn skills", icon: "book.fill")]
            }
        }
        self.tableView.reloadData()
    }

    private func createEmptySection(title: String, subtitle: String, icon: String) -> JourneySection {
        return JourneySection(
            title: title,
            items: [JourneyItem(iconName: icon, iconColor: .systemTeal, iconBackgroundColor: .systemTeal.withAlphaComponent(0.1), title: title, subtitle: subtitle)]
        )
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateDisplayedSections()
    }
}


extension JourneyViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {

        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.text = sections[section].title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel

        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8)
        ])

        return container
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "JourneyTableViewCell",
            for: indexPath
        ) as! JourneyTableViewCell

        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)

        let totalRows = sections[indexPath.section].items.count
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == totalRows - 1

        cell.applyCorners(isFirst: isFirst, isLast: isLast)
        cell.showSeparator(!isLast)
        
        cell.cardBottomConstraint.constant = isLast ? 12 : 0
        
        return cell
    }
}


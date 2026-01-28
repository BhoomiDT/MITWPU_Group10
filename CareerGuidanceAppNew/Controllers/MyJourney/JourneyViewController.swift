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
    
    private var sections: [JourneySection] = JourneyData.milestones

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        setupUI()
        setupTableView()
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


    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sections = JourneyData.milestones
        } else {
            sections = JourneyData.skills
        }
        tableView.reloadData()
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


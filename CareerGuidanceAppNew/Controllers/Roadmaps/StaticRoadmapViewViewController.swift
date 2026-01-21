//
//  StaticRoadmapViewViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class StaticRoadmapViewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var roadmap: Roadmap?
    var milestoneList: [Milestone] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("VIEW DID LOAD WORKED")
        self.title = roadmap?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        loadRoadmapData()
        setupTable()
        setupHeader()
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           if let header = tableView.tableHeaderView {
               header.setNeedsLayout()
               header.layoutIfNeeded()

               let height = header.systemLayoutSizeFitting(
                   CGSize(width: tableView.bounds.width,
                          height: UIView.layoutFittingCompressedSize.height),
                   withHorizontalFittingPriority: .required,
                   verticalFittingPriority: .fittingSizeLevel
               ).height

               if header.frame.height != height {
                   var frame = header.frame
                   frame.size.height = height
                   header.frame = frame
                   tableView.tableHeaderView = header
               }
           }
       }
    
    func setupHeader() {
        let nib = UINib(nibName: "StaticHeaderView", bundle: nil)
        let header = nib.instantiate(withOwner: nil, options: nil).first as! StaticHeaderView

        guard let roadmap = roadmap else { return }

        header.titleLabel.text = roadmap.title
        header.bodyLabel.text = roadmap.description

        header.onStartTapped = { [weak self] in
            self?.openModulesPage()
        }

        tableView.tableHeaderView = header.sizedForTableHeader()
    }
    private func openModulesPage() {
        guard let roadmap = roadmap else { return }

        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)

        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "RoadmapDetailVC"
        ) as? RoadmapDetailViewController else {
            print("RoadmapDetailVC not found")
            return
        }

        vc.selectedRoadmap = roadmap

        navigationController?.pushViewController(vc, animated: true)
    }


    func loadRoadmapData() {
        guard let roadmap = roadmap else {
            print("Roadmap not injected")
            return
        }
        self.milestoneList = roadmap.milestones
    }

    func setupTable() {
        print("setupTable CALLED")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(
            UINib(nibName: "MilestonesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "MilestonesTableViewCell"
        )
    }
}
extension StaticRoadmapViewViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Rows count =", milestoneList.count)
        return milestoneList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Identifier asked:", "MilestonesTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MilestonesTableViewCell", for: indexPath) as! MilestonesTableViewCell
        let item = milestoneList[indexPath.row]

        cell.configure(
            title: item.title,
            subtitle: item.subtitle,
            iconName: item.iconName,
            iconColor: item.iconColor ?? .label,
            bgColor: item.iconBackgroundColor ?? .systemGray5
        )

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMilestone = milestoneList[indexPath.row]
        
        let storyboard = UIStoryboard(name: "ResourcesDescription", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MilestoneDetailVC") as? NewModuleScreen {
            
            detailVC.milestone = selectedMilestone
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

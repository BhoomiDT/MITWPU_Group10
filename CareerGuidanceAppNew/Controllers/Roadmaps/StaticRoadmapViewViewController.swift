//
//  StaticRoadmapViewViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//
//changes
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
    private func updateHeaderUI() {
        guard let header = tableView.tableHeaderView as? StaticHeaderView,
              let roadmap = roadmap else { return }
        
        let hasStarted = roadmap.milestones.flatMap({ $0.lessons }).contains {
            QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
        }
        
        header.startButton.setTitle(hasStarted ? "Continue Learning" : "Start Roadmap", for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRoadmapData()
        updateHeaderUI()
        tableView.reloadData()
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
        guard let header = nib.instantiate(withOwner: nil, options: nil).first as? StaticHeaderView else { return }

        guard let roadmap = roadmap else { return }
        
        let hasStarted = roadmap.milestones.flatMap({ $0.lessons }).contains {
            QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
        }
        
        header.bodyLabel.text = roadmap.description
        header.startButton.setTitle(hasStarted ? "Continue Learning" : "Start Roadmap", for: .normal)

        header.onStartTapped = { [weak self] in
            self?.openCurrentModule()
        }

        tableView.tableHeaderView = header.sizedForTableHeader()
    }
    
    private func openCurrentModule() {
        guard let roadmap = roadmap else { return }
        var targetMilestone: Milestone?
        var targetLessonIndex: Int = 0

        for milestone in roadmap.milestones {
            if let firstUncompletedIndex = milestone.lessons.firstIndex(where: {
                !QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
            }) {
                targetMilestone = milestone
                targetLessonIndex = firstUncompletedIndex
                break
            }
        }

        let milestoneToOpen = targetMilestone ?? roadmap.milestones.first
        
        guard let finalMilestone = milestoneToOpen else { return }
        let storyboard = UIStoryboard(name: "ResourcesDescription", bundle: nil)
        if let modulesVC = storyboard.instantiateViewController(withIdentifier: "MilestoneDetailVC") as? NewModuleScreen {
            
            modulesVC.milestone = finalMilestone
            
            navigationController?.pushViewController(modulesVC, animated: true)
            
        }
    }
    
//    private func getCurrentMilestoneIndex() -> Int {
//        guard let roadmap = roadmap else { return 0 }
//        
//        // Find the index of the first milestone that has at least one uncompleted lesson
//        for (index, milestone) in roadmap.milestones.enumerated() {
//            let isMilestoneComplete = milestone.lessons.allSatisfy {
//                QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
//            }
//            if !isMilestoneComplete {
//                return index
//            }
//        }
//        return roadmap.milestones.count // All completed
//    }
    private func getUnlockedMilestoneIndex() -> Int {
        guard let roadmap = roadmap else { return 0 }
        
        var lastCompletedIndex = -1
        
        for (index, milestone) in roadmap.milestones.enumerated() {
            let isMilestoneComplete = milestone.lessons.allSatisfy {
                QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
            }
            
            if isMilestoneComplete {
                lastCompletedIndex = index
            } else {
                return index
            }
        }
        
        return roadmap.milestones.count - 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MilestonesTableViewCell", for: indexPath) as! MilestonesTableViewCell
        let item = milestoneList[indexPath.row]
        let unlockedIdx = getUnlockedMilestoneIndex()
        
        let isLocked = indexPath.row > unlockedIdx
        _ = milestoneList[indexPath.row].lessons.allSatisfy {
            QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
        }

        var iconToUse = item.iconName
        var iconColor = item.iconColor ?? .label
        var bgColor = item.iconBackgroundColor ?? .systemGray5

        if isLocked {
            iconToUse = "lock.fill"
            iconColor = .systemGray2
            bgColor = .systemGray5
        }

        cell.configure(
            title: item.title,
            subtitle: item.subtitle,
            iconName: iconToUse,
            iconColor: iconColor,
            bgColor: bgColor
        )
        
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unlockedIdx = getUnlockedMilestoneIndex()
        
        if indexPath.row > unlockedIdx {
            let alert = UIAlertController(
                title: "Milestone Locked",
                message: "Complete the previous milestone to unlock this section.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Got it", style: .default))
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            present(alert, animated: true)
            return
        }
        let selectedMilestone = milestoneList[indexPath.row]
        let storyboard = UIStoryboard(name: "ResourcesDescription", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MilestoneDetailVC") as? NewModuleScreen {
            detailVC.milestone = selectedMilestone
            detailVC.parentRoadmap = self.roadmap
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


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

    private var milestoneProgressMap: [UUID: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = roadmap?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .themeBg
        tableView.backgroundColor = .themeBg
        setupTable()
        setupHeader()
        loadRoadmapData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRoadmapData()
    }

    // MARK: - Header

    private func updateHeaderUI() {
        guard let header = tableView.tableHeaderView as? StaticHeaderView else { return }

        let hasStarted = milestoneProgressMap.values.contains(true)
        header.startButton.setTitle(
            hasStarted ? "Continue Learning" : "Start Roadmap",
            for: .normal
        )
    }

    func setupHeader() {
        let nib = UINib(nibName: "StaticHeaderView", bundle: nil)
        guard let header = nib.instantiate(withOwner: nil, options: nil).first as? StaticHeaderView,
              let roadmap = roadmap else { return }

        header.bodyLabel.text = roadmap.description

        let hasStarted = milestoneProgressMap.values.contains(true)
        header.startButton.setTitle(
            hasStarted ? "Continue Learning" : "Start Roadmap",
            for: .normal
        )

        header.onStartTapped = { [weak self] in
            self?.openCurrentModule()
        }

        tableView.tableHeaderView = header.sizedForTableHeader()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let header = tableView.tableHeaderView {
            header.setNeedsLayout()
            header.layoutIfNeeded()

            let height = header.systemLayoutSizeFitting(
                CGSize(
                    width: tableView.bounds.width,
                    height: UIView.layoutFittingCompressedSize.height
                ),
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

    // MARK: - Navigation

    private func openCurrentModule() {
        guard !milestoneList.isEmpty else { return }

        var targetMilestone: Milestone?

        for milestone in milestoneList {
            let completed = milestoneProgressMap[milestone.id] == true
            if !completed {
                targetMilestone = milestone
                break
            }
        }

        let milestoneToOpen = targetMilestone ?? milestoneList.first
        guard let finalMilestone = milestoneToOpen else { return }

        let storyboard = UIStoryboard(name: "ResourcesDescription", bundle: nil)
        if let modulesVC = storyboard.instantiateViewController(
            withIdentifier: "MilestoneDetailVC"
        ) as? NewModuleScreen {
            modulesVC.milestone = finalMilestone
            modulesVC.parentRoadmap = roadmap
            navigationController?.pushViewController(modulesVC, animated: true)
        }
    }

    // MARK: - Data Loading (Supabase)

    func loadRoadmapData() {
        guard let roadmap = roadmap else { return }

        Task {
            do {
                // 1️⃣ Fetch milestones from Supabase (THIS WAS WORKING BEFORE)
                let milestoneDTOs = try await RoadmapService.shared
                    .fetchMilestones(for: roadmap.id)

                var loadedMilestones: [Milestone] = []

                for dto in milestoneDTOs {
                    var milestone = MilestoneMapper.fromDTO(dto)

                    let lessonDTOs = try await RoadmapService.shared
                        .fetchLessons(for: dto.id)

                    milestone.lessons = lessonDTOs.map {
                        LessonMapper.fromDTO($0)
                    }

                    loadedMilestones.append(milestone)
                }

                // 2️⃣ Fetch lesson completion (NEW)
                let allLessonIds = loadedMilestones
                    .flatMap { $0.lessons }
                    .map { $0.id }

                let lessonCompletion = try await RoadmapProgressService.shared
                    .fetchLessonProgress(lessonIds: allLessonIds)

                // 3️⃣ Build milestone progress map
                var progressMap: [UUID: Bool] = [:]

                for milestone in loadedMilestones {
                    let progress = RoadmapProgressService.shared
                        .computeMilestoneProgress(
                            milestone: milestone,
                            lessonCompletion: lessonCompletion
                        )
                    progressMap[milestone.id] = progress.isCompleted
                }

                // 4️⃣ Update UI
                await MainActor.run {
                    self.milestoneList = loadedMilestones
                    self.milestoneProgressMap = progressMap
                    self.tableView.reloadData()
                    self.updateHeaderUI()

                    print("✅ Milestones loaded from Supabase:", loadedMilestones.count)
                }

            } catch {
                print("❌ Failed to load milestones:", error)
            }
        }
    }

    // STATIC DATA VERSION
/*
    func loadRoadmapData() {
        guard let roadmap = roadmap else { return }
        Task {
            do {
                let milestoneDTOs = try await RoadmapService.shared
                    .fetchMilestones(for: roadmap.id)

                var loadedMilestones: [Milestone] = []

                for dto in milestoneDTOs {
                    var milestone = MilestoneMapper.fromDTO(dto)
                    let lessonDTOs = try await RoadmapService.shared
                        .fetchLessons(for: dto.id)

                    milestone.lessons = lessonDTOs.map {
                        LessonMapper.fromDTO($0)
                    }
                    loadedMilestones.append(milestone)
                }

                await MainActor.run {
                    self.milestoneList = loadedMilestones
                    self.tableView.reloadData()
                }

            } catch {
                print("Error loading milestones + lessons:", error)
            }
        }
    }
*/

    // MARK: - Table Setup

    func setupTable() {
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

// MARK: - Table Delegate & DataSource

extension StaticRoadmapViewViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        milestoneList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MilestonesTableViewCell",
            for: indexPath
        ) as! MilestonesTableViewCell

        let milestone = milestoneList[indexPath.row]

        let isPreviousCompleted = indexPath.row == 0
            ? true
            : milestoneProgressMap[milestoneList[indexPath.row - 1].id] == true

        let isLocked = !isPreviousCompleted

        var iconName = milestone.iconName
        var iconColor = milestone.iconColor
        var bgColor = milestone.iconBackgroundColor

        if isLocked {
            iconName = "lock.fill"
            iconColor = .systemGray2
            bgColor = .systemGray5
        }

        cell.configure(
            title: milestone.title,
            subtitle: milestone.subtitle,
            iconName: iconName,
            iconColor: iconColor,
            bgColor: bgColor
        )

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let isPreviousCompleted = indexPath.row == 0
            ? true
            : milestoneProgressMap[milestoneList[indexPath.row - 1].id] == true

        if !isPreviousCompleted {
            let alert = UIAlertController(
                title: "Milestone Locked",
                message: "Complete the previous milestone to unlock this section.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Got it", style: .default))
            present(alert, animated: true)
            return
        }

        let milestone = milestoneList[indexPath.row]
        let storyboard = UIStoryboard(name: "ResourcesDescription", bundle: nil)
        if let vc = storyboard.instantiateViewController(
            withIdentifier: "MilestoneDetailVC"
        ) as? NewModuleScreen {
            vc.milestone = milestone
            vc.parentRoadmap = roadmap
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

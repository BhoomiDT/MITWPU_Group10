//
//  RoadmapsDetailViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

// RoadmapDetailViewController.swift

import UIKit

class RoadmapDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var selectedRoadmap: Roadmap!
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.title = selectedRoadmap.title
            
            setupTableView()
        }
        
        private func setupTableView() {
            let nib = UINib(nibName: "RoadmapsDetailsCollectionViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "roadmapdetail_cell")
            
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            
            tableView.separatorStyle = .singleLine
            
            view.backgroundColor = .systemGroupedBackground
            tableView.backgroundColor = .systemGroupedBackground
        }
    }

    extension RoadmapDetailViewController: UITableViewDataSource {

        func numberOfSections(in tableView: UITableView) -> Int {
            return selectedRoadmap.modules.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return selectedRoadmap.modules[section].lessons.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "roadmapdetail_cell", for: indexPath) as? RoadmapsDetailsCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of LessonTableViewCell.")
            }
            
            let lesson = selectedRoadmap.modules[indexPath.section].lessons[indexPath.row]
            
            cell.configure(with: lesson)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let moduleTitle = selectedRoadmap.modules[section].title
            
            let headerView = UIView()
            let label = UILabel()
            label.text = moduleTitle
            
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .label
            
            headerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
            ])
            
            return headerView
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 60
        }
    }

    extension RoadmapDetailViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let lesson = selectedRoadmap.modules[indexPath.section].lessons[indexPath.row]
            
            print("Tapped on lesson: \(lesson.name). Status: \(lesson.status)")
            
            // TODO: Instantiate and push your Quiz/Test View Controller here
        }
    }

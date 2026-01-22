//
//  TestResultsViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class TestResultsViewController: UIViewController {
    @IBOutlet weak var resultCardView: UIView!
    @IBOutlet weak var progressRingView: CircularProgressView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var completedQuiz: CompletedQuiz!
    var testResult: TestResult!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController!.navigationBar.prefersLargeTitles = true
        self.testResult = makeTestResult(for: completedQuiz.lessonName)
        let backButton = UIButton(type: .system)
           backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
           backButton.tintColor = .label
           backButton.addTarget(
               self,
               action: #selector(backChevronTapped),
               for: .touchUpInside
           )

           let barButton = UIBarButtonItem(customView: backButton)
           navigationItem.leftBarButtonItem = barButton
//        if testResult == nil && lesson?.status == .seeResults {
//            testResult = makeViewOnlyResult()
//        }
//        
//
//        guard let testResult = testResult else {
//            fatalError("TestResult not available")
//        }

//        resultCardView.layer.cornerRadius = 16
//        resultCardView.clipsToBounds = true
//
//        setupResultCard()
//
//        tableContainer.layer.cornerRadius = 16
//        tableContainer.clipsToBounds = true
//
//        tableView.backgroundColor = .clear
//        setupTableView()
        
        guard completedQuiz != nil else {
                fatalError("CompletedQuiz not provided")
            }

            resultCardView.layer.cornerRadius = 16
            resultCardView.clipsToBounds = true

            setupResultCard()

            tableContainer.layer.cornerRadius = 16
            tableContainer.clipsToBounds = true

            tableView.backgroundColor = .clear
            setupTableView()
    }
    @objc func backChevronTapped() {
        guard let navigationController = navigationController else { return }

        for vc in navigationController.viewControllers {
            if vc is NewModuleScreen {
                navigationController.popToViewController(vc, animated: true)
                return
            }
        }

        navigationController.popViewController(animated: true)
    }

    @IBAction func viewYourAnswersTapped(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Answers", bundle: nil)
//        guard let resultsVC = storyboard.instantiateViewController(withIdentifier: "YourAnswersVC") as? YourAnswersViewController else {
//            print("TestResultsViewController not found")
//            return
//        }
//        navigationController?.pushViewController(resultsVC, animated: true)
        let storyboard = UIStoryboard(name: "Answers", bundle: nil)
            let vc = storyboard.instantiateViewController(
                withIdentifier: "YourAnswersVC"
            ) as! YourAnswersViewController

            vc.completedQuiz = completedQuiz
            navigationController?.pushViewController(vc, animated: true)
    }
//    private func makeViewOnlyResult() -> TestResult {
//        return TestResult(
//            score: 80,
//            strengths: [
//                StrengthItem(title: "Conceptual understanding"),
//                StrengthItem(title: "Analytical thinking")
//            ],
//            improvements: [
//                ImprovementItem(title: "Advanced applications"),
//                ImprovementItem(title: "Time efficiency")
//            ],
//            lessonName: lesson?.name ?? ""
//        )
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //progressRingView.setProgress(CGFloat(testResult.score) / 100)
        progressRingView.setProgress(
            CGFloat(completedQuiz.scorePercentage) / 100
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
//    private func setupResultCard(with testResult: TestResult) {
//        percentageLabel.text = "\(testResult.score)%"
//        descriptionLabel.text =
//            "Great work! You’ve shown strong skills in \(testResult.lessonName)"
//    }
    private func setupResultCard() {
        percentageLabel.text = "\(completedQuiz.scorePercentage)%"
        descriptionLabel.text =
            "Great work! You’ve shown strong skills in \(completedQuiz.lessonName)"
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.isScrollEnabled = false
    }
}

extension TestResultsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return section == 0 ? testResult.strengths.count : testResult.improvements.count
            return 3
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "StrengthCell",
                for: indexPath
            ) as! StrengthCell
            
            let radius: CGFloat = 16
            cell.layer.cornerRadius = radius
            cell.layer.masksToBounds = true

            let isFirst = indexPath.row == 0
            let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

            if isFirst && isLast {
                // Only one cell (single-row section)
                cell.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner
                ]
            } else if isFirst {
                // First cell → top corners only
                cell.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner
                ]
            } else if isLast {
                // Last cell → bottom corners only
                cell.layer.maskedCorners = [
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner
                ]
                cell.separatorInset = UIEdgeInsets(
                        top: 0,
                        left: cell.bounds.width,
                        bottom: 0,
                        right: 0
                    )
            } else {
                // Middle cells → no rounding
                cell.layer.cornerRadius = 0
            }
            
            cell.configure(text: testResult.strengths[indexPath.row].title)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "WeaknessCell",
                for: indexPath
            ) as! WeaknessCell
            
            let radius: CGFloat = 16
            cell.layer.cornerRadius = radius
            cell.layer.masksToBounds = true

            let isFirst = indexPath.row == 0
            let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1

            if isFirst && isLast {
                // Only one cell (single-row section)
                cell.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner,
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner
                ]
            } else if isFirst {
                // First cell → top corners only
                cell.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner
                ]
            } else if isLast {
                // Last cell → bottom corners only
                cell.layer.maskedCorners = [
                    .layerMinXMaxYCorner,
                    .layerMaxXMaxYCorner
                ]
                cell.separatorInset = UIEdgeInsets(
                        top: 0,
                        left: cell.bounds.width,
                        bottom: 0,
                        right: 0
                    )
            } else {
                // Middle cells → no rounding
                cell.layer.cornerRadius = 0
            }
            
            cell.configure(text: testResult.improvements[indexPath.row].title)
            return cell
        }
    }
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: "StrengthCell",
//                for: indexPath
//            ) as! StrengthCell
//
//            cell.configure(text: "Good conceptual understanding")
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: "WeaknessCell",
//                for: indexPath
//            ) as! WeaknessCell
//
//            cell.configure(text: "Needs more practice")
//            return cell
//        }
//    }
    
}

extension TestResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                       heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Strengths" : "Weaknesses"
    }

    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = .boldSystemFont(ofSize: 24)
            header.textLabel?.textColor = .black
        }
    }
    
}



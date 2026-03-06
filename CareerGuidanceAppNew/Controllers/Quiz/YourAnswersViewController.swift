//
//  YourAnswersViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

// YourAnswersViewController.swift

import UIKit

class YourAnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var quizAttemptId: UUID?
    var questionResults: [QuestionResult] = []
    let cellReuseIdentifier = "AnswerStatusCell"
    
    @IBOutlet weak var answersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.prefersLargeTitles = true

        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.tableFooterView = UIView()

        Task {
            await loadAnswers()
        }
    }
    
    func loadAnswers() async {

        guard let attemptId = quizAttemptId else { return }

        do {

            let results = try await QuizResultsService.shared.fetchAnswerResults(
                attemptId: attemptId
            )

            DispatchQueue.main.async {
                self.questionResults = results
                self.answersTableView.reloadData()
            }

        } catch {
            print("❌ Failed to load answers:", error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questionResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: "AnswerStatusCell",
                for: indexPath
            ) as! AnswerStatusCell

        let result = questionResults[indexPath.row]
            cell.configure(with: result, index: indexPath.row)
            cell.accessoryType = .disclosureIndicator

            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Answers", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "QuestionDetailVC"
        ) as! QuestionDetailViewController

        let result = questionResults[indexPath.row]
        vc.questionResult = result
        vc.questionIndex = indexPath.row
        vc.allOptions = result.options

        navigationController?.pushViewController(vc, animated: true)
    }
}

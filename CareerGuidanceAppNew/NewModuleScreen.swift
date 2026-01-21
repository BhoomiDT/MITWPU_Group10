import UIKit

class NewModuleScreen: UIViewController, StartTestModalDelegate {
    func didTapStartTest(quiz: Quiz, lesson: Lesson) {
            let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
            
            // Ensure "ActiveQuizViewController" is the Storyboard ID of your test screen
            guard let quizVC = storyboard.instantiateViewController(withIdentifier: "QuestionVC") as? QuizViewController else {
                print("ActiveQuizViewController not found")
                return
            }
            
            quizVC.quiz = quiz
        quizVC.lesson = lesson
            // If you need to pass the lesson object as well:
            // quizVC.lesson = lesson
        quizVC.onQuizCompleted = { [weak self] in
                DispatchQueue.main.async {
                    // This re-triggers cellForItemAt, which re-runs cell.configure()
                    self?.collectionNewModules.reloadData()
                }
            }
            
            self.navigationController?.pushViewController(quizVC, animated: true)
        }
    

    @IBOutlet weak var collectionNewModules: UICollectionView!

    var milestone: Milestone?
    private var lessons: [Lesson] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionNewModules.reloadData() // Refresh UI whenever the screen becomes visible
    }

    private func setupCollectionView() {
        collectionNewModules.delegate = self
        collectionNewModules.dataSource = self

        collectionNewModules.register(
            UINib(nibName: "ModuleCardCellCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ViewCell"
        )

        collectionNewModules.backgroundColor = .systemGroupedBackground
    }

    private func loadData() {
            guard let milestone = milestone else { return }
            
            // Use the Milestone title as the navigation bar title
            self.title = milestone.title
            
            // Load lessons from the milestone
            self.lessons = milestone.lessons
            collectionNewModules.reloadData()
        }
    

}

extension NewModuleScreen: UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return lessons.count
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "ViewCell",
//            for: indexPath
//        ) as! ModuleCardCellCollectionViewCell
//        
//        let lesson = lessons[indexPath.item]
//        cell.configure(with: lesson)
//        
//        cell.onSeeResourcesTapped = { [weak self] in
//            self?.navigateToResources(for: lesson)
//        }
//        cell.onTestTapped = { [weak self] in
//            self?.showStartTestModal(for: lesson) // Reuse the same modal logic
//        }
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ViewCell",
            for: indexPath
        ) as! ModuleCardCellCollectionViewCell
        
        let lesson = lessons[indexPath.item]
        cell.configure(with: lesson)
        
        cell.onSeeResourcesTapped = { [weak self] in
            self?.navigateToResources(for: lesson)
        }

        cell.onTestTapped = { [weak self] in
            // Check if quiz is already completed
            let hasResult = QuizHistoryManager.shared.hasCompletedQuiz(for: lesson.id)
            
            if hasResult {
                // If completed, go straight to results
                self?.openResults(for: lesson)
            } else {
                // If not completed, show the "Start Test" modal
                self?.showStartTestModal(for: lesson)
            }
        }
        
        return cell
    }
    // Add this inside NewModuleScreen or its extension
    private func showStartTestModal(for lesson: Lesson) {
        // Ensure "Roadmaps" matches the actual name of your Storyboard file
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
        
        guard let modalVC = storyboard.instantiateViewController(withIdentifier: "StartTestModalVC") as? StartTestModalViewController else {
            print("Could not find StartTestModalViewController in Storyboard")
            return
        }
        
        modalVC.lesson = lesson
        modalVC.delegate = self // This requires the extension below

        if let sheet = modalVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 550
            }

            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }
        print("Delegate set:", modalVC.delegate != nil)
        present(modalVC, animated: true)
    }
    
    private func navigateToResources(for lesson: Lesson) {
        let storyboard = UIStoryboard(name: "Resources", bundle: nil) // Update to your Storyboard name
        if let resourcesVC = storyboard.instantiateViewController(withIdentifier: "MainResourcesVC") as? MainResourcesViewController {
            
            // Pass the nested lesson data
            resourcesVC.selectedLesson = lesson
            
            self.navigationController?.pushViewController(resourcesVC, animated: true)
        }
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(
                width: 320,
                height: 160
            )
        }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
    }
    func roadmapLessonRowCell(_ cell: ModuleCardCellCollectionViewCell, didTapStatusFor lesson: Lesson) {
//            switch lesson.status {
//            case .seeResults:
//                openResults(for: lesson)
//            case .startTest:
//                openTest(for: lesson)
//            }
        let hasResult =
            QuizHistoryManager.shared.hasCompletedQuiz(for: lesson.id)

        if hasResult {
            openResults(for: lesson)
        } else {
            showStartTestModal(for: lesson)
        }
        }
    
    private func openResults(for lesson: Lesson) {
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)

        guard let resultsVC = storyboard.instantiateViewController(
            withIdentifier: "TestResultsVC"
        ) as? TestResultsViewController else {
            print("TestResultsViewController not found")
            return
        }

        guard let completedQuiz =
            QuizHistoryManager.shared
                .quizzes(for: lesson.id)
                .last else {
            print("No completed quiz found for lesson:", lesson.name)
            return
        }

        resultsVC.completedQuiz = completedQuiz
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
}

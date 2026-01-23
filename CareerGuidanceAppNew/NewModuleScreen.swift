import UIKit

class NewModuleScreen: UIViewController, StartTestModalDelegate {
    func didTapStartTest(quiz: Quiz, lesson: Lesson) {
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
        
        guard let quizVC = storyboard.instantiateViewController(withIdentifier: "QuestionVC") as? QuizViewController else { return }
        
        quizVC.quiz = quiz
        quizVC.lesson = lesson
        
        // Notify the Store that this roadmap has started
        if let roadmapTitle = parentRoadmap?.title {
            // Option A: Start immediately when the test modal is opened
            RoadmapStore.shared.markRoadmapStarted(title: roadmapTitle)
            print("Roadmap \(roadmapTitle) marked as started!")
        }

        quizVC.onQuizCompleted = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionNewModules.reloadData()
            }
        }
        
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let index = initialScrollIndex {
            let indexPath = IndexPath(item: index, section: 0)
            collectionNewModules.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            initialScrollIndex = nil // Clear it so it doesn't jump again
        }
    }
    @IBOutlet weak var collectionNewModules: UICollectionView!
    var initialScrollIndex: Int?
    var milestone: Milestone?
    var parentRoadmap: Roadmap?
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ViewCell",
            for: indexPath
        ) as! ModuleCardCellCollectionViewCell
        
        let lesson = lessons[indexPath.item]
        
        // 1. Find the index of the first incomplete lesson
        let firstIncompleteIndex = lessons.firstIndex(where: {
            !QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
        }) ?? lessons.count
        
        // 2. Determine states
        let isCompleted = QuizHistoryManager.shared.hasCompletedQuiz(for: lesson.id)
        let isCurrentActive = (indexPath.item == firstIncompleteIndex)
        let isLocked = indexPath.item > firstIncompleteIndex
        
        // 3. Configure the cell with these new states
        cell.configure(with: lesson, isCompleted: isCompleted, isCurrentActive: isCurrentActive, isLocked: isLocked)
        
        cell.onSeeResourcesTapped = { [weak self] in
            self?.navigateToResources(for: lesson)
        }

        cell.onTestTapped = { [weak self] in
            if isCompleted {
                self?.openResults(for: lesson)
            } else if isCurrentActive {
                self?.showStartTestModal(for: lesson)
            } else {
                // Handle tapped locked state if necessary (e.g., show an alert)
                print("!!")
                let alert = UIAlertController(
                                title: "Lesson Locked",
                                message: "Please complete the previous lessons and tests to unlock this one.",
                                preferredStyle: .alert
                            )
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            
                            // Optional: Add haptic feedback for a native feel
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.warning)
                            
                self?.present(alert, animated: true)
                print("Done!!!")
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


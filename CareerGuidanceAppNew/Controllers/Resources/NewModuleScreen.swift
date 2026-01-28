//
//  NewModuleScreen.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class NewModuleScreen: UIViewController, StartTestModalDelegate {
    func didTapStartTest(quiz: Quiz, lesson: Lesson) {
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
        
        guard let quizVC = storyboard.instantiateViewController(withIdentifier: "QuestionVC") as? QuizViewController else { return }
        
        quizVC.quiz = quiz
        quizVC.lesson = lesson
        
        if let roadmapTitle = parentRoadmap?.title {
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
        collectionNewModules.reloadData()
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
            
            self.title = milestone.title
            
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
        
        let firstIncompleteIndex = lessons.firstIndex(where: {
            !QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
        }) ?? lessons.count
        
        let isCompleted = QuizHistoryManager.shared.hasCompletedQuiz(for: lesson.id)
        let isCurrentActive = (indexPath.item == firstIncompleteIndex)
        let isLocked = indexPath.item > firstIncompleteIndex
        
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
    
    private func showStartTestModal(for lesson: Lesson) {
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
        
        guard let modalVC = storyboard.instantiateViewController(withIdentifier: "StartTestModalVC") as? StartTestModalViewController else {
            print("Could not find StartTestModalViewController in Storyboard")
            return
        }
        
        modalVC.lesson = lesson
        modalVC.delegate = self
        if let sheet = modalVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 480
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


import UIKit
import SafariServices
import Supabase

class MainResourcesViewController: UIViewController, StartTestModalDelegate {
    func didTapStartTest(quiz: Quiz, lesson: Lesson) {
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
                guard let quizVC = storyboard.instantiateViewController(withIdentifier: "QuestionVC") as? QuizViewController else {
                    print("Quiz screen not found")
                    return
                }
                quizVC.quiz = quiz
                self.navigationController?.pushViewController(quizVC, animated: true)
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedLesson: Lesson?
    private var videos: [VideoDTO] = []
    private var documents: [DocumentDTO] = []
    
    
    enum Section: Int {
            case videos = 0
            case documents = 1
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            title = selectedLesson?.name ?? "Resources"
            setupCollectionView()
            fetchResources()
        }

        private func showStartTestModal(for lesson: Lesson) {
            let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil) // Ensure this matches your Storyboard name
            guard let modalVC = storyboard.instantiateViewController(withIdentifier: "StartTestModalVC") as? StartTestModalViewController else { return }
            
            modalVC.lesson = lesson
            modalVC.delegate = self

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
    
        private func setupCollectionView() {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                      layout.estimatedItemSize = .zero
                      layout.minimumLineSpacing = 12
                      layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
                  }

            collectionView.register(
                UINib(nibName: "VideoCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "VideoCell"
            )

            collectionView.register(
                UINib(nibName: "DocCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "DocCell"
            )

            collectionView.register(
                UINib(nibName: "ResourcesSectionHeaderView", bundle: nil),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "ResourcesSectionHeaderView"
            )
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            let buttonHeight: CGFloat = 48
            let spacing: CGFloat = 16

            collectionView.contentInset.bottom = buttonHeight + spacing
            collectionView.verticalScrollIndicatorInsets.bottom = buttonHeight + spacing
        }
    
    private func fetchResources() {

        guard let lessonId = selectedLesson?.id else { return }

        Task {

            do {

                let fetchedVideos = try await ResourcesService.shared
                    .fetchVideos(lessonId: lessonId)

                let fetchedDocs = try await ResourcesService.shared
                    .fetchDocuments(lessonId: lessonId)

                DispatchQueue.main.async {
                    self.videos = fetchedVideos
                    self.documents = fetchedDocs
                    self.collectionView.reloadData()
                }

            } catch {
                print("Failed to load resources:", error)
            }
        }
    }
    }

    extension MainResourcesViewController: UICollectionViewDataSource {

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if section == Section.videos.rawValue {
                    return videos.count
                } else {
                    return documents.count
                }
            }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                if indexPath.section == Section.videos.rawValue {
                    let video = videos[indexPath.item]

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCollectionViewCell
                    cell.configure(
                        title: video.title,
                        meta: "\(video.duration) · YouTube",
                        thumbnail: UIImage(systemName: "play.rectangle.fill")
                    )
                    return cell
                } else {
                    let doc = documents[indexPath.item]

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocCell", for: indexPath) as! DocCollectionViewCell
                    cell.configure(
                        title: doc.title,
                        meta: "3 mins"
                    )
                    return cell
                }
            }
        }

    extension MainResourcesViewController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.bounds.width - 32

            return CGSize(
                width: width,
                height: indexPath.section == Section.videos.rawValue ? 90 : 70
            )
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            referenceSizeForHeaderInSection section: Int) -> CGSize {

            return CGSize(width: collectionView.bounds.width, height: 44)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {

            return UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        }
    }
extension MainResourcesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString: String?

        if indexPath.section == Section.videos.rawValue {
            urlString = videos[indexPath.item].video_url
        } else {
            urlString = documents[indexPath.item].doc_url
        }

        guard let urlStr = urlString, let url = URL(string: urlStr) else { return }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
}

extension MainResourcesViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ResourcesSectionHeaderView", for: indexPath) as! ResourcesSectionHeaderView
        header.titleLabel.text = indexPath.section == Section.videos.rawValue ? "Visual Tutorials" : "Documentation"
        return header
    }
    }

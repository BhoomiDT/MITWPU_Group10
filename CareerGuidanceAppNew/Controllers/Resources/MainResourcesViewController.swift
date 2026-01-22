import UIKit
import SafariServices

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
    enum Section: Int {
            case videos = 0
            case documents = 1
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            title = selectedLesson?.name ?? "Resources"
            setupCollectionView()
        }

        private func showStartTestModal(for lesson: Lesson) {
            let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil) // Ensure this matches your Storyboard name
            guard let modalVC = storyboard.instantiateViewController(withIdentifier: "StartTestModalVC") as? StartTestModalViewController else { return }
            
            modalVC.lesson = lesson
            modalVC.delegate = self
//            modalVC.modalPresentationStyle = .overFullScreen
//            modalVC.modalTransitionStyle = .crossDissolve
//            
//            present(modalVC, animated: true)
//            
//            modalVC.lesson = lesson
//            modalVC.delegate = self

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
    }

    extension MainResourcesViewController: UICollectionViewDataSource {

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if section == Section.videos.rawValue {
                    return selectedLesson?.videos?.count ?? 0
                } else {
                    return selectedLesson?.documents?.count ?? 0
                }
            }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                if indexPath.section == Section.videos.rawValue {
                    guard let video = selectedLesson?.videos?[indexPath.item] else { return UICollectionViewCell() }

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCollectionViewCell
                    cell.configure(
                        title: video.title,
                        meta: "\(video.duration) · YouTube",
                        thumbnail: UIImage(named: video.thumbnailName)
                    )
                    return cell
                } else {
                    guard let doc = selectedLesson?.documents?[indexPath.item] else { return UICollectionViewCell() }

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocCell", for: indexPath) as! DocCollectionViewCell
                    cell.configure(
                        title: doc.title,
                        meta: doc.readTime
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
            urlString = selectedLesson?.videos?[indexPath.item].videoURL
        } else {
            urlString = selectedLesson?.documents?[indexPath.item].docURL
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

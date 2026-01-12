import UIKit
import SafariServices

class MainResourcesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!


    enum Section: Int {
        case videos = 0
        case documents = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("collectionView:", collectionView as Any)
        title = "Resources"
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                  layout.estimatedItemSize = .zero   
                  layout.minimumLineSpacing = 12
                  layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
              }

        // Video Cell
        collectionView.register(
            UINib(nibName: "VideoCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "VideoCell"
        )

        // Doc Cell
        collectionView.register(
            UINib(nibName: "DocCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "DocCell"
        )

        // Section Header
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

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if section == Section.videos.rawValue {
            return ResourcesDatabase.videos.count
        } else {
            return ResourcesDatabase.documents.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == Section.videos.rawValue {

            let video = ResourcesDatabase.videos[indexPath.item]

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "VideoCell",
                for: indexPath
            ) as! VideoCollectionViewCell

            cell.configure(
                title: video.title,
                meta: "\(video.duration) · YouTube",
                thumbnail: UIImage(named: video.thumbnailName)
            )
            return cell

        } else {

            let doc = ResourcesDatabase.documents[indexPath.item]

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DocCell",
                for: indexPath
            ) as! DocCollectionViewCell

            cell.configure(
                title: doc.title,
                meta: doc.readTime
            )
            return cell
        }
    }
}
extension MainResourcesViewController {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "ResourcesSectionHeaderView",
            for: indexPath
        ) as! ResourcesSectionHeaderView

        header.titleLabel.text =
            indexPath.section == Section.videos.rawValue
            ? "Visual Tutorials"
            : "Documentation"

        return header
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

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let urlString: String

        if indexPath.section == Section.videos.rawValue {
            urlString = ResourcesDatabase.videos[indexPath.item].videoURL
        } else {
            urlString = ResourcesDatabase.documents[indexPath.item].docURL
        }

        guard let url = URL(string: urlString) else { return }

        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.modalPresentationStyle = .pageSheet

        present(safariVC, animated: true)
    }
}

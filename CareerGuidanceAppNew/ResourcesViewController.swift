import UIKit
//enum ResourceSection: Int, CaseIterable {
//    case videos
//    case documents
//
//    var title: String {
//        switch self {
//        case .videos: return "Visual Tutorials"
//        case .documents: return "Documentation"
//        }
//    }
//}


class ResourcesViewController: UIViewController,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var resourcesCollectionView: UICollectionView!

    private let videos = ResourcesDatabase.videos
    private let documents = ResourcesDatabase.documents
    override func viewDidLoad() {
        super.viewDidLoad()

        resourcesCollectionView.dataSource = self
        resourcesCollectionView.delegate = self

        resourcesCollectionView.register(
            UINib(nibName: "VideoCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "VideoCell"
        )

        resourcesCollectionView.register(
            UINib(nibName: "DocCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "DocCell"
        )

        resourcesCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )

        if let layout = resourcesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 44)
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16)
        }
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ResourceSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let type = ResourceSection(rawValue: section)!
        return type == .videos ? videos.count : documents.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let type = ResourceSection(rawValue: indexPath.section)!

        if type == .videos {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "VideoCell",
                for: indexPath
            ) as! VideoCollectionViewCell

            let video = videos[indexPath.item]
            cell.videoTitle.text = video.title
            cell.videoLength.text = "\(video.duration) · YouTube"
            
            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DocCell",
            for: indexPath
        ) as! DocCollectionViewCell

        let doc = documents[indexPath.item]
        cell.titleLabel.text = doc.title
        cell.readTimeLabel.text = doc.readTime
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let type = ResourceSection(rawValue: indexPath.section)!
        let urlString = type == .videos
            ? videos[indexPath.item].videoURL
            : documents[indexPath.item].docURL

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width - 32
        let type = ResourceSection(rawValue: indexPath.section)!

        return CGSize(
            width: width,
            height: type == .videos ? 92 : 72
        )
    }


}

extension ResourcesViewController {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HeaderView",
            for: indexPath
        )

        let label: UILabel
        if let l = header.subviews.first as? UILabel {
            label = l
        } else {
            label = UILabel()
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.frame = CGRect(x: 16, y: 0,
                                  width: collectionView.bounds.width,
                                  height: 44)
            header.addSubview(label)
        }

        label.text = ResourceSection(rawValue: indexPath.section)!.title
        return header
    }

}



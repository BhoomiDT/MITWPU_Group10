//import UIKit
//import SafariServices
//
//enum ResourceSection: Int, CaseIterable {
//    case videos, documents
//    var title: String { self == .videos ? "Visual Tutorials" : "Documentation" }
//}
//// added T
//private var floatingButton: UIButton!
//
//
//class ResourcesCollectionViewController: UICollectionViewController {
//
//
//    private let videos = ResourcesDatabase.videos
//    private let documents = ResourcesDatabase.documents
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //added T
//        setupFloatingButton()
//
//        collectionView.backgroundColor = .systemGroupedBackground
//
//        ["VideoCollectionViewCell": "VideoCell",
//         "DocCollectionViewCell": "DocCell"]
//            .forEach {
//                collectionView.register(
//                    UINib(nibName: $0.key, bundle: nil),
//                    forCellWithReuseIdentifier: $0.value
//                )
//            }
//
//        collectionView.register(
//            UICollectionReusableView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: "HeaderView"
//        )
//
//        collectionView.collectionViewLayout = createLayout()
//    }
//    
//    //added T
//    private func setupFloatingButton() {
//        let button = UIButton(type: .system)
//        button.setTitle("Start Test", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor(hex: "1FA5A1")
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
//        button.layer.cornerRadius = 20
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(button)
//
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            button.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//        button.addTarget(self,
//                         action: #selector(floatingButtonTapped),
//                         for: .touchUpInside)
//
//        floatingButton = button
//    }
//
//
//    
//    // MARK: - Layout Configuration
//    
//    func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { sectionIndex, _ in
//          
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                 heightDimension: .estimated(100))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .estimated(100))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//            let section = NSCollectionLayoutSection(group: group)
//            section.interGroupSpacing = 12
//            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
//
//            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                    heightDimension: .absolute(44))
//            let header = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: headerSize,
//                elementKind: UICollectionView.elementKindSectionHeader,
//                alignment: .top
//            )
//            section.boundarySupplementaryItems = [header]
//            
//            return section
//        }
//    }
//
//    // MARK: - UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        ResourceSection.allCases.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView,
//                                 numberOfItemsInSection section: Int) -> Int {
//        section == 0 ? videos.count : documents.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView,
//                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if indexPath.section == 0 {
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "VideoCell",
//                for: indexPath
//            ) as! VideoCollectionViewCell
//
//            let v = videos[indexPath.item]
//            cell.videoTitle.text = v.title
//            cell.videoLength.text = "\(v.duration) · YouTube"
//            cell.thumbnailImageView.image = UIImage(named: v.thumbnailName)
//            return cell
//        }
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "DocCell",
//            for: indexPath
//        ) as! DocCollectionViewCell
//
//        let d = documents[indexPath.item]
//        cell.titleLabel.text = d.title
//        cell.readTimeLabel.text = d.readTime
//        return cell
//    }
//
//    override func collectionView(_ collectionView: UICollectionView,
//                                 viewForSupplementaryElementOfKind kind: String,
//                                 at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let header = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: "HeaderView",
//            for: indexPath
//        )
//
//        let label = header.viewWithTag(1001) as? UILabel ?? {
//            let l = UILabel(frame: CGRect(x: 16, y: 0,
//                                          width: collectionView.bounds.width,
//                                          height: 44))
//            l.font = .systemFont(ofSize: 20, weight: .bold)
//            l.tag = 1001
//            header.addSubview(l)
//            return l
//        }()
//
//        label.text = ResourceSection(rawValue: indexPath.section)!.title
//        return header
//    }
//
//    // MARK: - UICollectionViewDelegate
//
//    override func collectionView(_ collectionView: UICollectionView,
//                                 didSelectItemAt indexPath: IndexPath) {
//
//        let urlString = indexPath.section == 0
//            ? videos[indexPath.item].videoURL
//            : documents[indexPath.item].docURL
//
//        if let url = URL(string: urlString) {
//            let config = SFSafariViewController.Configuration()
//            config.entersReaderIfAvailable = true
//
//            let safariVC = SFSafariViewController(url: url, configuration: config)
//            present(safariVC, animated: true)
//        }
//    }
//    
//    @objc private func floatingButtonTapped() {
//        print("Tapped")
//    }
//
//}

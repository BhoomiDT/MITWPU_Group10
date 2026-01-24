import UIKit

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allRoadmaps: [Roadmap] {
        RoadmapStore.shared.roadmaps
    }
    
    let personalisedRoadmap = allRoadmapsData.last
    
    var visibleRoadmaps: [Roadmap] {
        guard let personalised = personalisedRoadmap else { return [] }

            let startedRoadmaps = allRoadmaps.filter { roadmap in
                return roadmap.isStarted && roadmap.title != personalised.title
            }

        return [personalised] + startedRoadmaps
    }
    
    var trendingData: [Roadmap] {
            RoadmapStore.shared.roadmaps
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //added T
        print(" Completed sections:",
               OnboardingManager.shared.completedSectionIndexes)
         print(" Onboarding completed:",
               OnboardingManager.shared.isOnboardingCompleted)
        
        collectionView.backgroundColor = .appBackground
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        view.bringSubviewToFront(floatingButton)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        ["StatsCard", "roadmapScrollCollectionViewCell", "homepageMyJourney", "showLeaderboard", "viewBadges", "trendingHomePage", "onboardingNotCompleted"].forEach {
            collectionView.register(UINib(nibName: $0, bundle: nil), forCellWithReuseIdentifier: $0)
        }
        collectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
        collectionView.collectionViewLayout = createLayout()
        
        
        let config = UIImage.SymbolConfiguration(
                pointSize: 18,
                weight: .medium
            )
        let image = UIImage(
                systemName: "headset",
                withConfiguration: config
            )
        floatingButton.setImage(image, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.layer.cornerRadius = floatingButton.bounds.height / 2
    }
    
    @IBAction func aiButtonTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: "AssistantVC") as? AssistantViewController{
            navigationController?.pushViewController(vc, animated: true)
        }
    }


    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 6 }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        if section == 1 {
            return OnboardingManager.shared.isOnboardingCompleted
                ? visibleRoadmaps.count
                : 1
        }


        return section == 5 ? trendingData.count : 1
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsCard", for: indexPath) as! StatsCard
            cell.configure(with: UserStats.shared)
            return cell

        case 1:
            if OnboardingManager.shared.isOnboardingCompleted {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "roadmapScrollCollectionViewCell",
                    for: indexPath
                ) as! roadmapScrollCollectionViewCell
                let data = visibleRoadmaps[indexPath.row]

                cell.configure(
                    title: data.title,
                    subtitle: data.subtitle,
                    percentage: data.percentage,
                    milestone: data.milestones.first?.title ?? "Start Learning"
                )

                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "onboardingNotCompleted",
                    for: indexPath
                ) as! onboardingNotCompleted
                cell.progressBarOnboarding.progress =
                    OnboardingManager.shared.getProgress()
                cell.continuePersonalisationButton.addTarget(
                    self,
                    action: #selector(continueOnboarding),
                    for: .touchUpInside
                )
                return cell
            }

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homepageMyJourney", for: indexPath) as! homepageMyJourney
            let currentStats = JourneyModel.shared
            cell.configure(
                    days: "\(currentStats.days)",
                    quizzes: "\(currentStats.quizzes)",
                    quests: "\(currentStats.quests)"
                )
            cell.onChevronTapped = {
                let vc = UIStoryboard(name: "MyJourney", bundle: nil).instantiateViewController(withIdentifier: "MyJourneySbId")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showLeaderboard", for: indexPath) as! showLeaderboard
            cell.onChevronTapped = {
                let vc = UIStoryboard(name: "Leaderboard", bundle: nil).instantiateViewController(withIdentifier: "leaderboardScreen")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewBadges", for: indexPath) as! viewBadges
            cell.onChevronTapped = {
                let vc = UIStoryboard(name: "Badges", bundle: nil).instantiateViewController(withIdentifier: "badgesMainPage")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingHomePage", for: indexPath) as! trendingHomePage
            cell.configure(item: trendingData[indexPath.row])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedRoadmap: Roadmap
        
        if indexPath.section == 1 {
            guard OnboardingManager.shared.isOnboardingCompleted else { return }
            selectedRoadmap = visibleRoadmaps[indexPath.row]
        } else if indexPath.section == 5 {
            selectedRoadmap = trendingData[indexPath.row]
        } else {
            return
        }
        
        // Perform Navigation
        let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "StaticVC"
        ) as? StaticRoadmapViewViewController else {
            print("StaticRoadmapVC not found in Roadmaps.storyboard")
            return
        }
        
        vc.roadmap = selectedRoadmap
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func continueOnboarding() {
        if let nextVC = OnboardingManager.shared.getNextViewController() { navigationController?.pushViewController(nextVC, animated: true) }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeaderView",
            for: indexPath
        ) as! HomeSectionHeaderView

        header.titleLabel.text = [
            "",
            OnboardingManager.shared.isOnboardingCompleted ?
            "My Roadmaps" : "Finish Setup",
            "My Journey",
            "",
            "",
            "Trending Domains"
        ][indexPath.section]

        header.viewAllButton.isHidden = indexPath.section != 5


        header.onViewAllTapped = { [weak self] in
            guard let self else { return }

            if indexPath.section == 5 {
                let storyboard = UIStoryboard(name: "Roadmaps", bundle: nil)
                let vc = storyboard.instantiateViewController(
                    withIdentifier: "TrendingVC"
                )
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        return header
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { index, env in
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            let isDone = OnboardingManager.shared.isOnboardingCompleted

            if index == 1 {

                let roadmapCount = OnboardingManager.shared.isOnboardingCompleted
                    ? self.visibleRoadmaps.count
                    : 1

                let shouldFillWidth = roadmapCount == 1

                return self.layoutSection(
                    height: isDone ? 165 : 170,
                    scroll: shouldFillWidth ? .none : .groupPaging,
                    header: header,
                    width: shouldFillWidth ? 1.0 : 0.85
                )
            }

            
            if index == 5 {
                let s = self.layoutSection(height: 220, scroll: .continuousGroupLeadingBoundary, header: header, width: 0.85)
                if isDone { s.visibleItemsInvalidationHandler = { items, off, env in
                    items.forEach { item in
                        let scale = max(1.0 - (abs((item.frame.midX - off.x) - env.container.contentSize.width / 2.0) / env.container.contentSize.width), 0.95)
                        item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    }
                }}
                return s
            }
            let h = [110, 0, 275, 60, 60][index]
            return self.layoutSection(height: CGFloat(h), header: index == 2 ? header : nil, top: (index == 3 || index == 4) ? 12 : 0)
        }
    }
    
    func layoutSection(height: CGFloat, scroll: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none, header: NSCollectionLayoutBoundarySupplementaryItem? = nil, width: CGFloat = 1.0, top: CGFloat = 0) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        if scroll != .none { item.contentInsets.trailing = 15 }
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(width), heightDimension: .absolute(height)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scroll
        section.contentInsets = .init(top: top, leading: 16, bottom: scroll != .none ? 20 : 10, trailing: 16)
        if let h = header { section.boundarySupplementaryItems = [h] }
        return section
    }
}

class HomeSectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    let viewAllButton = UIButton(type: .system)
    var onViewAllTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .boldSystemFont(ofSize: 20)
        viewAllButton.setTitle("View All", for: .normal)
        viewAllButton.tintColor = .appTeal
        viewAllButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        [titleLabel, viewAllButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false; addSubview($0) }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor), titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewAllButton.trailingAnchor.constraint(equalTo: trailingAnchor), viewAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    @objc func tap() { onViewAllTapped?()}
      
}

//
//  HomePageViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit
import Supabase

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allRoadmaps: [Roadmap] {
        RoadmapStore.shared.roadmaps
    }
    
//    let personalisedRoadmap = allRoadmapsData.last
//
//    var visibleRoadmaps: [Roadmap] {
//        guard let personalised = personalisedRoadmap else { return [] }
//
//            let startedRoadmaps = allRoadmaps.filter { roadmap in
//                return roadmap.isStarted && roadmap.title != personalised.title
//            }
//
//        return [personalised] + startedRoadmaps
//    }
    // In HomePageViewController.swift

//    var personalisedRoadmap: Roadmap? {
//        // 1. Get the domain name suggested by the ML model
//        guard let recommendedTitle = OnboardingManager.shared.recommendedDomain else {
//            // Fallback 1: If no recommendation yet, just show the last roadmap
//            return allRoadmaps.last
//        }
//
//        // 2. Try to find the actual roadmap object that matches that title
//        // We search the store to see if we have "Web Development", "AI", etc.
//        let matchedRoadmap = allRoadmaps.first { $0.title.lowercased() == recommendedTitle.lowercased() }
//
//        // 3. Define which base data to use (the match OR the fallback last one)
//        let baseRoadmap = matchedRoadmap ?? allRoadmaps.last
//
//        guard let roadmapToUse = baseRoadmap else { return nil }
//
//        // 4. CALCULATE DYNAMIC PERCENTAGE (Specific to the chosen roadmap)
//        let allLessons = roadmapToUse.milestones.flatMap { $0.lessons }
//        let totalQuizzes = allLessons.count
//        let completedCount = allLessons.filter {
//            OnboardingManager.shared.completedLessonIds.contains($0.id)
//        }.count
//
//        let calculatedPercentage = totalQuizzes > 0 ? (completedCount * 100) / totalQuizzes : 0
//
//        // 5. Return the final roadmap
//        // Note: We keep the recommendedTitle as the title even if we fall back
//        // to the last roadmap's milestones/content.
//        return Roadmap(
//            title: recommendedTitle,
//            subtitle: roadmapToUse.subtitle,
//            description: roadmapToUse.description,
//            imageName: roadmapToUse.imageName,
//            percentage: calculatedPercentage,
//            milestones: roadmapToUse.milestones,
//            isStarted: roadmapToUse.isStarted
//        )
//    }
//
//    var visibleRoadmaps: [Roadmap] {
//        guard let personalised = personalisedRoadmap else { return [] }
//
//        // Filter out whichever roadmap is currently being shown as "Personalised"
//        let otherStartedRoadmaps = allRoadmaps.filter { roadmap in
//            return roadmap.isStarted && roadmap.title != personalised.title
//        }
//
//        return [personalised] + otherStartedRoadmaps
//    }
    var personalisedRoadmap: Roadmap? {
        guard let recommendedTitle = OnboardingManager.shared.recommendedDomain else {
            return allRoadmaps.last.map { getDynamicRoadmap(for: $0) }
        }
        
        let matched = allRoadmaps.first { $0.title.lowercased() == recommendedTitle.lowercased() }
        let base = matched ?? allRoadmaps.last
        
        guard let roadmapToUse = base else { return nil }
        
        // We wrap this in our helper, but override the title with the ML recommendation
        let dynamic = getDynamicRoadmap(for: roadmapToUse)
        return Roadmap(
            id: dynamic.id,
            title: recommendedTitle, // Keep the dynamic ML title
            subtitle: dynamic.subtitle,
            description: dynamic.description,
            imageName: dynamic.imageName,
            percentage: dynamic.percentage,
            milestones: dynamic.milestones,
            isStarted: dynamic.isStarted
        )
    }

    var visibleRoadmaps: [Roadmap] {
        guard let personalised = personalisedRoadmap else { return [] }

        // Map through other started roadmaps and calculate progress for EACH
        let otherStartedRoadmaps = allRoadmaps
            .filter { $0.isStarted && $0.title != personalised.title }
            .map { getDynamicRoadmap(for: $0) }

        return [personalised] + otherStartedRoadmaps
    }
    
    private func getDynamicRoadmap(for baseRoadmap: Roadmap) -> Roadmap {
        let allLessons = baseRoadmap.milestones.flatMap { $0.lessons }
        let totalQuizzes = allLessons.count
        let completedCount = allLessons.filter {
            QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
        }.count
        
        let calculatedPercentage = totalQuizzes > 0 ? (completedCount * 100) / totalQuizzes : 0
        print("Completed lessons:", QuizHistoryManager.shared.completedLessonIds)
        return Roadmap(
            id: baseRoadmap.id,
            title: baseRoadmap.title,
            subtitle: baseRoadmap.subtitle,
            description: baseRoadmap.description,
            imageName: baseRoadmap.imageName,
            percentage: calculatedPercentage, // The dynamic value
            milestones: baseRoadmap.milestones,
            isStarted: baseRoadmap.isStarted
        )
    }
    
    private func loadRoadmapsFromSupabase() async {

        do {
            let response = try await SupabaseManager.shared.client
                .from("roadmaps")
                .select()
                .execute()

            let dtos = try JSONDecoder().decode([RoadmapDTO].self, from: response.data)

            var mapped: [Roadmap] = []
            for dto in dtos {
                var roadmap = RoadmapMapper.fromDTO(dto)
                do {
                    roadmap.milestones = try await RoadmapService.shared.fetchMilestonesWithLessons(for: roadmap.id)
                } catch {
                    print("Failed to fetch nested milestones for \(roadmap.title):", error)
                }
                mapped.append(roadmap)
            }

            RoadmapStore.shared.setRoadmaps(mapped)
            print("FETCHED FROM SUPABASE");

        } catch {
            print("❌ Supabase roadmap load failed:", error)
        }
    }
    func hydrateQuizHistory() async {

        do {

            let attempts = try await QuizHistoryService.shared
                .fetchCompletedQuizzes()

            QuizHistoryManager.shared.hydrate(attempts)

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }

        } catch {
            print("Quiz history hydration failed:", error)
        }
    }
//    var trendingData: [Roadmap] {
//            RoadmapStore.shared.roadmaps
//        }
    var trendingData: [Roadmap] {
        RoadmapStore.shared.roadmaps.map { getDynamicRoadmap(for: $0) }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(" Completed sections:",
               OnboardingManager.shared.completedSectionIndexes)
         print(" Onboarding completed:",
               OnboardingManager.shared.isOnboardingCompleted)
        self.extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .themeBg
        collectionView.backgroundColor = .themeBg
        collectionView.contentInset.bottom = 100
        collectionView.contentInsetAdjustmentBehavior = .always

        setupNavigationBarAppearance()
        
        Task {
            await ProfileService.shared.syncRemoteToLocal()
            await UserStats.shared.syncFromSupabase()
            await hydrateQuizHistory()
            
            DispatchQueue.main.async {
                // Refresh greeting after name is fetched
                self.title = self.getDynamicGreeting()
                self.navigationController?.navigationBar.setNeedsLayout()
                self.navigationController?.navigationBar.layoutIfNeeded()
                self.collectionView.reloadData()
            }
        }
        view.bringSubviewToFront(floatingButton)
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarBg
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .accentTeal
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.title = getDynamicGreeting()
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupNavigationBarAppearance()
        }
    }
    
    private func getDynamicGreeting() -> String {
        if let name = ProfileService.shared.cachedName, !name.isEmpty {
            let firstName = name.components(separatedBy: " ").first ?? name
            return "Hello \(firstName)"
        }
        return "Hello"
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        view.sendSubviewToBack(collectionView)
        
        Task {
            await loadRoadmapsFromSupabase()
            collectionView.reloadData()
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesBackButton = true
        collectionView.delegate = self
        collectionView.dataSource = self
        UserStats.shared.updateStreak()
        ["StatsCard", "roadmapScrollCollectionViewCell", "homepageMyJourney", "showLeaderboard", "viewBadges", "trendingHomePage", "onboardingNotCompleted"].forEach {
            collectionView.register(UINib(nibName: $0, bundle: nil), forCellWithReuseIdentifier: $0)
        }
        collectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")
        collectionView.collectionViewLayout = createLayout()
        
        
        let config = UIImage.SymbolConfiguration(
                pointSize: 22,
                weight: .bold
            )
        let image = UIImage(
                systemName: "sparkles",
                withConfiguration: config
            )
        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OnboardingManager.shared.shouldShowCelebrationAlert {
            let domain = OnboardingManager.shared.recommendedDomain?.replacingOccurrences(of: "_", with: " ") ?? "New Explorer"
            
            let popup = AchievementPopupView(domain: domain)
            
            popup.onDismiss = { [weak self] in
                // Logic after dismissing
                UserStats.shared.xp += 100
                self?.collectionView.reloadSections(IndexSet(integer: 0))
                
                // Haptic Feedback
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
            
            popup.show(on: self.view)
            
            // Reset flag
            OnboardingManager.shared.shouldShowCelebrationAlert = false
        }
    }
    private func showCelebrationAlert() {
        let domain = OnboardingManager.shared.recommendedDomain?.replacingOccurrences(of: "_", with: " ") ?? "your domain"
        
        let alert = UIAlertController(
            title: "Congratulations!",
            message: "You've successfully completed your onboarding!\n\n🏆 Earned: 100 XP\n🏅 Badge: Path Finder\n🚀 Path: \(domain)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: { _ in
            // Optional: Trigger a haptic feedback or confetti here
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }))
        
        self.present(alert, animated: true)
        
        // Update the UI/Stats immediately
        UserStats.shared.xp += 100
        // If you have a refresh function for your stats card, call it here:
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFloatingOrb()
    }
    
    private func setupFloatingOrb() {
        floatingButton.layer.cornerRadius = floatingButton.bounds.height / 2
        floatingButton.backgroundColor = .clear
        
        // Remove existing gradient to prevent overlap
        floatingButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradient = CAGradientLayer()
        gradient.frame = floatingButton.bounds
        gradient.colors = [UIColor(hex: "1fa5a1").cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = floatingButton.bounds.height / 2
        floatingButton.layer.insertSublayer(gradient, at: 0)
        
        floatingButton.layer.shadowColor = UIColor(hex: "1fa5a1").cgColor
        floatingButton.layer.shadowRadius = 15
        floatingButton.layer.shadowOpacity = 0.8
        floatingButton.layer.shadowOffset = .zero
        
        if floatingButton.layer.animation(forKey: "pulse") == nil {
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.duration = 1.5
            pulse.fromValue = 0.95
            pulse.toValue = 1.05
            pulse.autoreverses = true
            pulse.repeatCount = .infinity
            floatingButton.layer.add(pulse, forKey: "pulse")
        }
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
                    milestone: data.currentMilestoneTitle
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
                    days: String(JourneyModel.shared.days),
                    quizzes: String(JourneyModel.shared.quizzes),
                    quests: String(JourneyModel.shared.quests)
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

                let section = self.layoutSection(
                    height: isDone ? 170 : 180,
                    scroll: shouldFillWidth ? .none : .groupPaging,
                    header: header,
                    width: shouldFillWidth ? 1.0 : 0.85
                )
                
                // 3D Cover Flow Effect for Section 1
                if !shouldFillWidth {
                    section.visibleItemsInvalidationHandler = { items, off, env in
                        items.forEach { item in
                            guard item.representedElementCategory == .cell else { return }
                            let distanceFromCenter = abs((item.frame.midX - off.x) - env.container.contentSize.width / 2.0)
                            let minScale: CGFloat = 0.85
                            let scale = max(1.0 - (distanceFromCenter / env.container.contentSize.width) * 0.3, minScale)
                            item.transform = CGAffineTransform(scaleX: scale, y: scale)
                            item.alpha = scale // Fade out slightly as it shrinks
                        }
                    }
                }
                
                return section
            }

            
            if index == 5 {
                let section = self.layoutSection(height: 240, scroll: .continuousGroupLeadingBoundary, header: header, width: 0.85)
                
                // Stronger 3D Cover Flow Effect for Trending
                section.visibleItemsInvalidationHandler = { items, off, env in
                    items.forEach { item in
                        guard item.representedElementCategory == .cell else { return }
                        let distanceFromCenter = abs((item.frame.midX - off.x) - env.container.contentSize.width / 2.0)
                        let minScale: CGFloat = 0.80
                        let scale = max(1.0 - (distanceFromCenter / env.container.contentSize.width) * 0.35, minScale)
                        item.transform = CGAffineTransform(scaleX: scale, y: scale)
                        item.alpha = scale
                    }
                }
                
                return section
            }
            // heights: idx 0=Stats, 2=Journey, 3=Leaderboard, 4=Badges
            let h = [136, 0, 250, 68, 68][index]
            return self.layoutSection(height: CGFloat(h), header: index == 2 ? header : nil, top: (index == 3 || index == 4) ? 8 : 0)
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
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .textPrimary
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
extension Roadmap {
    var currentMilestoneTitle: String {
        // Find the first milestone where NOT all lessons are completed
        let activeMilestone = milestones.first { milestone in
            let completedCount = milestone.lessons.filter {
                QuizHistoryManager.shared.hasCompletedQuiz(for: $0.id)
            }.count
            
            return completedCount < milestone.lessons.count
        }
        
        // If all milestones are done, return "Completed!",
        // otherwise return the title of the active one.
        return activeMilestone?.title ?? "Course Completed!"
    }
}

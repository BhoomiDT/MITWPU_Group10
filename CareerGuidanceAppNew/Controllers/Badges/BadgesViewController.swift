//
//  BadgesViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class BadgesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "BadgeCell", bundle: nil)
        badgesCollectionView.register(nib, forCellWithReuseIdentifier: "BadgeCell")
        badgesCollectionView.dataSource = self
        badgesCollectionView.delegate = self
        
        // Reparent collection view to view and pin it to safe area so it scrolls natively
        if let stackView = badgesCollectionView.superview,
           let contentView = stackView.superview,
           let scrollView = contentView.superview as? UIScrollView {
            
            badgesCollectionView.removeFromSuperview()
            view.addSubview(badgesCollectionView)
            
            badgesCollectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                badgesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                badgesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                badgesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                badgesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            scrollView.removeFromSuperview()
        }
        
        // Disable the hardcoded height constraint
        collectionViewHeightConstraint.isActive = false
        
        // Configure collection view flow layout programmatically to bypass storyboard self-sizing issue
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = .zero
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 16
        badgesCollectionView.collectionViewLayout = flowLayout
        
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .themeBg
        badgesCollectionView.backgroundColor = .themeBg
        
        setupNavigationBarAppearance()
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
        self.title = "Badges"
        
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func setupNavigationItem() {
        navigationItem.hidesBackButton = true
        
        let backBtn = UIButton(type: .custom)
        backBtn.backgroundColor = UIColor.textPrimary.withAlphaComponent(0.08)
        backBtn.layer.cornerRadius = 18
        backBtn.tintColor = .textPrimary
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        backBtn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupNavigationBarAppearance()
            setupNavigationItem()
        }
    }
    
    func presentBadgeModal(with badge: Badge) {

        let storyboard = UIStoryboard(name: "Badges", bundle: nil)
        guard let modalVC = storyboard.instantiateViewController(withIdentifier: "BadgeUnlockedModalVC") as? BadgeUnlockedModalViewController else {
            print("Fatal Error: Storyboard ID 'BadgeUnlockedModalVC' check failed.")
            return
        }
        
        let screenTitle: String
        let unlocked = badge.isUnlocked(userXP: UserStats.shared.xp, stats: JourneyModel.shared)

        if unlocked {
            screenTitle = "Unlocked New Badge"
        } else {
            screenTitle = "Not Yet Unlocked"
        }
        modalVC.badge = badge
        modalVC.modalTitleString = screenTitle
 
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        present(modalVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let selectedBadge = dataSource[indexPath.section].badges[indexPath.row]
        presentBadgeModal(with: selectedBadge)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let headerHeight: CGFloat = 60
//        return CGSize(width: collectionView.bounds.width, height: headerHeight)
//    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeaderView else {
//                fatalError("Could not dequeue SectionHeaderView")
//            }
//            header.titleLabel.text = dataSource[indexPath.section].title
//            return header
//        }
//        return UICollectionReusableView()
//    }
    
    let dataSource = allBadgeSections
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].badges.count
    }

    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath) as? BadgeCell else {
            fatalError("Could not dequeue BadgeCell")
        }
        let section = dataSource[indexPath.section]
        let badge = section.badges[indexPath.row]
        cell.configure(with: badge)
        
        return cell
    }
}

extension BadgesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let leftRightInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let totalSpacing = (flowLayout.minimumInteritemSpacing * (columns - 1)) + leftRightInsets
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        let widthPerItem = floor(availableWidth / columns)
        return CGSize(width: widthPerItem, height: widthPerItem * 1.15)
    }
}

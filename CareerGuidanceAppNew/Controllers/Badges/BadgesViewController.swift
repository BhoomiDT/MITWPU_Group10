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
        badgesCollectionView.layoutIfNeeded()
        let contentHeight = badgesCollectionView.contentSize.height
        collectionViewHeightConstraint.constant = contentHeight
        view.layoutIfNeeded()
        collectionViewHeightConstraint.constant = badgesCollectionView.contentSize.height
    }
    func presentBadgeModal(with badge: Badge) {

        let storyboard = UIStoryboard(name: "Badges", bundle: nil)
        guard let modalVC = storyboard.instantiateViewController(withIdentifier: "BadgeUnlockedModalVC") as? BadgeUnlockedModalViewController else {
            print("Fatal Error: Storyboard ID 'BadgeUnlockedModalVC' check failed.")
            return
        }
        
        let screenTitle: String
            if badge.isUnlocked {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerHeight: CGFloat = 60
        return CGSize(width: collectionView.bounds.width, height: headerHeight)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeaderView else {
                fatalError("Could not dequeue SectionHeaderView")
            }
            header.titleLabel.text = dataSource[indexPath.section].title
            return header
        }
        return UICollectionReusableView()
    }
    
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
        let totalSpacing = flowLayout.minimumInteritemSpacing * (columns - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        let widthPerItem = floor(availableWidth / columns)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

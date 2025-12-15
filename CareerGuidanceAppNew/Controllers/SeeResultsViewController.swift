//
//  SeeResultsViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 10/12/25.
//
import UIKit

class SeeResultsViewController: UIViewController {
    
    var lesson: Lesson?
    var result: TestResult?

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
            super.viewDidLoad()

            if let lesson = lesson {
                result = makeTestResult(for: lesson.name)
            }

            collectionView.dataSource = self
            collectionView.delegate = self

            collectionView.register(
                UINib(nibName: "ScoreCardCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "scorecard_cell"
            )

            collectionView.register(
                UINib(nibName: "StrengthsCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "strengths_cell"
            )

            collectionView.collectionViewLayout = createLayout()
        }
    }

private func createLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, env in

        // SCORE SECTION
        if sectionIndex == 0 {
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(320)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }

        // STRENGTHS SECTION
        if sectionIndex == 1 {
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
            return section
        }

        return nil
    }
}

extension SeeResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        if section == 1 { return result?.strengths.count ?? 0 }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "scorecard_cell",
                for: indexPath
            ) as! ScoreCardCollectionViewCell

            cell.configure(with: result!)
            return cell
        }

        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "strengths_cell",
                for: indexPath
            ) as! StrengthsCollectionViewCell

            let item = result!.strengths[indexPath.item]
            let isLast = indexPath.item == result!.strengths.count - 1

            cell.configure(with: item, isLast: isLast)
            return cell
        }

        return UICollectionViewCell()
    }
}

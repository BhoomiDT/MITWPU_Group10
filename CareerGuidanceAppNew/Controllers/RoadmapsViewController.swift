//
//  RoadmapsViewController.swift
//  CareerGuidance1
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit

class RoadmapsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var roadmapsData: [Roadmap] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRoadmapData()
        registerRoadmapCells()
        setupSearchBar()
    }
    
    private func loadRoadmapData() {
            guard let url = Bundle.main.url(forResource: "RoadmapData", withExtension: "json") else {
                fatalError("RoadmapData.json not found in the main bundle.")
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.roadmapsData = try decoder.decode([Roadmap].self, from: data)
                
            } catch {
                print("Error loading or decoding roadmap data: \(error)")
            }
        }
    
    private func registerRoadmapCells() {
        let nib = UINib(nibName: "RoadmapsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "roadmap_cell")

        collectionView.dataSource = self
        collectionView.delegate = self
        
        //collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.setCollectionViewLayout(generateRoadmapLayout(), animated: false)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for roadmaps..."
        searchBar.backgroundImage = UIImage()
    }
    
    private func generateRoadmapLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 16
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension RoadmapsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roadmapsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roadmap_cell", for: indexPath) as? RoadmapsCollectionViewCell else {
            fatalError("Could not dequeue RoadmapCardCell")
        }

        let roadmap = roadmapsData[indexPath.row]
        
        cell.configure(image: UIImage(named: roadmap.imageName) ?? UIImage(),
                       title: roadmap.title,
                       description: roadmap.description)

        return cell
    }
}

extension RoadmapsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRoadmap = roadmapsData[indexPath.row]
        print("Tapped on roadmap: \(selectedRoadmap.title)")
        guard let detailVC = storyboard?.instantiateViewController(
                    withIdentifier: "RoadmapDetailVC"
                ) as? RoadmapDetailViewController else {
                    print("Error: Could not instantiate RoadmapDetailVC")
                    return
                }

                detailVC.selectedRoadmap = selectedRoadmap

                navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RoadmapsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Implement filtering logic here.
        // 1. Filter the roadmapsData array based on searchText
        // 2. Reload the collection view: collectionView.reloadData()
        print("Search text changed: \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

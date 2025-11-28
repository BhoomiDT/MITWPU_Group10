//
//  RoadmapsViewController.swift
//  CareerGuidance1
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit

// MARK: - 1. Roadmap Data Model
// Define a simple struct for the data you will display
struct Roadmap {
    let title: String
    let description: String
    let imageName: String // Used to load the image asset
}

class RoadmapsViewController: UIViewController {

    // --- Outlets: Connect these from the Storyboard/XIB ---
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // --- Data Source ---
    let roadmapsData: [Roadmap] = [
        Roadmap(title: "Data Analysis", description: "Mastering the collection, transformation, and modeling of data to draw conclusions and drive decisions.", imageName: "data-analytics-role"),
        Roadmap(title: "AI & Machine Learning", description: "Developing algorithms that allow machines to learn from data and make predictions or decisions.", imageName: "aiml-role"),
        Roadmap(title: "Cybersecurity", description: "Protecting computer systems and networks from information disclosure, theft of or damage to their hardware, software, or electronic data.", imageName: "cyber-security-role"),
        Roadmap(title: "Mobile App Development", description: "Building applications for mobile devices such as smartphones and tablets across platforms like iOS and Android.", imageName: "appdev-role 1"),
    ]

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
    }
    
    // MARK: - Setup Methods

    private func setupNavigationBar() {
        // Sets the title that appears in the Navigation Bar
        self.title = "Roadmaps"
        
        // Enables the large title style common in iOS apps
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Optional: Set a specific color for the background behind the large title
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupCollectionView() {
        // Register the custom cell created from the XIB file
        let nib = UINib(nibName: "RoadmapsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "roadmap_cell")

        // Assign data source and delegate protocols
        collectionView.dataSource = self
        collectionView.delegate = self // Required for optional handling like selection
        
        // Set the background color to match the view's background for seamless look
        collectionView.backgroundColor = .systemGroupedBackground
        
        // Apply the custom compositional layout
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for roadmaps..."
        // Ensure the search bar background is clean
        searchBar.backgroundImage = UIImage()
    }

    // MARK: - Compositional Layout Definition

    private func createLayout() -> UICollectionViewLayout {
        // 1. Item Definition: Full width, Dynamic Height based on content (estimated: 250)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 2. Group Definition: A single column, full width
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 3. Section Definition
        let section = NSCollectionLayoutSection(group: group)
        
        // Add vertical spacing between the cards (matching the design)
        section.interGroupSpacing = 16
        
        // Add padding around the entire column of cards
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource

extension RoadmapsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Use the count of your data array
        return roadmapsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roadmap_cell", for: indexPath) as? RoadmapsCollectionViewCell else {
            fatalError("Could not dequeue RoadmapCardCell")
        }

        let roadmap = roadmapsData[indexPath.row]
        
        // Pass data to the cell's configure method
        // Note: You must have image assets named "data_analysis_icon", "ai_ml_icon", etc., in your Assets.xcassets
        cell.configure(image: UIImage(named: roadmap.imageName) ?? UIImage(),
                       title: roadmap.title,
                       description: roadmap.description)

        return cell
    }
}

// MARK: - UICollectionViewDelegate (Optional)

extension RoadmapsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell tap/selection here, e.g., navigate to the roadmap detail screen
        print("Tapped on roadmap: \(roadmapsData[indexPath.row].title)")
        // Example navigation:
        // let detailVC = RoadmapDetailViewController()
        // detailVC.roadmap = roadmapsData[indexPath.row]
        // navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate (Optional)

extension RoadmapsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Implement filtering logic here.
        // 1. Filter the roadmapsData array based on searchText
        // 2. Reload the collection view: collectionView.reloadData()
        print("Search text changed: \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
}

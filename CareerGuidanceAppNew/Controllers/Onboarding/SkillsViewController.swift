//
//  SkillsViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

class SkillsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var continueButtonTapped: UIBarButtonItem!
    private var selected: [String] = [
        "Cloud Computing",
        "Flask",
    ]

    private var suggestions: [String] = [
        "Adobe XD", "Agile", "Angular", "ASP.NET", "AWS", "Azure",
        "C", "CPP", "Django", "Docker",
        "Figma", "Flutter", "GCP", "Go", "GraphQL",
        "Hadoop", "HTML", "CSS", "Java", "JavaScript", "Jenkins",
        "Jetpack Compose", "Kotlin", "Kubernetes", "Linux",
        "NLP", "Node.js", "NumPy", "Pandas", "Python", "PyTorch",
        "React", "React Native", "REST API", "Ruby", "Rust",
        "Scikit-Learn", "Scrum", "Spark", "Spring Boot", "SQL",
        "Swift", "SwiftUI", "System Design", "Tableau", "TensorFlow",
        "Terraform", "TypeScript", "Unit Testing", "Vue"
    ]

    private var filteredSuggestions: [String] = []
    private var isFiltering: Bool {
        let t = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return !t.isEmpty
    }

    private let sheetView = UIView()
    private let bottomCurveView = UIView()
    private let bottomContinueBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear // will be over sheetView
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 10
        }

        setupCustomUI()
    }
    
    private func setupCustomUI() {
        view.backgroundColor = .themeBg
        navigationItem.rightBarButtonItem = nil // Hide old bar button
        
        // Sheet View
        sheetView.backgroundColor = .cardBg
        sheetView.layer.cornerRadius = 40
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.insertSubview(sheetView, belowSubview: tableView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        // Custom search container styling
        searchContainerView.backgroundColor = UIColor.progressTrackBg
        searchContainerView.layer.cornerRadius = 24
        searchContainerView.layer.masksToBounds = true
        sheetView.addSubview(searchContainerView)
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .textPrimary
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.pin(to: searchContainerView)
        
        // Bottom Curve
        bottomCurveView.backgroundColor = .themeBg
        bottomCurveView.layer.cornerRadius = 40
        bottomCurveView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(bottomCurveView)
        bottomCurveView.translatesAutoresizingMaskIntoConstraints = false
        
        // Bottom Continue Button
        bottomContinueBtn.setTitleColor(.white, for: .normal)
        bottomContinueBtn.setTitle("Continue", for: .normal)
        bottomContinueBtn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bottomContinueBtn.addTarget(self, action: #selector(bottomContinueTapped), for: .touchUpInside)
        bottomCurveView.addSubview(bottomContinueBtn)
        bottomContinueBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Move tableView to front so it shows on top of sheetView
        view.bringSubviewToFront(tableView)
        view.bringSubviewToFront(bottomCurveView)
        
        // Setup Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchContainerView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 20),
            searchContainerView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 48),
            
            // Adjust tableView constraints to fit inside sheetView
            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomCurveView.topAnchor),
            
            bottomCurveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCurveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCurveView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomCurveView.heightAnchor.constraint(equalToConstant: 100),
            
            bottomContinueBtn.centerXAnchor.constraint(equalTo: bottomCurveView.centerXAnchor),
            bottomContinueBtn.topAnchor.constraint(equalTo: bottomCurveView.topAnchor, constant: 20),
            bottomContinueBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Animate Sheet
        sheetView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        tableView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.sheetView.transform = .identity
            self.tableView.alpha = 1
        }
    }
    
    @objc private func bottomContinueTapped() {
        continueButtonTapped(UIButton())
    }
    
    private func suggestionsArray() -> [String] {
        return isFiltering ? filteredSuggestions : suggestions
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
       
            OnboardingManager.shared.saveTechSkills(self.selected)

            if let nextIntro = storyboard?.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
                nextIntro.sectionIndex = 2
                navigationController?.pushViewController(nextIntro, animated: true)
            }
        
    }
    
    private func indexPath(forSelectedCell cell: SelectedSkillCell) -> IndexPath? {
        if let text = cell.titleLabel.text, let row = selected.firstIndex(of: text) {
            return IndexPath(row: row, section: 0)
        }
        return nil
    }

    private func indexPath(forSuggestionCell cell: SuggestionSkillCell) -> IndexPath? {
        let source = suggestionsArray()
        if let text = cell.titleLabel.text, let row = source.firstIndex(of: text) {
            return IndexPath(row: row, section: 1)
        }
        return nil
    }
}

extension SkillsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? selected.count : suggestionsArray().count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Selected" : "Suggestions"
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedSkillCell", for: indexPath) as? SelectedSkillCell else {
                fatalError("SelectedSkillCell not registered or wrong class")
            }
            cell.titleLabel.text = selected[indexPath.row]
            cell.titleLabel.textColor = .textPrimary
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.backgroundColor = .cardBg
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionSkillCell", for: indexPath) as? SuggestionSkillCell else {
                fatalError("SuggestionSkillCell not registered or wrong class")
            }
            cell.titleLabel.text = suggestionsArray()[indexPath.row]
            cell.titleLabel.textColor = .textPrimary
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.backgroundColor = .cardBg
            return cell
        }
    }
}

extension SkillsViewController: SelectedSkillCellDelegate, SuggestionSkillCellDelegate {
    func selectedCellDidTapRemove(_ cell: SelectedSkillCell) {
        guard let ip = indexPath(forSelectedCell: cell) else { return }
        let item = selected.remove(at: ip.row)
        suggestions.insert(item, at: 0)

//        tableView.beginUpdates()
//        tableView.deleteRows(at: [ip], with: .automatic)
//        tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
//        tableView.endUpdates()
//
//        if isFiltering { filterSuggestions(with: searchBar.text ?? "") }
        
        if isFiltering {
                if let text = searchBar.text {
                    filterSuggestions(with: text)
                }
                tableView.reloadData()
            } else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [ip], with: .automatic)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
    }

    func suggestionCellDidTapAdd(_ cell: SuggestionSkillCell) {
        guard let ip = indexPath(forSuggestionCell: cell) else { return }
        let item = suggestionsArray()[ip.row]
        if let realIndex = suggestions.firstIndex(of: item) {
            suggestions.remove(at: realIndex)
        }
        selected.insert(item, at: 0)

//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//        tableView.deleteRows(at: [ip], with: .automatic)
//        tableView.endUpdates()
//
//        if isFiltering { filterSuggestions(with: searchBar.text ?? "") }
        if isFiltering {
            if let text = searchBar.text {
                filterSuggestions(with: text)
            }
            tableView.reloadData()
        } else {
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            tableView.deleteRows(at: [ip], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension SkillsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = selected[indexPath.row]
            selected.remove(at: indexPath.row)
            suggestions.insert(item, at: 0)
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
//            tableView.endUpdates()
//            if isFiltering { filterSuggestions(with: searchBar.text ?? "") }
            
            if isFiltering {
                        if let text = searchBar.text {
                            filterSuggestions(with: text)
                        }
                        tableView.reloadData()
                    } else {
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                        tableView.endUpdates()
                    }
        } else {
            let item = suggestionsArray()[indexPath.row]
            if let real = suggestions.firstIndex(of: item) { suggestions.remove(at: real) }
            selected.insert(item, at: 0)
            
            if isFiltering {
                        if let text = searchBar.text {
                            filterSuggestions(with: text)
                        }
                        tableView.reloadData()
                    } else {
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                        tableView.endUpdates()
                    }
//            tableView.beginUpdates()
//            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.endUpdates()
            
            //if isFiltering { filterSuggestions(with: searchBar.text ?? "") }
            
        }
    }
}

extension SkillsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSuggestions(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredSuggestions.removeAll()
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }

    private func filterSuggestions(with text: String) {
        let q = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty {
            filteredSuggestions = []
        } else {
            filteredSuggestions = suggestions.filter { $0.lowercased().contains(q) }
        }
        tableView.reloadData()
        //tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
}

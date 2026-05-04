//
//  ProfileViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 09/01/26.
//

import UIKit
internal import Auth
import Supabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewForIcon: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private let sections = ProfileSection.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCloseButton()
        fetchUserData()
    }
    
    private func fetchUserData() {
        Task {
            if let user = try? await SupabaseManager.shared.client.auth.session.user {
                DispatchQueue.main.async {
                    self.emailLabel.text = user.email
                    // If we have a profile with a name, use it
                    Task {
                        if let profile = try? await ProfileService.shared.fetchProfile() {
                            DispatchQueue.main.async {
                                if let name = profile.full_name {
                                    self.nameLabel.text = name
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func setupCloseButton() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
            
            let image = UIImage(
                systemName: "xmark",
                withConfiguration: config
            )
            
            button.setImage(image, for: .normal)
            button.tintColor = .label
            button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
            button.layer.cornerRadius = 20
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.08
            button.layer.shadowRadius = 6
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
           
            view.addSubview(button)
            button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        nameLabel.text = "User"
        emailLabel.text = "Loading..."
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        profileImage.image = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = title
        cell.textLabel?.font = .systemFont(ofSize: 16)
        
        if title == "Log Out" {
            cell.textLabel?.textColor = .systemRed
            cell.backgroundColor = .white
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
        } else {
            cell.textLabel?.textColor = .label
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if sections[indexPath.section].options[indexPath.row] == "Log Out" {
            Task {
                do {
                    try await AuthService.shared.signOut()
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let initialVC = storyboard.instantiateInitialViewController() else { return }
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = initialVC
                            window.makeKeyAndVisible()
                            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        }
                    }
                } catch {
                    showAppAlert(title: "Error", message: "Failed to sign out: \(error.localizedDescription)")
                }
            }
        }
    }
}

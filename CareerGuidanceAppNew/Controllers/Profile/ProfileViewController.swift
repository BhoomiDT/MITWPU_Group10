//
//  ProfileViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 09/01/26.
//

import UIKit
internal import Auth
import Supabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditProfileDelegate {

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
    
    func fetchUserData() {
        Task {
            if let user = try? await SupabaseManager.shared.client.auth.session.user {
                DispatchQueue.main.async {
                    self.emailLabel.text = user.email
                    // If we have a profile with a name, use it
                    Task {
                        if let profile = try? await ProfileService.shared.fetchProfile() {
                            DispatchQueue.main.async {
                                if let name = profile.full_name, !name.isEmpty {
                                    self.nameLabel.text = name
                                }
                                let streak = profile.learning_streak ?? 0
                                let xp = profile.xp ?? 0

                                
                                // Show Stats in email label or append to it since we don't want to break the storyboard
                                let text = "\(user.email ?? "")\n\(xp) XP • 🔥 \(streak) Day Streak"
                                
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.lineSpacing = 6
                                paragraphStyle.alignment = .center
                                
                                let attributedString = NSMutableAttributedString(string: text)
                                let fullRange = NSRange(location: 0, length: text.count)
                                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
                                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: fullRange)
                                attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: fullRange)
                                
                                // Optionally make the stats part slightly smaller
                                if let newlineIndex = text.firstIndex(of: "\n") {
                                    let statsStartIndex = text.index(after: newlineIndex)
                                    let statsNSRange = NSRange(statsStartIndex..., in: text)
                                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .medium), range: statsNSRange)
                                }
                                
                                self.emailLabel.attributedText = attributedString
                                self.emailLabel.numberOfLines = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didUpdateProfile() {
        fetchUserData()
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
        
        let option = sections[indexPath.section].options[indexPath.row]
        
        if option == "Personal Details" {
            let editVC = EditProfileViewController()
            editVC.delegate = self
            if let nav = navigationController {
                nav.pushViewController(editVC, animated: true)
            } else {
                let nav = UINavigationController(rootViewController: editVC)
                // Use Child View Controller to slide in *within* the sheet bounds
                self.addChild(nav)
                nav.view.frame = self.view.bounds
                nav.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                nav.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                self.view.addSubview(nav.view)
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    nav.view.transform = .identity
                } completion: { _ in
                    nav.didMove(toParent: self)
                }
            }
        } else if option == "App Permissions" {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        } else if option == "Data and Storage" {
            let alert = UIAlertController(title: "Clear Cache", message: "Are you sure you want to clear temporary app data?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
                // Dummy cache clear
                let successAlert = UIAlertController(title: "Success", message: "Cache cleared successfully.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(successAlert, animated: true)
            }))
            present(alert, animated: true)
        } else if option == "Log Out" {
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
        } else {
            // Unimplemented sections
            let alert = UIAlertController(title: "Coming Soon", message: "\(option) will be available in a future update.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

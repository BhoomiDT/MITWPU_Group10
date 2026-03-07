//
//  CelebrationViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 07/03/26.
//


import UIKit

class CelebrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Update user stats as soon as they reach this screen
        UserStats.shared.xp += 100
        // Logic to add badge to your Badge store could go here
    }

    private func setupUI() {
        view.backgroundColor = .appBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let badgeImage = UIImageView(image: UIImage(systemName: "medal.fill"))
        badgeImage.tintColor = .systemYellow
        badgeImage.contentMode = .scaleAspectFit
        badgeImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "Congratulations!"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "You've completed the onboarding!\nYou earned 100 XP and the 'Pathfinder' badge."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Go to Home", for: .normal)
        continueButton.backgroundColor = .appTeal
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 12
        continueButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        continueButton.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
        continueButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(stackView)
        stackView.addArrangedSubview(badgeImage)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.setCustomSpacing(40, after: subtitleLabel)
        stackView.addArrangedSubview(continueButton)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc func goToHome() {
        let storyboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
            // Use setViewControllers to clear the onboarding stack from memory
            navigationController?.setViewControllers([homeVC], animated: true)
        }
    }
}
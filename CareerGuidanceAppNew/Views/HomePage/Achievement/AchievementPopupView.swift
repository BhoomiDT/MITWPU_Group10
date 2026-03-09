//
//  AchievementPopupView.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 07/03/26.
//


import UIKit

class AchievementPopupView: UIView {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let badgeNameLabel = UILabel()
    private let domainLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let badgeImageView = UIImageView()
    var onDismiss: (() -> Void)?

    init(domain: String) {
        super.init(frame: .zero)
        setupUI(domain: domain)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI(domain: String) {
        // Background Dim
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Container Card
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // 1. Congrats Title (Big & Bold)
        titleLabel.text = "Unlocked!"
        titleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        titleLabel.textAlignment = .center
        
        // 2. Center Badge Emoji
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .bold)
        badgeImageView.image = UIImage(systemName: "map.circle.fill", withConfiguration: config)
        badgeImageView.tintColor = UIColor(hex: "#1fa5a1") // Gives it that "Gold Medal" look
        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 3. Badge Name
        badgeNameLabel.text = "PATHFINDER"
        badgeNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        badgeNameLabel.textColor = UIColor(hex: "#EF9026")
        badgeNameLabel.textAlignment = .center
        
        // 4. Domain Name
        domainLabel.text = domain
        domainLabel.font = .systemFont(ofSize: 14, weight: .medium)
        domainLabel.textColor = .secondaryLabel
        domainLabel.textAlignment = .center
        
        // 5. Button
        actionButton.setTitle("AWESOME", for: .normal)
        actionButton.backgroundColor = .appTeal
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 24
        actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        actionButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, badgeImageView, badgeNameLabel, domainLabel, actionButton])
        stack.axis = .vertical
        stack.spacing = 15
        stack.setCustomSpacing(30, after: domainLabel) // Gap before button
        stack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func dismissTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.onDismiss?()
            self.removeFromSuperview()
        }
    }
    
    func show(on view: UIView) {
        self.frame = view.bounds
        self.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.containerView.transform = .identity
        })
    }
}

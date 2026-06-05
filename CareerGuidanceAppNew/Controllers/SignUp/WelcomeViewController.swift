//
//  WelcomeViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    private let logoContainer = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let featuresStack = UIStackView()
    
    private let loginButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    
    private let dividerStack = UIStackView()
    private let leftDivider = UIView()
    private let dividerLabel = UILabel()
    private let rightDivider = UIView()
    
    private let socialStack = UIStackView()
    private let googleButton = UIButton(type: .system)
    private let appleButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setupHierarchy()
        setupConstraints()
        setupActions()
    }
    
    private func setupTheme() {
        view.backgroundColor = .systemBackground
        
        // Disable scroll bar scroll indicators
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1. Branding (Logo + App Name)
        logoContainer.backgroundColor = UIColor.appTealLightBackground
        logoContainer.layer.cornerRadius = 24
        logoContainer.clipsToBounds = true
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .semibold)
        logoImageView.image = UIImage(systemName: "graduationcap.fill", withConfiguration: config)
        logoImageView.tintColor = .appTeal
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.addSubview(logoImageView)
        
        titleLabel.text = "Career Guidance"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. Features Stack
        featuresStack.axis = .vertical
        featuresStack.spacing = 24
        featuresStack.translatesAutoresizingMaskIntoConstraints = false
        
        addFeatureRow(
            iconName: "map.circle.fill",
            title: "Find Your Perfect Career Path",
            description: "Discover your strengths and get a personalized path to reach your goals."
        )
        
        addFeatureRow(
            iconName: "brain.head.profile",
            title: "Understand Your True Potential",
            description: "Take smart tests to uncover your skills and growth areas."
        )
        
        addFeatureRow(
            iconName: "trophy.fill",
            title: "Compete. Learn. Excel.",
            description: "Track progress and stay motivated with leaderboards and rewards."
        )
        
        // 3. Auth Buttons
        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .appTeal
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.cornerRadius = 14
        loginButton.layer.cornerCurve = .continuous
        loginButton.layer.shadowColor = UIColor.appTeal.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Sign Up Button
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.appTeal, for: .normal)
        signUpButton.backgroundColor = .systemBackground
        signUpButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        signUpButton.layer.cornerRadius = 14
        signUpButton.layer.cornerCurve = .continuous
        signUpButton.layer.borderWidth = 1.5
        signUpButton.layer.borderColor = UIColor.appTeal.cgColor
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Divider Stack
        dividerLabel.text = "or continue with"
        dividerLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dividerLabel.textColor = .secondaryLabel
        dividerLabel.textAlignment = .center
        
        leftDivider.backgroundColor = .systemGray5
        rightDivider.backgroundColor = .systemGray5
        
        leftDivider.translatesAutoresizingMaskIntoConstraints = false
        rightDivider.translatesAutoresizingMaskIntoConstraints = false
        
        dividerStack.axis = .horizontal
        dividerStack.spacing = 16
        dividerStack.alignment = .center
        dividerStack.distribution = .fill
        dividerStack.translatesAutoresizingMaskIntoConstraints = false
        
        dividerStack.addArrangedSubview(leftDivider)
        dividerStack.addArrangedSubview(dividerLabel)
        dividerStack.addArrangedSubview(rightDivider)
        
        // Social Stack
        socialStack.axis = .horizontal
        socialStack.spacing = 16
        socialStack.distribution = .fillEqually
        socialStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Google button styling
        googleButton.backgroundColor = .systemBackground
        googleButton.layer.borderWidth = 1
        googleButton.layer.borderColor = UIColor.systemGray4.cgColor
        googleButton.layer.cornerRadius = 12
        googleButton.layer.cornerCurve = .continuous
        googleButton.setTitle("  Google", for: .normal)
        googleButton.setTitleColor(.label, for: .normal)
        googleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        googleButton.tintColor = .label
        if let googleImg = UIImage(named: "google") {
            googleButton.setImage(googleImg.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        // Apple button styling
        appleButton.backgroundColor = .systemBackground
        appleButton.layer.borderWidth = 1
        appleButton.layer.borderColor = UIColor.systemGray4.cgColor
        appleButton.layer.cornerRadius = 12
        appleButton.layer.cornerCurve = .continuous
        appleButton.setTitle("  Apple", for: .normal)
        appleButton.setTitleColor(.label, for: .normal)
        appleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        appleButton.tintColor = .label
        appleButton.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        
        socialStack.addArrangedSubview(googleButton)
        socialStack.addArrangedSubview(appleButton)
        
        contentView.addSubview(logoContainer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(featuresStack)
        contentView.addSubview(loginButton)
        contentView.addSubview(signUpButton)
        contentView.addSubview(dividerStack)
        contentView.addSubview(socialStack)
    }
    
    private func addFeatureRow(iconName: String, title: String, description: String) {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 16
        container.alignment = .top
        
        let iconBackground = UIView()
        iconBackground.backgroundColor = UIColor.appTealLightBackground
        iconBackground.layer.cornerRadius = 20
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        iconView.image = UIImage(systemName: iconName, withConfiguration: config)
        iconView.tintColor = .appTeal
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        iconBackground.addSubview(iconView)
        
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 0
        
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(descLabel)
        
        container.addArrangedSubview(iconBackground)
        container.addArrangedSubview(labelStack)
        
        featuresStack.addArrangedSubview(container)
        
        NSLayoutConstraint.activate([
            iconBackground.widthAnchor.constraint(equalToConstant: 40),
            iconBackground.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Logo Container (graduation cap)
            logoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 64),
            logoContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 80),
            logoContainer.heightAnchor.constraint(equalToConstant: 80),
            
            logoImageView.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Features Stack
            featuresStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            featuresStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            featuresStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: featuresStack.bottomAnchor, constant: 56),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 14),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            signUpButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Divider Stack
            dividerStack.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 24),
            dividerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            dividerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            leftDivider.heightAnchor.constraint(equalToConstant: 1),
            rightDivider.heightAnchor.constraint(equalToConstant: 1),
            
            // Social Stack
            socialStack.topAnchor.constraint(equalTo: dividerStack.bottomAnchor, constant: 16),
            socialStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            socialStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            socialStack.heightAnchor.constraint(equalToConstant: 48),
            socialStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        googleButton.addTarget(self, action: #selector(socialTapped), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(socialTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        let storyboard = UIStoryboard(name: "SignUpLogIn", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @objc private func signUpTapped() {
        let storyboard = UIStoryboard(name: "SignUpLogIn", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    @objc private func socialTapped() {
        let alert = UIAlertController(title: "Coming Soon", message: "Social login is not implemented yet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

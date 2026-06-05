//
//  WelcomeViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // UI Elements
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let loginButton = UIButton(type: .system)
    private let signUpButton = UIButton(type: .system)
    
    private let dividerLabel = UILabel()
    
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
    }
    
    private func setupHierarchy() {
        // 1. Logo
        let config = UIImage.SymbolConfiguration(pointSize: 72, weight: .thin)
        logoImageView.image = UIImage(systemName: "graduationcap.fill", withConfiguration: config)
        logoImageView.tintColor = .appTeal
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        // 2. Title & Subtitle
        titleLabel.text = "GuideCS"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subtitleLabel.text = "Discover your strengths and build your future in your Computer Science journey."
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        // 3. Auth Buttons
        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .appTeal
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.layer.cornerRadius = 16
        loginButton.layer.cornerCurve = .continuous
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        // Sign Up Button
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.appTeal, for: .normal)
        signUpButton.backgroundColor = .systemBackground
        signUpButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        signUpButton.layer.cornerRadius = 16
        signUpButton.layer.cornerCurve = .continuous
        signUpButton.layer.borderWidth = 1.5
        signUpButton.layer.borderColor = UIColor.appTeal.cgColor
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        
        // Divider Label
        dividerLabel.text = "or continue with"
        dividerLabel.font = .systemFont(ofSize: 13, weight: .medium)
        dividerLabel.textColor = .tertiaryLabel
        dividerLabel.textAlignment = .center
        dividerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerLabel)
        
        // 4. Social Stack
        socialStack.axis = .horizontal
        socialStack.spacing = 12
        socialStack.distribution = .fillEqually
        socialStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Google button
        googleButton.backgroundColor = .systemGray6
        googleButton.layer.cornerRadius = 12
        googleButton.layer.cornerCurve = .continuous
        googleButton.setTitle("  Google", for: .normal)
        googleButton.setTitleColor(.label, for: .normal)
        googleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        googleButton.tintColor = .label
        if let googleImg = UIImage(named: "google") {
            googleButton.setImage(googleImg.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        // Apple button
        appleButton.backgroundColor = .systemGray6
        appleButton.layer.cornerRadius = 12
        appleButton.layer.cornerCurve = .continuous
        appleButton.setTitle("  Apple", for: .normal)
        appleButton.setTitleColor(.label, for: .normal)
        appleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        appleButton.tintColor = .label
        appleButton.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        
        socialStack.addArrangedSubview(googleButton)
        socialStack.addArrangedSubview(appleButton)
        view.addSubview(socialStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Login Button
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Sign Up Button
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 14),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signUpButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Divider
            dividerLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40),
            dividerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Social Stack
            socialStack.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: 16),
            socialStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            socialStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            socialStack.heightAnchor.constraint(equalToConstant: 50),
            socialStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
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

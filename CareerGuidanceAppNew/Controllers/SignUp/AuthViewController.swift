//
//  AuthViewController.swift
//  CareerGuidanceAppNew
//

import UIKit

class AuthViewController: UIViewController {
    
    // UI Elements
    private let titleLabel = UILabel()
    private let sheetView = UIView()
    private let toggleStackView = UIStackView()
    private let toggleLabel = UILabel()
    private let toggleButton = UIButton(type: .system)
    
    private let nameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    
    // Submit Button
    private let submitButton = UIButton(type: .system)
    
    // Avatars
    private let avatar1 = UIImageView()
    private let avatar2 = UIImageView()
    private let avatar3 = UIImageView()
    private let avatarLabel = UILabel()
    
    // Form stack
    private let formStack = UIStackView()
    
    private var isSignUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIForState()
        
        // Dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = .themeBg
        
        // 1. Top Section (Avatars + Title)
        setupAvatars()
        
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .textPrimary
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. Sheet View
        sheetView.backgroundColor = .cardBg
        sheetView.layer.cornerRadius = 40
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        // 3. Toggle area
        toggleStackView.axis = .horizontal
        toggleStackView.spacing = 4
        toggleStackView.alignment = .center
        
        toggleLabel.font = .systemFont(ofSize: 14)
        toggleLabel.textColor = .gray
        
        toggleButton.setTitleColor(.authLinkColor, for: .normal)
        toggleButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        toggleButton.addTarget(self, action: #selector(toggleAuthMode), for: .touchUpInside)
        
        toggleStackView.addArrangedSubview(toggleLabel)
        toggleStackView.addArrangedSubview(toggleButton)
        sheetView.addSubview(toggleStackView)
        toggleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 4. Form fields
        setupTextField(nameField, placeholder: "Full Name", icon: "person.fill")
        setupTextField(emailField, placeholder: "Email Address", icon: "envelope.fill")
        setupTextField(passwordField, placeholder: "Password", icon: "lock.fill", isSecure: true)
        
        formStack.axis = .vertical
        formStack.spacing = 16
        formStack.addArrangedSubview(nameField)
        formStack.addArrangedSubview(emailField)
        formStack.addArrangedSubview(passwordField)
        
        sheetView.addSubview(formStack)
        formStack.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Submit Button
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .accentTeal
        submitButton.layer.cornerRadius = 27
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        sheetView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    private func setupAvatars() {
        let colors: [UIColor] = [.systemPink, .systemTeal, .systemOrange]
        let avatars = [avatar1, avatar2, avatar3]
        
        for (index, avatar) in avatars.enumerated() {
            avatar.backgroundColor = colors[index].withAlphaComponent(0.3)
            avatar.layer.cornerRadius = 40
            avatar.layer.masksToBounds = true
            avatar.layer.borderWidth = 2
            avatar.layer.borderColor = colors[index].cgColor
            avatar.contentMode = .center
            avatar.tintColor = colors[index]
            avatar.image = UIImage(systemName: "person.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40))
            
            view.addSubview(avatar)
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.widthAnchor.constraint(equalToConstant: 80).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
        
        NSLayoutConstraint.activate([
            avatar1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatar1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            
            avatar2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatar2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            
            avatar3.topAnchor.constraint(equalTo: avatar1.bottomAnchor, constant: -20),
            avatar3.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        avatarLabel.text = "Hello!"
        avatarLabel.backgroundColor = UIColor.accentTeal.withAlphaComponent(0.3)
        avatarLabel.textColor = .textPrimary
        avatarLabel.font = .boldSystemFont(ofSize: 16)
        avatarLabel.textAlignment = .center
        avatarLabel.layer.cornerRadius = 16
        avatarLabel.layer.masksToBounds = true
        view.addSubview(avatarLabel)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatar3.topAnchor),
            avatarLabel.widthAnchor.constraint(equalToConstant: 80),
            avatarLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupTextField(_ tf: UITextField, placeholder: String, icon: String, isSecure: Bool = false) {
        tf.backgroundColor = UIColor.progressTrackBg
        tf.textColor = .textPrimary
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = isSecure
        tf.autocapitalizationType = .none
        
        let placeholderAttr = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        tf.attributedPlaceholder = placeholderAttr
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        let imgView = UIImageView(image: UIImage(systemName: icon))
        imgView.tintColor = .gray
        imgView.contentMode = .center
        imgView.frame = CGRect(x: 12, y: 0, width: 20, height: 50)
        leftView.addSubview(imgView)
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        tf.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        if isSecure {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
            let eyeBtn = UIButton(type: .custom)
            eyeBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            eyeBtn.setImage(UIImage(systemName: "eye.fill"), for: .selected)
            eyeBtn.tintColor = .gray
            eyeBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 50)
            eyeBtn.addTarget(self, action: #selector(toggleEye(_:)), for: .touchUpInside)
            rightView.addSubview(eyeBtn)
            tf.rightView = rightView
            tf.rightViewMode = .always
        }
    }
    
    @objc private func toggleEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordField.isSecureTextEntry.toggle()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: avatar3.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Sheet
            sheetView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Toggle
            toggleStackView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 30),
            toggleStackView.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            
            // Form Stack
            formStack.topAnchor.constraint(equalTo: toggleStackView.bottomAnchor, constant: 30),
            formStack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            formStack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            
            // Submit Button
            submitButton.topAnchor.constraint(equalTo: toggleStackView.bottomAnchor, constant: 250),
            submitButton.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    @objc private func toggleAuthMode() {
        isSignUp.toggle()
        updateUIForState()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateUIForState() {
        if isSignUp {
            titleLabel.text = "Let's get you\nsigned up!"
            toggleLabel.text = "Already have an account?"
            toggleButton.setTitle("Sign In", for: .normal)
            submitButton.setTitle("Sign Up", for: .normal)
            
            nameField.isHidden = false
        } else {
            titleLabel.text = "Let's get you\nsigned in!"
            toggleLabel.text = "You don't have an account yet?"
            toggleButton.setTitle("Sign Up", for: .normal)
            submitButton.setTitle("Sign In", for: .normal)
            
            nameField.isHidden = true
        }
    }
    
    @objc private func submitTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert("Please fill in all required fields.")
            return
        }
        
        submitButton.isEnabled = false
        let originalTitle = submitButton.title(for: .normal)
        submitButton.setTitle("Processing...", for: .normal)
        
        Task {
            do {
                if isSignUp {
                    guard let name = nameField.text, !name.isEmpty else {
                        DispatchQueue.main.async {
                            self.showAlert("Please enter your name.")
                            self.resetButton(title: originalTitle)
                        }
                        return
                    }
                    try await AuthService.shared.signUp(email: email, password: password, fullName: name)
                } else {
                    try await AuthService.shared.signIn(email: email, password: password)
                }
                
                DispatchQueue.main.async {
                    self.navigateToNextScreen()
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.resetButton(title: originalTitle)
                    self.showAlert(error.localizedDescription)
                }
            }
        }
    }
    
    private func resetButton(title: String?) {
        submitButton.isEnabled = true
        submitButton.setTitle(title, for: .normal)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToNextScreen() {
        Task {
            await ProfileService.shared.syncRemoteToLocal()
            
            DispatchQueue.main.async {
                if !OnboardingManager.shared.isOnboardingCompleted {
                    if let onboardingVC = OnboardingManager.shared.getNextViewController() {
                        let nav = UINavigationController(rootViewController: onboardingVC)
                        nav.navigationBar.prefersLargeTitles = true
                        
                        guard let window = self.view.window else { return }
                        window.rootViewController = nav
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                    } else {
                        // Fallback
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let startVC = storyboard.instantiateViewController(withIdentifier: "introVC") as? onboardingSectionIntroViewController {
                            startVC.sectionIndex = 0
                            let nav = UINavigationController(rootViewController: startVC)
                            nav.navigationBar.prefersLargeTitles = true
                            
                            guard let window = self.view.window else { return }
                            window.rootViewController = nav
                            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                        }
                    }
                } else {
                    let homeStoryboard = UIStoryboard(name: "HomePageProfileNew", bundle: nil)
                    if let homeVC = homeStoryboard.instantiateInitialViewController() {
                        guard let window = self.view.window else { return }
                        window.rootViewController = homeVC
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                    }
                }
            }
        }
    }
}

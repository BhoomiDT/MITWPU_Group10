//
//  SignUpViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmEyeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircularBackButton()
        setUpPasswordToggle()
        styleTextField(nameInput)
        styleTextField(emailInput)
        styleTextField(passwordTextField)
        styleTextField(confirmPasswordTextField)
        stylePrimaryButton(registerButton)
        hideSocialLogin()
        adjustFormSpacing()
    }
    
    private func addCircularBackButton() {
        var buttonConfig = UIButton.Configuration.plain()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        buttonConfig.image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfig)
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -2, bottom: 0, trailing: 0)
        
        let backBtn = UIButton(configuration: buttonConfig, primaryAction: nil)
        backBtn.tintColor = .appTeal
        backBtn.backgroundColor = .systemGray6
        backBtn.layer.cornerRadius = 22
        backBtn.clipsToBounds = true
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)
        
        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backBtn.widthAnchor.constraint(equalToConstant: 44),
            backBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func backTapped() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.systemGray4.cgColor
        button1.layer.cornerRadius = 8
        button1.layer.cornerCurve = .continuous
        
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.systemGray4.cgColor
        button2.layer.cornerRadius = 8
        button2.layer.cornerCurve = .continuous
    }
    
    private func styleTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 14
        textField.layer.cornerCurve = .continuous
        
        // Height constraint
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Teal border
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.appTeal.cgColor
    }
    
    private func stylePrimaryButton(_ button: UIButton) {
        button.backgroundColor = .appTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.cornerCurve = .continuous
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        // Flat premium look
        button.layer.shadowOpacity = 0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func setUpPasswordToggle() {
        confirmEyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        confirmEyeButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        confirmEyeButton.addTarget(self, action: #selector(confirmTogglePasswordVisibility(_:)), for: .touchUpInside)
        
        confirmPasswordTextField.rightView = confirmEyeButton
        confirmPasswordTextField.rightViewMode = .always
        
        
        eyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            
            passwordTextField.rightView = eyeButton
            passwordTextField.rightViewMode = .always
        
    }
    func registerUser() {
        guard let _ = nameInput.text, !nameInput.text!.isEmpty,
              let email = emailInput.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            showAppAlert(title: "Error", message: "All fields are required")
            return
        }
        
        guard password == confirmPassword else {
            showAppAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        Task {
            do {
                // 1. Sign up normally with full name
                let fullName = nameInput.text
                try await AuthService.shared.signUp(email: email, password: password, fullName: fullName)
                
                // 2. Get user ID
                guard let userId = UserSessionManager.shared.userId else {
                    showAppAlert(title: "Error", message: "Could not retrieve user session.")
                    return
                }
                
                // 3. Trigger MFA OTP
                try await AuthService.shared.sendMFAOTP(email: email, userId: userId)
                
                // 4. Navigate to OTP Screen
                DispatchQueue.main.async {
                    let otpVC = OTPViewController()
                    otpVC.email = email
                    otpVC.userId = userId
                    if let nav = self.navigationController {
                        nav.pushViewController(otpVC, animated: true)
                    } else {
                        otpVC.modalPresentationStyle = .fullScreen
                        self.present(otpVC, animated: true)
                    }
                }
                
            } catch {
                showAppAlert(title: "Sign Up Failed", message: error.localizedDescription)
            }
        }
    }

    @objc func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func confirmTogglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        print("🚀 Register button tapped")
        registerUser()
    }
    
    @IBAction func socialLoginTapped(_ sender: UIButton) {
        showAppAlert(title: "Coming Soon", message: "Social login is not implemented yet.")
    }
    
    @IBAction func switchToLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUpLogIn", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            if let nav = self.navigationController {
                var vcs = nav.viewControllers
                if vcs.last == self {
                    vcs.removeLast()
                    vcs.append(loginVC)
                    nav.setViewControllers(vcs, animated: true)
                } else {
                    nav.pushViewController(loginVC, animated: true)
                }
            } else {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
    
    private func hideSocialLogin() {
        button1.isHidden = true
        button2.isHidden = true
        
        func hideOrLabel(in view: UIView) {
            if let label = view as? UILabel, label.text == "or continue with" {
                label.isHidden = true
                return
            }
            for subview in view.subviews {
                hideOrLabel(in: subview)
            }
        }
        hideOrLabel(in: view)
    }
    
    private func adjustFormSpacing() {
        func findStackView(in view: UIView) -> UIStackView? {
            if let stack = view as? UIStackView { return stack }
            for subview in view.subviews {
                if let found = findStackView(in: subview) { return found }
            }
            return nil
        }
        
        if let mainStack = findStackView(in: view) {
            mainStack.spacing = 24
            for arrangedSubview in mainStack.arrangedSubviews {
                if let fieldStack = arrangedSubview as? UIStackView {
                    fieldStack.spacing = 8
                    for fieldSubview in fieldStack.arrangedSubviews {
                        if let label = fieldSubview as? UILabel {
                            label.font = .systemFont(ofSize: 15, weight: .semibold)
                            label.textColor = .secondaryLabel
                            if label.text == "Email Id" {
                                label.text = "Email Address"
                            }
                        }
                    }
                }
            }
        }
    }
}

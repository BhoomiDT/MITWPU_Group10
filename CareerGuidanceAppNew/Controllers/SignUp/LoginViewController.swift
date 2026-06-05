//
//  LoginViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 16/12/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCircularBackButton()
        setUpPasswordToggle()
        styleTextField(emailTextField)
        styleTextField(passwordTextField)
        stylePrimaryButton(loginButton)
        styleSecondaryActions()
        hideSocialLogin()
        adjustFormSpacing()
    }
    
    private func addCircularBackButton() {
        var buttonConfig = UIButton.Configuration.plain()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        buttonConfig.image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfig)
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -2, bottom: 0, trailing: 0)
        
        let backBtn = UIButton(configuration: buttonConfig, primaryAction: nil)
        backBtn.tintColor = .appTeal
        backBtn.backgroundColor = .systemBackground
        backBtn.layer.cornerRadius = 19
        backBtn.layer.borderWidth = 1.0
        backBtn.layer.borderColor = UIColor.appTeal.cgColor
        backBtn.clipsToBounds = true
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)
        
        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backBtn.widthAnchor.constraint(equalToConstant: 38),
            backBtn.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    @objc private func backTapped() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }

    private func styleSecondaryActions() {
        // We'll find the labels/buttons by text or tag if they don't have outlets
        // In the storyboard they are there. I'll add outlets in the next step.
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
        eyeButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
            eyeButton.addTarget(self, action:#selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            passwordTextField.rightView = eyeButton
            passwordTextField.rightViewMode = .always
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("🚀 Login button tapped")
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAppAlert(title: "Error", message: "Please enter both email and password.")
            return
        }
        
        Task {
            do {
                // 1. Sign in normally
                try await AuthService.shared.signIn(email: email, password: password)
                
                // 2. Get the user ID from session
                guard let userId = UserSessionManager.shared.userId else {
                    showAppAlert(title: "Error", message: "Could not retrieve user session.")
                    return
                }
                
                // 3. Trigger MFA OTP via Edge Function
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
                showAppAlert(title: "Login Failed", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func socialLoginTapped(_ sender: UIButton) {
        showAppAlert(title: "Coming Soon", message: "Social login is not implemented yet.")
    }
    
    @IBAction func switchToSignup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUpLogIn", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            if let nav = self.navigationController {
                var vcs = nav.viewControllers
                if vcs.last == self {
                    vcs.removeLast()
                    vcs.append(signupVC)
                    nav.setViewControllers(vcs, animated: true)
                } else {
                    nav.pushViewController(signupVC, animated: true)
                }
            } else {
                signupVC.modalPresentationStyle = .fullScreen
                self.present(signupVC, animated: true)
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

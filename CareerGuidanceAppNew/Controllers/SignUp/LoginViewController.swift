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
    }
    
    private func addCircularBackButton() {
        let backBtn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backBtn.setImage(image, for: .normal)
        backBtn.tintColor = .appTeal
        backBtn.backgroundColor = .systemGray5
        backBtn.layer.cornerRadius = 20
        backBtn.clipsToBounds = true
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)
        
        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backBtn.widthAnchor.constraint(equalToConstant: 40),
            backBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func backTapped() {
        self.dismiss(animated: true)
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
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        
        // Height constraint
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Add a subtle border to make it pop
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func stylePrimaryButton(_ button: UIButton) {
        let themeColor = UIColor(red: 31/255, green: 165/255, blue: 161/255, alpha: 1.0)
        button.backgroundColor = themeColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.cornerCurve = .continuous
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        button.layer.shadowColor = themeColor.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
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
                    otpVC.modalPresentationStyle = .fullScreen
                    self.present(otpVC, animated: true)
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
            signupVC.modalPresentationStyle = .fullScreen
            self.present(signupVC, animated: true)
        }
    }
}

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
        setUpPasswordToggle()
        styleTextField(nameInput)
        styleTextField(emailInput)
        styleTextField(passwordTextField)
        styleTextField(confirmPasswordTextField)
        stylePrimaryButton(registerButton)
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
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10
        textField.layer.cornerCurve = .continuous
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
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
                try await AuthService.shared.signUp(email: email, password: password)
                // Optionally save the profile name to a 'profiles' table here if you have one
                self.navigateToHome()
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
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
    }
}

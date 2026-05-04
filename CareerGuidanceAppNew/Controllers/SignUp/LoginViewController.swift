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
        setUpPasswordToggle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor(hex:"#CAC4D0").cgColor
        button1.layer.cornerRadius = 6

        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor(hex:"#CAC4D0").cgColor
        button2.layer.cornerRadius = 6
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
                try await AuthService.shared.signIn(email: email, password: password)
                self.navigateToHome()
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

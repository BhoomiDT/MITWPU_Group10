//
//  WelcomeViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 15/12/25.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheetPresentation()
        addAuthButtons()
    }

    private func addAuthButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let loginBtn = UIButton(type: .system)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        loginBtn.setTitleColor(.appTeal, for: .normal)
        loginBtn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        let signUpBtn = UIButton(type: .system)
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        signUpBtn.setTitleColor(.appTeal, for: .normal)
        signUpBtn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(loginBtn)
        stackView.addArrangedSubview(signUpBtn)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 280),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func loginTapped() {
        let storyboard = UIStoryboard(name: "SignUpLogIn", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
    }

    @objc func signUpTapped() {
        let storyboard = UIStoryboard(name: "SignUpLogIn", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            signUpVC.modalPresentationStyle = .fullScreen
            self.present(signUpVC, animated: true)
        }
    }

    private func setupSheetPresentation() {
        if let sheet = self.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.75
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32
        }
    }
}

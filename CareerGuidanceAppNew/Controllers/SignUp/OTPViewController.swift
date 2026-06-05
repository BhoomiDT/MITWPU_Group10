import UIKit

class OTPViewController: UIViewController {
    
    var email: String?
    var userId: UUID?
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let otpTextField = UITextField()
    private let verifyButton = UIButton()
    private let resendButton = UIButton()
    private let backButton = UIButton()
    
    private let themeColor = UIColor(red: 31/255, green: 165/255, blue: 161/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Back Button
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.tintColor = themeColor
        backButton.backgroundColor = .systemGray5
        backButton.layer.cornerRadius = 20
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        // Title
        titleLabel.text = "Verification"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .left
        
        // Subtitle
        subtitleLabel.text = "We've sent a 6-digit verification code to\n\(email ?? "your email")"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .left
        
        // OTP Field (Modern styling)
        otpTextField.placeholder = "● ● ● ● ● ●"
        otpTextField.font = .monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        otpTextField.textAlignment = .center
        otpTextField.keyboardType = .numberPad
        otpTextField.backgroundColor = .secondarySystemBackground
        otpTextField.layer.cornerRadius = 14
        otpTextField.layer.cornerCurve = .continuous
        otpTextField.textContentType = .oneTimeCode
        
        // Verify Button (Premium Teal)
        verifyButton.setTitle("Verify Code", for: .normal)
        verifyButton.backgroundColor = themeColor
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.layer.cornerRadius = 14
        verifyButton.layer.cornerCurve = .continuous
        verifyButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        verifyButton.layer.shadowColor = themeColor.cgColor
        verifyButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        verifyButton.layer.shadowOpacity = 0.3
        verifyButton.layer.shadowRadius = 8
        verifyButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        
        // Resend Button
        resendButton.setTitle("Resend Code", for: .normal)
        resendButton.setTitleColor(themeColor, for: .normal)
        resendButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        resendButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        
        // Layout
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, otpTextField, verifyButton, resendButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.setCustomSpacing(12, after: titleLabel)
        stackView.setCustomSpacing(40, after: subtitleLabel)
        stackView.setCustomSpacing(32, after: otpTextField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            otpTextField.heightAnchor.constraint(equalToConstant: 70),
            verifyButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func backTapped() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func verifyTapped() {
        guard let otp = otpTextField.text, otp.count == 6, let email = email else {
            let alert = UIAlertController(title: "Invalid Code", message: "Please enter a valid 6-digit code.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        // Show loading indicator or disable button
        verifyButton.isEnabled = false
        verifyButton.alpha = 0.7
        
        Task {
            do {
                let success = try await AuthService.shared.verifyMFAOTP(email: email, otp: otp)
                if success {
                    DispatchQueue.main.async {
                        self.navigateToHome()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.verifyButton.isEnabled = true
                    self.verifyButton.alpha = 1.0
                    let alert = UIAlertController(title: "Verification Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func resendTapped() {
        guard let email = email, let userId = userId else { return }
        
        Task {
            do {
                try await AuthService.shared.sendMFAOTP(email: email, userId: userId)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sent", message: "A new code has been sent to your email.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            } catch {
                print("Error resending OTP: \(error)")
            }
        }
    }
}

import UIKit
import Supabase

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile()
}

class EditProfileViewController: UIViewController {
    
    weak var delegate: EditProfileDelegate?
    private var currentProfile: UserProfile?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private func createTextField(placeholder: String, isEditable: Bool = true) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .none
        tf.backgroundColor = .clear // Background is handled by the container card now
        tf.font = .systemFont(ofSize: 17, weight: .regular)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.isUserInteractionEnabled = isEditable
        if !isEditable {
            tf.textColor = .secondaryLabel
        }
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }
    
    private lazy var nameTextField = createTextField(placeholder: "Full Name")
    private lazy var emailTextField = createTextField(placeholder: "Email Address", isEditable: false)
    private lazy var phoneTextField = createTextField(placeholder: "Phone Number")
    private lazy var dobTextField = createTextField(placeholder: "Date of Birth (YYYY-MM-DD)")
    private lazy var genderTextField = createTextField(placeholder: "Gender")
    private lazy var degreeTextField = createTextField(placeholder: "College Degree")
    private lazy var bioTextField = createTextField(placeholder: "Bio")
    private lazy var linkedinTextField = createTextField(placeholder: "LinkedIn URL")
    private lazy var githubTextField = createTextField(placeholder: "GitHub URL")
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Profile", for: .normal)
        let themeColor = UIColor(red: 31/255, green: 165/255, blue: 161/255, alpha: 1.0)
        btn.backgroundColor = themeColor
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 14
        btn.layer.cornerCurve = .continuous
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        btn.layer.shadowColor = themeColor.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowRadius = 8
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return btn
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .white
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCurrentProfile()
    }
    
    private func createCard(with textFields: [UITextField]) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 12
        card.layer.cornerCurve = .continuous
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: textFields)
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        
        // Add separators between fields inside the card
        for (index, field) in textFields.enumerated() {
            if index < textFields.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .separator
                separator.translatesAutoresizingMaskIntoConstraints = false
                field.addSubview(separator)
                NSLayoutConstraint.activate([
                    separator.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 16),
                    separator.trailingAnchor.constraint(equalTo: field.trailingAnchor),
                    separator.bottomAnchor.constraint(equalTo: field.bottomAnchor),
                    separator.heightAnchor.constraint(equalToConstant: 0.5)
                ])
            }
        }
        
        return card
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Personal Details"
        
        if let nav = navigationController, nav.viewControllers.first == self {
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
            let xmark = UIImage(systemName: "xmark", withConfiguration: config)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: xmark, style: .plain, target: self, action: #selector(cancelTapped))
            navigationItem.leftBarButtonItem?.tintColor = .secondaryLabel
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let accountCard = createCard(with: [nameTextField, emailTextField])
        let detailsCard = createCard(with: [phoneTextField, dobTextField, genderTextField])
        let educationCard = createCard(with: [degreeTextField, bioTextField])
        let linksCard = createCard(with: [linkedinTextField, githubTextField])
        
        let stackView = UIStackView(arrangedSubviews: [
            createSectionLabel("ACCOUNT"), accountCard,
            createSectionLabel("PERSONAL INFO"), detailsCard,
            createSectionLabel("EDUCATION & BIO"), educationCard,
            createSectionLabel("SOCIAL LINKS"), linksCard,
            saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.setCustomSpacing(8, after: stackView.arrangedSubviews[0])
        stackView.setCustomSpacing(8, after: stackView.arrangedSubviews[2])
        stackView.setCustomSpacing(8, after: stackView.arrangedSubviews[4])
        stackView.setCustomSpacing(8, after: stackView.arrangedSubviews[6])
        stackView.setCustomSpacing(40, after: linksCard)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        saveButton.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func createSectionLabel(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .secondaryLabel
        return lbl
    }
    
    @objc private func cancelTapped() {
        if let nav = navigationController, nav.viewControllers.first == self {
            if let parent = nav.parent {
                nav.willMove(toParent: nil)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    nav.view.transform = CGAffineTransform(translationX: parent.view.bounds.width, y: 0)
                } completion: { _ in
                    nav.view.removeFromSuperview()
                    nav.removeFromParent()
                }
            } else {
                dismiss(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    private func fetchCurrentProfile() {
        Task {
            if let user = try? await SupabaseManager.shared.client.auth.session.user {
                DispatchQueue.main.async {
                    self.emailTextField.text = user.email
                }
            }
            
            do {
                let profile = try await ProfileService.shared.fetchProfile()
                self.currentProfile = profile
                DispatchQueue.main.async {
                    self.nameTextField.text = profile.full_name
                    self.phoneTextField.text = profile.phone
                    self.dobTextField.text = profile.dob
                    self.genderTextField.text = profile.gender
                    self.degreeTextField.text = profile.college_degree
                    self.bioTextField.text = profile.bio
                    self.linkedinTextField.text = profile.linkedin_url
                    self.githubTextField.text = profile.github_url
                }
            } catch {
                print("Failed to fetch profile: \(error)")
            }
        }
    }
    
    @objc private func saveTapped() {
        let fullName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dob = dobTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let gender = genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let degree = degreeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let bio = bioTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let linkedin = linkedinTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let github = githubTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        saveButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        
        Task {
            do {
                guard let user = try? await SupabaseManager.shared.client.auth.session.user else {
                    throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
                }
                
                var profile = self.currentProfile ?? UserProfile(
                    id: user.id,
                    email: user.email,
                    full_name: nil,
                    technical_skills: nil,
                    riasec_scores: nil,
                    onboarding_completed: nil,
                    recommended_domain: nil,
                    learning_streak: nil,
                    completed_quizzes: nil,
                    learning_days: nil,
                    quests_completed: nil,
                    xp: nil,
                    phone: nil,
                    dob: nil,
                    gender: nil,
                    college_degree: nil,
                    career_interests: nil,
                    bio: nil,
                    resume_url: nil,
                    linkedin_url: nil,
                    github_url: nil,
                    app_settings: nil
                )
                
                profile.full_name = fullName?.isEmpty == true ? nil : fullName
                profile.phone = phone?.isEmpty == true ? nil : phone
                profile.dob = dob?.isEmpty == true ? nil : dob
                profile.gender = gender?.isEmpty == true ? nil : gender
                profile.college_degree = degree?.isEmpty == true ? nil : degree
                profile.bio = bio?.isEmpty == true ? nil : bio
                profile.linkedin_url = linkedin?.isEmpty == true ? nil : linkedin
                profile.github_url = github?.isEmpty == true ? nil : github
                
                try await ProfileService.shared.updateProfile(profile)
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.saveButton.setTitle("Save Profile", for: .normal)
                    self.saveButton.isEnabled = true
                    
                    self.delegate?.didUpdateProfile()
                    
                    if let nav = self.navigationController, nav.viewControllers.first != self {
                        nav.popViewController(animated: true)
                    } else if let nav = self.navigationController, nav.viewControllers.first == self, let parent = nav.parent {
                        nav.willMove(toParent: nil)
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                            nav.view.transform = CGAffineTransform(translationX: parent.view.bounds.width, y: 0)
                        } completion: { _ in
                            nav.view.removeFromSuperview()
                            nav.removeFromParent()
                        }
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.saveButton.setTitle("Save Profile", for: .normal)
                    self.saveButton.isEnabled = true
                    
                    let alert = UIAlertController(title: "Error", message: "Failed to save profile: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

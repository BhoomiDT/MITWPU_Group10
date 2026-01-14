import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewForIcon: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private let sections = ProfileSection.sampleData
    private let user = UserProfile.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCloseButton()
    }
    
   
    private func setupCloseButton() {

        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 18
        blurView.clipsToBounds = true

        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)

        blurView.contentView.addSubview(closeButton)
        view.addSubview(blurView)

        NSLayoutConstraint.activate([
            // Blur container
            blurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            blurView.widthAnchor.constraint(equalToConstant: 36),
            blurView.heightAnchor.constraint(equalToConstant: 36),

            // Button inside blur
            closeButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            closeButton.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Optional subtle border
        blurView.layer.borderWidth = 0.5
        blurView.layer.borderColor = UIColor.separator.cgColor
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        profileImage.image = UIImage(systemName: user.imageName, withConfiguration: config)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = title
        cell.textLabel?.font = .systemFont(ofSize: 16)
        
        if title == "Log Out" {
            cell.textLabel?.textColor = .systemRed
            cell.backgroundColor = .white
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
        } else {
            cell.textLabel?.textColor = .label
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if sections[indexPath.section].options[indexPath.row] == "Log Out" {
            print("Logout Tapped")
        }
    }
}
